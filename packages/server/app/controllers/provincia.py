from typing import List
from fastapi import APIRouter, Depends
from sqlmodel import Session

from app.schemas.provincia import ProvinciaResponse
from app.database import get_session
from app.services.provincia import (
    get_all_provincias,
    get_one_provincia,
    get_provincias_by_departamento
)

router = APIRouter()


@router.get("/", response_model=List[ProvinciaResponse])
def get_provincias_endpoint(session: Session = Depends(get_session)):
    return get_all_provincias(session)

@router.get("/{departamento_id}", response_model=List[ProvinciaResponse])
def get_provincias_by_departamento_endpoint(departamento_id: str, session: Session = Depends(get_session)):
    return get_provincias_by_departamento(session, departamento_id=departamento_id)


@router.get("/{provincia_id}", response_model=ProvinciaResponse)
def get_provincia_endpoint(provincia_id: str, session: Session = Depends(get_session)):
    return get_one_provincia(session, provincia_id)
