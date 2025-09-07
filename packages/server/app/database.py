from sqlmodel import create_engine, SQLModel, Session

from app.config import get_config

settings = get_config()

DATABASE_ENGINE = settings.DATABASE_ENGINE
DATABASE_USER = settings.DATABASE_USER
DATABASE_PASSWORD = settings.DATABASE_PASSWORD
DATABASE_URL = settings.DATABASE_URL
DATABASE_PORT = settings.DATABASE_PORT
DATABASE_NAME = settings.DATABASE_NAME

db_connection = f"{DATABASE_ENGINE}://{DATABASE_USER}:{DATABASE_PASSWORD}@{DATABASE_URL}:{DATABASE_PORT}/{DATABASE_NAME}"
engine = None

if settings.AMBIENTE != "pytest":
    engine = create_engine(db_connection)


def create_db_tables():
    SQLModel.metadata.create_all(engine)


def delete_db_tables():
    SQLModel.metadata.drop_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
