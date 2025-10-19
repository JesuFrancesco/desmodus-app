from typing import Optional

from app.utils.camelcase_mapper import CamelModel


class UserCreate(CamelModel):
    name: str
    email: str
    phone: str
    dni: str
    avatar_url: Optional[str] = None


class UserUpdate(CamelModel):
    name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    dni: Optional[str] = None
    distrito_id: Optional[str] = None
    # TODO: add in model
    document_type: Optional[str] = None
    address: Optional[str] = None
    centro_poblado: Optional[str] = None
    referencia_centro: Optional[str] = None


class UserResponse(UserCreate):
    id: int
    distrito_id: Optional[str] = None
    document_type: Optional[str] = None
    address: Optional[str] = None
    centro_poblado: Optional[str] = None
    referencia_centro: Optional[str] = None
