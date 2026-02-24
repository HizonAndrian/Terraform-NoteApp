import os
from fastapi.testclient import TestClient
from motor.motor_asyncio import AsyncIOMotorClient

from app.main import app
from app.db import main_database


# -------------------------
# Test database dependency
# -------------------------
MONGO_USER     = os.getenv("MONGO_USER")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD")
MONGO_HOST     = os.getenv("MONGO_HOST")
MONGO_DB       = os.getenv("MONGO_DB")

MONGO_URL = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@{MONGO_HOST}:27017/{MONGO_DB}?authSource=admin"


async def override_main_database(db_name="noteapp_db_test"):
    db_client = AsyncIOMotorClient(MONGO_URL) # Create a connection with MongoDB using the URL above
    return db_client.get_database(db_name)    # Select the database

app.dependency_overrides[main_database] = override_main_database

client = TestClient(app)


# -------------------------
# Helpers
# -------------------------
def create_test_note():
    response = client.post(
        "/note",
        json={
            "title": "Test Note",
            "description": "Test Description",
            "done": False
        }
    )
    assert response.status_code == 201
    return response.json()

# -------------------------
# Tests
# -------------------------
def test_get_all_notes():
    response = client.get("/notes")

    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_get_note_by_id_success():
    note = create_test_note()
    note_id = note["id"]

    response = client.get(f"/note/{note_id}")

    assert response.status_code == 200
    assert response.json()["id"] == note_id
    assert response.json()["title"] == "Test Note"


def test_get_note_by_id_not_found():
    fake_id = "000000000000000000000000"

    response = client.get(f"/note/{fake_id}")

    assert response.status_code == 200
    assert response.json() == {"error": "Note not found"}
