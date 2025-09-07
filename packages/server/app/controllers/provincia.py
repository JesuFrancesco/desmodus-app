from typing import List
from fastapi import APIRouter, Depends
from sqlmodel import Session

from app.schemas.provincia import ProvinciaResponse
from app.database import get_session
from app.services.provincia import (
    get_all_provincias,
    get_one_provincia,
)

router = APIRouter()


@router.get("/", response_model=List[ProvinciaResponse])
def get_provincias_endopoint(session: Session = Depends(get_session)):
    return get_all_provincias(session)


@router.get("/{provincia_id}", response_model=ProvinciaResponse)
def get_provincia_endpoint(provincia_id: int, session: Session = Depends(get_session)):
    return get_one_provincia(session, provincia_id)
