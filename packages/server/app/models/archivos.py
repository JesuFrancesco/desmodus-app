from typing import List, Optional
from sqlmodel import Relationship, SQLModel, Field

from app.models.noticia_archivo import NoticiaArchivo


class Archivo(SQLModel, table=True):
    __tablename__ = "archivos"

    id: int | None = Field(default=None, primary_key=True)
    image_url: str = Field(index=True)

    avistamiento: Optional["Avistamiento"] = Relationship(
        back_populates="archivo", sa_relationship_kwargs={"lazy": "joined"}
    )
    noticia_archivos: List[NoticiaArchivo] = Relationship(back_populates="archivo")
