# from fastapi.testclient import TestClient
# from motor.motor_asyncio import AsyncIOMotorClient

# from backend.app.main import app
# from backend.app.db import get_database


# # -------------------------
# # Test database dependency
# # -------------------------
# MONGO_URL = "mongodb://noteapptester:noteappsecret@host.docker.internal:27017/noteappdb?authSource=admin"

# async def get_test_database():
#     client = AsyncIOMotorClient(MONGO_URL)
#     return client.get_database()


# # Override dependency
# app.dependency_overrides[get_database] = get_test_database

# client = TestClient(app)


# # -------------------------
# # Helpers
# # -------------------------
# def create_test_note():
#     response = client.post(
#         "/note",
#         json={
#             "title": "Test Note",
#             "description": "Test Description",
#             "done": False
#         }
#     )
#     assert response.status_code == 201
#     return response.json()

# # -------------------------
# # Tests
# # -------------------------
# def test_get_all_notes():
#     response = client.get("/notes")

#     assert response.status_code == 200
#     assert isinstance(response.json(), list)


# def test_get_note_by_id_success():
#     note = create_test_note()
#     note_id = note["id"]

#     response = client.get(f"/note/{note_id}")

#     assert response.status_code == 200
#     assert response.json()["id"] == note_id
#     assert response.json()["title"] == "Test Note"


# def test_get_note_by_id_not_found():
#     fake_id = "000000000000000000000000"

#     response = client.get(f"/note/{fake_id}")

#     assert response.status_code == 200
#     assert response.json() == {"error": "Note not found"}
