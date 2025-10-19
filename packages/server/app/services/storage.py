import os
import io
import datetime
from azure.storage.blob import BlobServiceClient, BlobClient
from azure.core.exceptions import ResourceExistsError
from PIL import Image, ImageOps

from app.crypto.md5 import toMD5Digest
from app.config import get_config
from app.utils.exceptions import DuplicateArchivoError


AZURE_STORAGE_CONNECTION_STRING = get_config().AZURE_STORAGE_CONNECTION_STRING
CONTAINER_NAME = "assets"

blob_service_client: BlobServiceClient | None = None

if os.getenv("AMBIENTE") != "pytest":
    if not AZURE_STORAGE_CONNECTION_STRING:
        raise ValueError(
            "Azure Storage Connection String must be set in environment variables."
        )
    blob_service_client = BlobServiceClient.from_connection_string(
        AZURE_STORAGE_CONNECTION_STRING
    )


def upload_image_to_azure_blob(file: bytes, resize_width: int = 800):
    """
    Upload an image to Azure Blob Storage after resizing and hashing.
    Returns a dict with blob URL and path.
    """
    if blob_service_client is None:
        raise RuntimeError("Azure Blob Service client not initialized.")

    # Open and fix image orientation
    image = Image.open(io.BytesIO(file))
    image = ImageOps.exif_transpose(image)

    if image is None:
        raise ValueError("Error al procesar la imagen.")

    # Resize while keeping aspect ratio
    aspect_ratio = image.height / image.width
    new_height = int(resize_width * aspect_ratio)
    resized_image = image.resize((resize_width, new_height), Image.Resampling.LANCZOS)

    # Save image to memory buffer
    buffer = io.BytesIO()
    resized_image.save(buffer, format="JPEG", quality=85)
    buffer.seek(0)

    # Compute MD5 hash
    image_bytes = buffer.getvalue()
    md5_hash = toMD5Digest(image_bytes)

    # Generate blob path
    formatted_date = datetime.datetime.now().strftime("%Y_%m_%d")
    blob_name = f"avistamientos/{md5_hash}_{formatted_date}.jpg"

    # Get blob client
    container_client = blob_service_client.get_container_client(CONTAINER_NAME)

    # Create container if not exists
    if not container_client.exists():
        container_client.create_container()

    blob_client: BlobClient = container_client.get_blob_client(blob_name)

    # Upload image (handle duplicate)
    try:
        blob_client.upload_blob(buffer, blob_type="BlockBlob", overwrite=False)
    except ResourceExistsError:
        # File already exists
        blob_url = blob_client.url
        raise DuplicateArchivoError(image_url=blob_url, image_path=blob_name)

    # Return result
    return {"url": blob_client.url, "path": blob_name}


def delete_files_from_azure_blob(paths: list[str]):
    """
    Delete multiple blobs from the Azure container.
    """
    if blob_service_client is None:
        raise RuntimeError("Azure Blob Service client not initialized.")

    container_client = blob_service_client.get_container_client(CONTAINER_NAME)

    for path in paths:
        blob_client = container_client.get_blob_client(path)
        blob_client.delete_blob(delete_snapshots="include")

    return {"deleted": paths}
