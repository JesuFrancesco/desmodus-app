from typing import List, Optional
from sqlmodel import Column, Field, Relationship, SQLModel, ForeignKey, String


class Departamento(SQLModel, table=True):
    """Modelo de la tabla departamento"""

    __tablename__: str = "departamentos"

    id: str = Field(primary_key=True, index=True)
    nombre: str = Field(nullable=False)
    thumbnail_url: str | None = Field()

    avistamientos: Optional[List["Avistamiento"]] = Relationship(
        back_populates="departamento",
        sa_relationship_kwargs={"lazy": "joined"},
    )


class Provincia(SQLModel, table=True):
    """Modelo de la tabla departamento"""

    __tablename__: str = "provincias"

    id: str = Field(primary_key=True, index=True)
    nombre: str = Field(nullable=False)
    departamento_id: str = Field(
        sa_column=Column(String, ForeignKey("departamentos.id"), nullable=False)
    )


class Distrito(SQLModel, table=True):
    """Modelo de la tabla distritos"""

    __tablename__: str = "distritos"

    id: str = Field(primary_key=True, index=True)
    nombre: str = Field(nullable=False)
    departamento_id: str = Field(
        sa_column=Column(String, ForeignKey("departamentos.id"), nullable=False)
    )
    provincia_id: str = Field(
        sa_column=Column(String, ForeignKey("provincias.id"), nullable=False)
    )
