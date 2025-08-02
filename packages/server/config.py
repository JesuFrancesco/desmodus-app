# import os
# from dotenv import load_dotenv

# load_dotenv()


# class Config:
#     AMBIENTE = os.getenv("AMBIENTE")

#     CLIENT_ID = os.getenv("CLIENT_ID")
#     CLIENT_SECRET = os.getenv("CLIENT_SECRET")
#     SECURE_COOKIE = os.getenv("SECURE_COOKIE")
#     JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")

#     REDIRECT_URI = os.getenv("REDIRECT_URI")

#     DISCORD_CLIENT_ID = os.getenv("DISCORD_CLIENT_ID")
#     DISCORD_CLIENT_SECRET = os.getenv("DISCORD_CLIENT_SECRET")
#     DISCORD_REDIRECT_URI = os.getenv("DISCORD_REDIRECT_URI")

#     DATABASE_ENGINE = os.getenv("DATABASE_ENGINE")
#     DATABASE_URL = os.getenv("DATABASE_URL")
#     DATABASE_PORT = os.getenv("DATABASE_PORT")
#     DATABASE_NAME = os.getenv("DATABASE_NAME")
#     DATABASE_USER = os.getenv("DATABASE_USER")
#     DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")

from functools import lru_cache
from dotenv import load_dotenv
from pydantic_settings import BaseSettings
from pydantic import Field
from log import get_logger

load_dotenv()

logger = get_logger(__name__)


class Config(BaseSettings, case_sensitive=True):
    AMBIENTE: str | None = Field(default=None, alias="AMBIENTE")

    SUPABASE_URL: str | None = Field(default=None, alias="SUPABASE_URL")
    SUPABASE_ANON_KEY: str | None = Field(default=None, alias="SUPABASE_ANON_KEY")

    CLIENT_ID: str | None = Field(default=None, alias="CLIENT_ID")
    CLIENT_SECRET: str | None = Field(default=None, alias="CLIENT_SECRET")
    SECURE_COOKIE: str | None = Field(default=None, alias="SECURE_COOKIE")
    JWT_SECRET_KEY: str | None = Field(default=None, alias="JWT_SECRET_KEY")
    REDIRECT_URI: str | None = Field(default=None, alias="REDIRECT_URI")
    DISCORD_CLIENT_ID: str | None = Field(default=None, alias="DISCORD_CLIENT_ID")
    DISCORD_CLIENT_SECRET: str | None = Field(
        default=None, alias="DISCORD_CLIENT_SECRET"
    )

    DISCORD_REDIRECT_URI: str | None = Field(default=None, alias="DISCORD_REDIRECT_URI")
    DATABASE_ENGINE: str | None = Field(default=None, alias="DATABASE_ENGINE")
    DATABASE_URL: str | None = Field(default=None, alias="DATABASE_URL")
    DATABASE_PORT: str | None = Field(default=None, alias="DATABASE_PORT")
    DATABASE_NAME: str | None = Field(default=None, alias="DATABASE_NAME")
    DATABASE_USER: str | None = Field(default=None, alias="DATABASE_USER")
    DATABASE_PASSWORD: str | None = Field(default=None, alias="DATABASE_PASSWORD")


@lru_cache()
def get_config() -> Config:
    config = Config()

    for field in config.model_fields:
        if getattr(config, field) is None:
            logger.warning("La variable de entorno %s no está configurada", field)

    logger.debug("Configuración cargada")

    return config
