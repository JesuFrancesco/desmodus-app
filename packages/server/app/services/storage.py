import os
import datetime
from supabase import create_client, Client
from app.crypto.md5 import toMD5Digest

from app.config import get_config

SUPABASE_URL = get_config().SUPABASE_URL
SUPABASE_ANON_KEY = get_config().SUPABASE_ANON_KEY
BUCKET_NAME = "assets"

supabase: Client | None = None

if os.getenv("AMBIENTE") != "pytest":
    if not SUPABASE_URL or not SUPABASE_ANON_KEY:
        raise ValueError(
            "Supabase URL and Anon Key must be set in environment variables."
        )
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)


def upload_file_to_supabase(file: bytes):
    now = datetime.datetime.now()
    formatted_date = now.strftime("%Y_%m_%d")
    destination_path = (
        f"avistamientos/{toMD5Digest(now.isoformat())}_{formatted_date}.jpg"
    )

    response = supabase.storage.from_(BUCKET_NAME).upload(
        destination_path, file, {"content-type": "image/*"}
    )

    return f"{SUPABASE_URL}/storage/v1/object/public/{BUCKET_NAME}/{response.path}"
