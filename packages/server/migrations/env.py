from logging.config import fileConfig
from sqlmodel import SQLModel
from alembic import context
import sys
import os

# Add the root project directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

# ⚠️⚠️⚠️⚠️
# Asegurate que los modelos sean importados para que
# Alembic pueda detectarlos y generar migraciones.
# ⚠️⚠️⚠️⚠️
from app.database import engine
from app.models import *


# Alembic Config object
config = context.config
fileConfig(config.config_file_name)

target_metadata = SQLModel.metadata


def run_migrations_offline():
    context.configure(
        url=str(engine.url),
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    with engine.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    print("Running migrations in offline mode")
    run_migrations_offline()
else:
    print("Running migrations in online mode")
    run_migrations_online()
