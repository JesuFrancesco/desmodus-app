from typing import Optional

from app.utils.camelcase_mapper import CamelModel


class UserCreate(CamelModel):
    name: str
    email: str
    phone: str
    dni: str
    distrito_id: int | None = None


class UserUpdate(CamelModel):
    name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    dni: Optional[str] = None
    distrito_id: Optional[int] = None


class UserResponse(UserCreate):
    id: int
    distrito_id: Optional[int] = None
