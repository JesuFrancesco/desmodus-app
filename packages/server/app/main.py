from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

# App
from app.controllers import (
    archivos,
    avistamiento,
    departamento,
    distrito,
    noticias,
    provincia,
    users,
    senasa_producer,
)
from app.controllers.auth.providers import discord, google
from app.controllers.auth import auth
from app.log import get_logger

logger = get_logger("root")


@asynccontextmanager
async def lifespan(_: FastAPI):
    logger.info("Iniciando el server")

    yield

    logger.info("Apagando el server")


app = FastAPI(
    title="Desmodus API",
    description="REST API para el proyecto Desmodus App.",
    version="1.0.0",
    contact={
        "name": "JesuFrancesco",
        "email": "20210109@aloe.ulima.edu.pe",
    },
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/licenses/MIT",
    },
    lifespan=lifespan,
)

app.mount("/static", StaticFiles(directory="app/static"), name="static")


# Static file upload (disabled due to not having persistance)
# app.include_router(uploads.router, tags=["uploads"])

app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(avistamiento.router, prefix="/avist", tags=["avistamiento"])
app.include_router(archivos.router, prefix="/archivos", tags=["archivos"])
app.include_router(noticias.router, prefix="/noticias", tags=["noticias"])

# Ubigeos
app.include_router(
    departamento.router, prefix="/departamento", tags=["ubigeo", "departamento"]
)
app.include_router(provincia.router, prefix="/provincia", tags=["ubigeo", "provincia"])
app.include_router(distrito.router, prefix="/distrito", tags=["ubigeo", "distrito"])
app.include_router(
    senasa_producer.router, prefix="/senasa-producer", tags=["senasa-producer"]
)

app.include_router(google.router, prefix="/google-auth", tags=["google-auth"])
app.include_router(discord.router, prefix="/discord-auth", tags=["discord-auth"])
app.include_router(auth.router, prefix="/auth", tags=["auth"])

if __name__ == "__main__":
    import uvicorn
    from app.config import get_config

    settings = get_config()

    if settings.AMBIENTE == "dev":
        uvicorn.run("app.main:app", port=settings.PORT, reload=True)
    else:
        uvicorn.run("app.main:app", port=settings.PORT)
