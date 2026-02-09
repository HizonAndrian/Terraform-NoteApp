from pydantic import BaseModel
from bson import ObjectId
from pymongo import ReturnDocument
from .db import get_database
from fastapi import APIRouter, Depends

router = APIRouter()

# Pydantic model for creating note item.
class note_item(BaseModel):
    id: str | None = None
    title: str
    description: str
    done: bool

# Pydantic model for updating note item.
class update_item(BaseModel):
    title: str | None = None
    description: str | None = None
    done: bool | None = None

@router.get("/")
async def root():
    return {"status_code": "200"}


@router.post("/note", response_model=note_item, status_code=201)
async def create_note(note: note_item, db = Depends(get_database)):
    # Insert the note into MongoDB.
    result = await db.notes.insert_one(note.model_dump())
    created_note = note.model_dump()
    created_note["id"] = str(result.inserted_id)
    return created_note

@router.get("/notes")
async def get_note(db = Depends(get_database)):
    # Create a list to hold notes.
    notes_collected = []
    # Retrieve notes from MongoDB.
    notes_reference = db.notes.find()
    async for note in notes_reference:
        # Convert ObjectId to string.
        note["id"] = str(note["_id"])
        # Remove the _id field from the note. It can cause error.
        note.pop("_id")
        notes_collected.append(note)
    return notes_collected

@router.get("/note/{id}")
async def get_note_id(id: str, db = Depends(get_database)):
    note = await db.notes.find_one({"_id": ObjectId(id)})
    if note is not None:
        # Convert ObjectId to string.
        note["id"] = str(note["_id"])
        note.pop("_id")
        return note
    return {"error": "Note not found"}


@router.put("/note/{id}")
async def update_note(id: str, item: update_item, db = Depends(get_database)):

    # Focus on the BODY of the request.
    # Create a dictionary to hold the fields to be updated. 
    # Fields that are not NONE.
    target_note = {
        k: v # return key and value pair
        for k, v in item.model_dump().items() #
        if v not in (None, "", " ") # if value is not None or empty string
    }

    if len(target_note) >= 1:
        update_target = await db.notes.find_one_and_update(
            {"_id": ObjectId(id)},
            {"$set": target_note},
            return_document=ReturnDocument.AFTER
        )
        if update_target is not None:
            update_target["id"] = str(update_target["_id"])
            update_target.pop("_id")
            return update_target
        else:
            return {"error": "Note not found"}


@router.delete("/note/{id}")
async def delete_note(id: str, db = Depends(get_database)):

    delete_target = await db.notes.delete_one({"_id": ObjectId(id)})
    if delete_target.deleted_count == 1:
        return {"message": "Note deleted successfully"}
    else:
        return {"error": "Note not found"}