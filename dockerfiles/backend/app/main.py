import os
from fastapi import FastAPI
from pydantic import BaseModel
from motor.motor_asyncio import AsyncIOMotorClient
from pymongo import ReturnDocument
from bson import ObjectId
from fastapi.middleware.cors import CORSMiddleware

# Pydantic model for creating note item.
class note_item(BaseModel):
    title: str
    description: str
    done: bool

# Pydantic model for updating note item.
class update_item(BaseModel):
    title: str | None = None
    description: str | None = None
    done: bool | None = None

app = FastAPI() 

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

MONGO_URL = f"mongodb://{os.getenv('MONGO_USERNAME')}:"\
            f"{os.getenv('MONGO_PASSWORD')}@"\
            f"{os.getenv('MONGO_HOST')}:{os.getenv('MONGO_PORT')}/"\
            f"{os.getenv('MONGO_DB')}"\
            f"?authSource=admin"

# FULL URL:
# MONGO_URL = "mongodb://noteappadmin:noteappsecret@mongodb:27017/noteappdb?authSource=admin"

client = AsyncIOMotorClient(MONGO_URL)
note_db = client.get_database()

@app.get("/")
async def root():
    return {"status": "ok"}


@app.post("/note", response_model=note_item, status_code=201)
async def create_note(note: note_item):
    # Insert the note into MongoDB.
    result = await note_db.notes.insert_one(note.model_dump())
    created_note = note.model_dump()
    created_note["id"] = str(result.inserted_id)
    return created_note

@app.get("/notes")
async def get_note():
    # Create a list to hold notes.
    notes_collected = []
    # Retrieve notes from MongoDB.
    notes_reference = note_db.notes.find()
    async for note in notes_reference:
        # Convert ObjectId to string.
        note["id"] = str(note["_id"])
        # Remove the _id field from the note. It can cause error.
        note.pop("_id")
        notes_collected.append(note)
    return notes_collected

@app.get("/note/{id}")
async def get_note_id(id: str):
    note = await note_db.notes.find_one({"_id": ObjectId(id)})
    if note is not None:
        # Convert ObjectId to string.
        note["id"] = str(note["_id"])
        note.pop("_id")
        return note
    return {"error": "Note not found"}



@app.put("/note/{id}")
async def update_note(id: str, item: update_item):

    # Focus on the BODY of the request.
    # Create a dictionary to hold the fields to be updated. 
    # Fields that are not NONE.
    target_note = {
        k: v # return key and value pair
        for k, v in item.model_dump().items() #
        if v not in (None, "", " ") # if value is not None or empty string
    }

    if len(target_note) >= 1:
        update_target = await note_db.notes.find_one_and_update(
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



@app.delete("/note/{id}")
async def delete_note(id: str):

    delete_target = await note_db.notes.delete_one({"_id": ObjectId(id)})
    if delete_target.deleted_count == 1:
        return {"message": "Note deleted successfully"}
    else:
        return {"error": "Note not found"}