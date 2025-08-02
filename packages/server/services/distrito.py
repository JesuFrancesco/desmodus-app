from sqlmodel import Session, select
from models.ubigeos import Distrito


def get_all_distritos(session: Session):
    distrito = session.exec(select(Distrito)).all()
    return distrito


def get_one_distrito(session: Session, distrito_id: int):
    return session.get(Distrito, distrito_id)
