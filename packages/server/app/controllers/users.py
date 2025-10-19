from typing import List
from fastapi import APIRouter, Depends
from sqlmodel import Session
from app.crypto.middleware import validate_admin_token, validate_token

from app.database import get_session
from app.schemas.users import UserCreate, UserResponse, UserUpdate
from app.services.users import create_user, get_all_users, get_one_user, update_one_user

router = APIRouter()


@router.post("/", response_model=UserResponse)
def create_users_endpoint(
    user: UserCreate,
    _=Depends(validate_admin_token),
    session: Session = Depends(get_session),
):
    return create_user(session, user)


@router.get("/", response_model=List[UserResponse])
def get_users_endpoint(
    _=Depends(validate_admin_token), session: Session = Depends(get_session)
):
    return get_all_users(session)


@router.get("/current", response_model=UserResponse)
def get_current_user(
    payload=Depends(validate_token), session: Session = Depends(get_session)
):
    id = payload.get("id")
    return get_one_user(session, id)


@router.patch("/current", response_model=UserResponse)
def patch_user_endpoint(
    user: UserUpdate,
    payload=Depends(validate_token),
    session: Session = Depends(get_session),
):
    user_id = payload.get("id")
    return update_one_user(session, user, user_id)


@router.get("/{user_id}", response_model=UserResponse)
def get_user_endpoint(
    user_id: int,
    _=Depends(validate_admin_token),
    session: Session = Depends(get_session),
):
    return get_one_user(session, user_id)
