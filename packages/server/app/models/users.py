from typing import Optional
from sqlmodel import Field, Column, String, ForeignKey, SQLModel


class Users(SQLModel, table=True):
    __tablename__ = "users"  # type: ignore

    id: int = Field(default=None, primary_key=True, nullable=False)
    name: str = Field(index=True, nullable=False)
    email: str = Field(index=True, nullable=False)

    document_type: Optional[str] = Field(index=True, nullable=True, default=None)
    dni: Optional[str] = Field(index=True, max_length=8, nullable=True, default=None)

    phone: Optional[str] = Field(index=True, nullable=True, default=None)
    address: Optional[str] = Field(index=True, nullable=True, default=None)

    centro_poblado: Optional[str] = Field(index=True, nullable=True, default=None)
    avatar_url: Optional[str] = Field(index=True, nullable=True, default=None)

    distrito_id: str = Field(
        default=None, sa_column=Column(String, ForeignKey("distritos.id"))
    )
