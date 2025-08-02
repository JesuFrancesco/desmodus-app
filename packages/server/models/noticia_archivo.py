from typing import Optional
from sqlmodel import Relationship, SQLModel, Field, Column, Integer, ForeignKey


class NoticiaArchivo(SQLModel, table=True):
    __tablename__ = "noticia_archivos"

    id: int | None = Field(default=None, primary_key=True)

    noticia_id: int = Field(
        default=None, sa_column=Column(Integer, ForeignKey("noticias.id"))
    )
    archivo_id: int = Field(
        default=None, sa_column=Column(Integer, ForeignKey("archivos.id"))
    )

    noticia: Optional["Noticia"] = Relationship(back_populates="noticia_archivos")
    archivo: Optional["Archivo"] = Relationship(back_populates="noticia_archivos")
