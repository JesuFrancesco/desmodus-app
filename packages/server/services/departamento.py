from fastapi import HTTPException
from sqlmodel import Session, func, select, col
from models.ubigeos import Departamento


def get_all_departamentos(session: Session):
    departamentos = session.exec(select(Departamento)).unique().all()
    return departamentos


def get_all_departamentos_by_ranking(session: Session):
    query = (
        select(
            Departamento.id,
            Departamento.nombre,
            Departamento.thumbnail_url,
            func.count().label("total_avistamientos"),
        )
        .join(Departamento.avistamientos)
        .group_by(Departamento.id, Departamento.nombre, Departamento.thumbnail_url)
        .order_by(func.count().desc())
    )
    result = session.exec(query).all()
    return [
        {
            "id": id,
            "nombre": nombre,
            "thumbnail_url": t_url,
            "total_avistamientos": total,
        }
        for id, nombre, t_url, total in result
    ]


def get_a_departamento_by_name(session: Session, name: str):
    departamento = session.exec(
        select(Departamento).where(col(Departamento.nombre).regexp_match(name, "i"))
    ).first()

    if not departamento:
        raise HTTPException(
            status_code=404,
            detail=f"Departamento with name '{name}' not found",
        )

    return departamento


def get_one_departamento(session: Session, departamento_id: int):
    return session.get(Departamento, departamento_id)
