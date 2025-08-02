from datetime import datetime
from decimal import Decimal
from typing import Optional
from utils.camelcase_mapper import CamelModel

from schemas.archivos import ArchivosResponse


class AvistamientoCreate(CamelModel):
    longitud: Decimal
    latitud: Decimal
    description: str
    user_id: int | None = None
    departamento_id: str | None = None
    archivo: Optional[ArchivosResponse] = None

    detected_at: datetime


class AvistamientoUpdate(CamelModel):
    longitud: Optional[Decimal] = None
    latitud: Optional[Decimal] = None
    description: Optional[str] = None
    user_id: Optional[int] = None
    departamento_id: Optional[str] = None
    archivo: Optional[ArchivosResponse] = None
    detected_at: Optional[datetime] = None


class AvistamientoResponse(AvistamientoCreate):
    id: int
