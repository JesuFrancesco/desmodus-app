import os
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from database import create_db_tables  # , delete_db_tables
from data.seed import seed_data
from controllers import (
    archivos,
    departamento,
    distrito,
    noticias,
    provincia,
    users,
    uploads,
)
from controllers.auth.providers import discord, google
from controllers.auth import auth


@asynccontextmanager
async def lifespan(_: FastAPI):
    create_db_tables()
    seed_data()

    yield

    # print("Eliminando las tablas de la base de datos")
    # delete_db_tables()
    print("Apagando el server")


app = FastAPI(lifespan=lifespan)

app.mount("/static", StaticFiles(directory="./images"), name="images")
app.include_router(uploads.router)

app.include_router(users.router, prefix="/users")
app.include_router(archivos.router, prefix="/archivos")
app.include_router(noticias.router, prefix="/noticias")
app.include_router(departamento.router, prefix="/departamento")
app.include_router(provincia.router, prefix="/provincia")
app.include_router(distrito.router, prefix="/distrito")

app.include_router(google.router, prefix="/google-auth")
app.include_router(discord.router, prefix="/discord-auth")
app.include_router(auth.router, prefix="/auth")

if __name__ == "__main__":
    import uvicorn

    PORT = os.getenv("PORT", "8054")

    uvicorn.run(app, host="0.0.0.0", port=PORT)
