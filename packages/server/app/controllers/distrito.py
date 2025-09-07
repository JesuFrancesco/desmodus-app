from typing import List
from fastapi import APIRouter, Depends
from sqlmodel import Session

from app.schemas.distrito import DistritoResponse
from app.database import get_session
from app.services.distrito import (
    get_all_distritos,
    get_one_distrito,
)

router = APIRouter()


@router.get("/", response_model=List[DistritoResponse])
def get_distritos_endpoint(session: Session = Depends(get_session)):
    return get_all_distritos(session)


@router.get("/{distrito_id}", response_model=DistritoResponse)
def get_distrito_endpoint(distrito_id: int, session: Session = Depends(get_session)):
    return get_one_distrito(session, distrito_id)
