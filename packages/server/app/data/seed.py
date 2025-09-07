import os
import random
from sqlmodel import delete, text, Session
from decimal import Decimal
from app.database import engine
from faker import Faker

from app.models.avistamiento import Avistamiento
from app.models.users import Users


def __load_ubigeos_sql():
    ubigeos_path = os.path.join(os.path.dirname(__file__), "sql", "ubigeos.sql")
    with open(ubigeos_path, "r", encoding="utf-8") as file:
        sql = file.read()

    with Session(engine) as session:
        try:
            session.execute(text(sql))
            session.commit()
        except Exception as e:
            if "duplicate key" in str(e):
                print("Ubigeos already present, skipping insertion.")
            else:
                raise


def __mock_avistamientos():
    faker = Faker(
        locale="es",
    )

    with Session(engine) as session:
        faker_user = Users(
            id=100,
            name=faker.name(),
            email=faker.email(),
            phone=faker.phone_number(),
            dni=str(faker.random_int(min=10000000, max=99999999)),
            distrito_id=random.choice(
                [
                    "120501",
                    "200101",
                    "240101",
                ]
            ),
        )

        try:
            session.add(faker_user)
            session.commit()
            session.refresh(faker_user)
        except Exception as e:
            if "duplicate key" in str(e):
                print("User already present, skipping insertion.")
                session.rollback()
            else:
                raise

        assert faker_user.id == 100

        statement = delete(Avistamiento)
        session.exec(statement)  # type: ignore

        for i in range(1, 50 + 1):
            fake_avist = Avistamiento(
                latitud=Decimal(random.uniform(-18.0, -0.04)),
                longitud=Decimal(random.uniform(-81.35, -68.65)),
                description=faker.text(max_nb_chars=200),
                user_id=faker_user.id,
                departamento_id=str(
                    random.choice(
                        [
                            # Junin
                            "12",
                            # Piura
                            "20",
                            # Tumbes
                            "24",
                        ]
                    )
                ),
            )

            session.add(fake_avist)
        session.commit()


def seed_data():
    """Carga los datos iniciales de la base de datos"""
    __load_ubigeos_sql()
    __mock_avistamientos()


__all__ = ["seed_data"]
