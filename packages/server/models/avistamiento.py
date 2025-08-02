from typing import Optional
from sqlmodel import (
    Field,
    Column,
    Integer,
    ForeignKey,
    Relationship,
    SQLModel,
    DECIMAL,
    String,
)
from decimal import Decimal
from datetime import datetime

from models.archivos import Archivo
from models.ubigeos import Departamento


class Avistamiento(SQLModel, table=True):
    __tablename__ = "avistamientos"

    id: int | None = Field(default=None, primary_key=True)
    longitud: Decimal = Field(default=Decimal("0.00"), sa_column=Column(DECIMAL(10, 2)))
    latitud: Decimal = Field(default=Decimal("0.00"), sa_column=Column(DECIMAL(10, 2)))
    description: str | None = Field(
        default=None,
        nullable=True,
    )

    archivo_id: int | None = Field(
        default=None, sa_column=Column(Integer, ForeignKey("archivos.id"))
    )

    user_id: int = Field(
        default=None, sa_column=Column(Integer, ForeignKey("users.id"))
    )

    departamento_id: str = Field(
        default=None, sa_column=Column(String, ForeignKey("departamentos.id"))
    )

    detected_at: datetime = Field(default=datetime.now(), nullable=False)

    departamento: Optional[Departamento] = Relationship(
        back_populates="avistamientos", sa_relationship_kwargs={"lazy": "joined"}
    )

    archivo: Optional[Archivo] = Relationship(
        back_populates="avistamiento", sa_relationship_kwargs={"lazy": "joined"}
    )
