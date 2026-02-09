import os
from fastapi.testclient import TestClient
from app.main import app
from app.db import get_database
from motor.motor_asyncio import AsyncIOMotorClient

MONGO_USER = os.environ["MONGO_USER"]
MONGO_PASSWORD = os.environ["MONGO_PASSWORD"]
MONGO_HOST = os.environ["MONGO_HOST"]
MONGO_DB = os.environ["MONGO_DB"]

MONGO_URL = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@{MONGO_HOST}:27017/{MONGO_DB}"


def override_get_database():
    db_client = AsyncIOMotorClient(MONGO_URL)
    return db_client.get_database()

app.dependency_overrides[get_database] = override_get_database

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