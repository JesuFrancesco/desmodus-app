import json
from fastapi import APIRouter, File, Form, HTTPException, Query, Depends, UploadFile
from crypto.middleware import validate_token
from schemas.avistamiento import (
    AvistamientoCreate,
    AvistamientoResponse,
    AvistamientoUpdate,
)
from sqlmodel import Session
from database import get_session
from services.avistamiento import (
    create_avist,
    get_all_avist,
    get_one_avist,
    get_user_avist,
    update_one_avist,
)
from typing import Annotated, List

router = APIRouter()


@router.post("/", response_model=AvistamientoResponse)
def create_avist_endpoint(
    data: Annotated[str, Form(...)],
    file: Annotated[UploadFile, File(...)],
    session: Session = Depends(get_session),
):
    try:
        avist_data = json.loads(data)
        avist = AvistamientoCreate(**avist_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error al parsear JSON: {str(e)}")

    return create_avist(session, avist, file)


@router.get("/", response_model=List[AvistamientoResponse])
def get_all_avists_endpoint(
    offset: int = Query(0, description="Offset for pagination"),
    limit: int = Query(50, description="Limit for pagination"),
    session: Session = Depends(get_session),
):
    return get_all_avist(session=session, offset=offset, limit=limit)


@router.get("/user", response_model=List[AvistamientoResponse])
def get_user_avists_endpoint(
    payload: dict = Depends(validate_token),
    session: Session = Depends(get_session),
):
    return get_user_avist(session=session, user_id=payload["id"])


@router.get("/{avist_id}", response_model=AvistamientoResponse)
def get_avist_endpoint(avist_id: int, session: Session = Depends(get_session)):
    return get_one_avist(session, avist_id)


@router.patch("/{avist_id}", response_model=AvistamientoResponse)
def patch_avist_endpoint(
    avist_id: int, avist: AvistamientoUpdate, session: Session = Depends(get_session)
):
    return update_one_avist(session, avist, avist_id)
