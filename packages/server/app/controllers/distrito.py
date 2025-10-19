from typing import List
from fastapi import APIRouter, Depends
from sqlmodel import Session

from app.schemas.distrito import DistritoResponse
from app.database import get_session
from app.services.distrito import (
    get_all_distritos,
    get_one_distrito,
    get_distritos_by_provincia
)

router = APIRouter()


@router.get("/", response_model=List[DistritoResponse])
def get_distritos_endpoint(session: Session = Depends(get_session)):
    return get_all_distritos(session)

@router.get("/{provincia_id}", response_model=List[DistritoResponse])
def get_distritos_by_provincia_endpoint(provincia_id: str, session: Session = Depends(get_session)):
    return get_distritos_by_provincia(session, provincia_id)

@router.get("/{distrito_id}", response_model=DistritoResponse)
def get_distrito_endpoint(distrito_id: str, session: Session = Depends(get_session)):
    return get_one_distrito(session, distrito_id)

