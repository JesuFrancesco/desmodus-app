from typing import List
from fastapi import APIRouter, Depends
from sqlmodel import Session

from app.schemas.departamento import DepartamentoResponse, DepartamentoRankingResponse
from app.database import get_session
from app.services.departamento import (
    get_all_departamentos,
    get_a_departamento_by_name,
    get_all_departamentos_by_ranking,
    get_one_departamento,
)

router = APIRouter()


@router.get("/query", response_model=DepartamentoResponse | None)
def get_a_departamento_by_name_endpoint(
    name: str, session: Session = Depends(get_session)
):
    return get_a_departamento_by_name(session, name)


@router.get("/ranking", response_model=List[DepartamentoRankingResponse])
def get_departamentos_by_ranking_endpoint(session: Session = Depends(get_session)):
    return get_all_departamentos_by_ranking(session)


@router.get("/", response_model=List[DepartamentoResponse])
def get_departamentos_endpoint(session: Session = Depends(get_session)):
    return get_all_departamentos(session)


@router.get("/{departamento_id}", response_model=DepartamentoResponse)
def get_departamento_endpoint(
    departamento_id: int, session: Session = Depends(get_session)
):
    return get_one_departamento(session, departamento_id)
