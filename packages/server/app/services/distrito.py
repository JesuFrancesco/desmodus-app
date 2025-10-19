from sqlmodel import Session, select

from app.models.ubigeos import Distrito


def get_all_distritos(session: Session):
    distrito = session.exec(select(Distrito)).all()
    return distrito

def get_distritos_by_provincia(session: Session, provincia_id: str):
    return session.exec(select(Distrito).where(Distrito.provincia_id == provincia_id)).all()

def get_one_distrito(session: Session, distrito_id: int):
    return session.get(Distrito, distrito_id)
