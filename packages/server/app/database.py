from sqlmodel import create_engine, SQLModel, Session

from app.config import get_config

settings = get_config()

DB_CONNECTION_STRING = settings.DB_CONNECTION_STRING

db_connection = DB_CONNECTION_STRING
engine = None

if settings.AMBIENTE != "pytest":
    if not db_connection:
        raise ValueError("Database connection string is not set.")
    engine = create_engine(db_connection)


def create_db_tables():
    if engine is None:
        raise ValueError("Database engine is not initialized.")
    SQLModel.metadata.create_all(engine)


def delete_db_tables():
    if engine is None:
        raise ValueError("Database engine is not initialized.")
    SQLModel.metadata.drop_all(engine)


def get_session():
    if engine is None:
        raise ValueError("Database engine is not initialized.")
    with Session(engine) as session:
        yield session
