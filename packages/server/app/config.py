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
    AMBIENTE: str | None = Field(default=None, alias="AMBIENTE")
    PORT: int | None = Field(default=8054, alias="PORT")

    # Auth
    JWT_SECRET_KEY: str | None = Field(default=None, alias="JWT_SECRET_KEY")
    SECURE_COOKIE: str | None = Field(default=None, alias="SECURE_COOKIE")

    # Supabase secrets
    SUPABASE_URL: str | None = Field(default=None, alias="SUPABASE_URL")
    SUPABASE_ANON_KEY: str | None = Field(default=None, alias="SUPABASE_ANON_KEY")

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
    DATABASE_ENGINE: str | None = Field(default=None, alias="DATABASE_ENGINE")
    DATABASE_URL: str | None = Field(default=None, alias="DATABASE_URL")
    DATABASE_PORT: str | None = Field(default=None, alias="DATABASE_PORT")
    DATABASE_NAME: str | None = Field(default=None, alias="DATABASE_NAME")
    DATABASE_USER: str | None = Field(default=None, alias="DATABASE_USER")
    DATABASE_PASSWORD: str | None = Field(default=None, alias="DATABASE_PASSWORD")

    # Gradio / Huggingface
    GRADIO_SERVICE_URL: str | None = Field(default=None, alias="GRADIO_SERVICE_URL")


@lru_cache()
def get_config() -> Config:
    config = Config()

    for field in config.model_fields:
        if getattr(config, field) is None:
            logger.warning("La variable de entorno %s no está configurada", field)

    logger.debug("Configuración cargada")

    return config
