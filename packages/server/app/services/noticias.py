from fastapi import HTTPException
from sqlmodel import Session, select

from app.models.noticias import Noticia
from app.schemas.noticias import NoticiasCreate, NoticiasUpdate


def crear_noticias(session: Session, noticia_data: NoticiasCreate):
    noticias = Noticia(**noticia_data.model_dump(exclude={"id"}))
    session.add(noticias)
    session.commit()
    session.refresh(noticias)
    return noticias


def get_all_noticias(session: Session):
    noticia = session.exec(select(Noticia).order_by(Noticia.id.desc())).all()
    return noticia


def get_one_noticia(session: Session, noticia_id: int):
    return session.get(Noticia, noticia_id)


def update_one_noticia(session: Session, noticia: NoticiasUpdate, noticia_id: int):
    db_noticia = session.get(Noticia, noticia_id)
    noticia_data = noticia.model_dump(exclude_unset=True)

    if not db_noticia:
        raise HTTPException(status_code=404, detail="Noticia not found")

    db_noticia.sqlmodel_update(noticia_data)
    session.add(db_noticia)
    session.commit()
    session.refresh(db_noticia)
    return db_noticia
