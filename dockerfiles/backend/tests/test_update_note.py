# from fastapi.testclient import TestClient
# from motor.motor_asyncio import AsyncIOMotorClient

# from backend.app.main import app
# from backend.app.db import get_database


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
#     return response.json()


# def test_update_note_success():
#     # Step 1: Create a note
#     note = create_test_note()
#     note_id = note["id"]

#     # Step 2: Update the note
#     response = client.put(
#         f"/note/{note_id}",
#         json={
#             "title": "Updated Title",
#             "done": True
#         }
#     )

#     # Step 3: Assertions
#     assert response.status_code == 200
#     updated_note = response.json()

#     assert updated_note["id"] == note_id
#     assert updated_note["title"] == "Updated Title"
#     assert updated_note["done"] is True

#     # Step 4: Fields not updated should remain the same
#     assert updated_note["description"] == "Test Description"
