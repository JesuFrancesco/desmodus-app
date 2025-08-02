from typing import List
from sqlmodel import Relationship, SQLModel, Field

from models.noticia_archivo import NoticiaArchivo


class Noticia(SQLModel, table=True):
    __tablename__ = "noticias"
    id: int | None = Field(default=None, primary_key=True)
    title: str = Field(index=True)
    content: str = Field(index=True)

    noticia_archivos: List[NoticiaArchivo] = Relationship(back_populates="noticia")
