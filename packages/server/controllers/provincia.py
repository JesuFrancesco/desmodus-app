from fastapi import APIRouter, Depends
from schemas.provincia import ProvinciaResponse
from database import get_session
from sqlmodel import Session
from services.provincia import (
    get_all_provincias,
    get_one_provincia,
)
from typing import List

router = APIRouter()


@router.get("/", response_model=List[ProvinciaResponse])
def get_provincias_endopoint(session: Session = Depends(get_session)):
    return get_all_provincias(session)


@router.get("/{provincia_id}", response_model=ProvinciaResponse)
def get_provincia_endpoint(provincia_id: int, session: Session = Depends(get_session)):
    return get_one_provincia(session, provincia_id)
