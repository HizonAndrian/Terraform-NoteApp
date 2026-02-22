import os

# Simulate requests to your FastAPI app without actually running a server.
from fastapi.testclient import TestClient
from motor.motor_asyncio import AsyncIOMotorClient

from app.main import app
from app.db import main_database

MONGO_USER     = os.getenv("MONGO_USER")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD")
MONGO_HOST     = os.getenv("MONGO_HOST")
MONGO_DB       = os.getenv("MONGO_DB")

MONGO_URL = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@{MONGO_HOST}:27017/{MONGO_DB}?authSource=admin"


def override_main_database():
    db_client = AsyncIOMotorClient(MONGO_URL) # Create a connection with MongoDB using the URL above
    return db_client.get_database()           # Select the database

app.dependency_overrides[main_database] = override_main_database

client = TestClient(app)

def test_post():
    response = client.post("/note", 
                           json={
                               "title": "Test Note", 
                               "description": "This is a test note.", 
                               "done": False
                               })
    assert response.status_code == 201
    assert response.json()["title"] == "Test Note"
    assert response.json()["description"] == "This is a test note."
    assert response.json()["done"] is False