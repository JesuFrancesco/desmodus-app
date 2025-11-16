from functools import lru_cache
from dotenv import load_dotenv
from pydantic_settings import BaseSettings
from pydantic import Field

from app.log import get_logger

# If .env presents, load it
load_dotenv()

logger = get_logger(__name__)


class Config(BaseSettings, case_sensitive=True):
    # Environment
    AMBIENTE: str = Field(default="dev", alias="AMBIENTE")
    PORT: int = Field(default=8054, alias="PORT")

    # Auth
    JWT_SECRET_KEY: str | None = Field(default=None, alias="JWT_SECRET_KEY")
    SECURE_COOKIE: str | None = Field(default=None, alias="SECURE_COOKIE")

    # Azure Storage
    AZURE_STORAGE_CONNECTION_STRING: str | None = Field(
        default=None, alias="AZURE_STORAGE_CONNECTION_STRING"
    )

    # Google Oauth
    GOOGLE_CLIENT_ID: str | None = Field(default=None, alias="GOOGLE_CLIENT_ID")
    GOOGLE_CLIENT_SECRET: str | None = Field(default=None, alias="GOOGLE_CLIENT_SECRET")
    GOOGLE_CALLBACK_URL: str | None = Field(default=None, alias="GOOGLE_CALLBACK_URL")

    # Discord Oauth
    DISCORD_CLIENT_ID: str | None = Field(default=None, alias="DISCORD_CLIENT_ID")
    DISCORD_CLIENT_SECRET: str | None = Field(
        default=None, alias="DISCORD_CLIENT_SECRET"
    )
    DISCORD_CALLBACK_URL: str | None = Field(default=None, alias="DISCORD_CALLBACK_URL")

    # Database
    DB_CONNECTION_STRING: str | None = Field(default=None, alias="DB_CONNECTION_STRING")

    # Gemini
    GOOGLE_API_KEY: str | None = Field(default=None, alias="GOOGLE_API_KEY")


@lru_cache()
def get_config() -> Config:
    config = Config()

    for field in type(config).model_fields:
        if getattr(config, field) is None:
            logger.warning("La variable de entorno %s no está configurada", field)

    logger.debug("Configuración cargada")

    return config
