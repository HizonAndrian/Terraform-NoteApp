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
# def test_delete_note():
#     note = create_test_note()
#     note_id = note["id"]

#     # Delete the note
#     response = client.delete(f"/note/{note_id}")
#     assert response.status_code == 200
#     assert response.json()["message"] == "Note deleted successfully"

#     # Optional: verify it's really gone
#     get_response = client.get(f"/note/{note_id}")
#     assert get_response.status_code == 200
#     assert get_response.json()["error"] == "Note not found"

