import os
from dotenv import load_dotenv
from motor.motor_asyncio import AsyncIOMotorClient

load_dotenv()
MONGO_URL = f"mongodb://{os.getenv('MONGO_USERNAME')}:"\
            f"{os.getenv('MONGO_PASSWORD')}@"\
            f"{os.getenv('MONGO_HOST')}:{os.getenv('MONGO_PORT')}/"\
            f"{os.getenv('MONGO_DB')}"\
            f"?authSource=admin"

def main_database():
    client = AsyncIOMotorClient(MONGO_URL)
    return client.get_database()