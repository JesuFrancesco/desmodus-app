from sqlmodel import Session, select
from models.ubigeos import Provincia


def get_all_provincias(session: Session):
    provincia = session.exec(select(Provincia)).all()
    return provincia


def get_one_provincia(session: Session, provincia_id: int):
    return session.get(Provincia, provincia_id)
