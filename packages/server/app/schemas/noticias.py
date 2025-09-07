from pydantic import ConfigDict
from typing import List, Optional

from app.utils.camelcase_mapper import CamelModel


class ArchivoResponse(CamelModel):
    id: int
    image_url: str

    model_config = ConfigDict(
        from_attributes=True,
    )
    # class Config:
    #     from_attributes = True


class NoticiaArchivoResponse(CamelModel):
    id: int
    noticia_id: int
    archivo_id: int
    archivo: Optional[ArchivoResponse]

    model_config = ConfigDict(
        from_attributes=True,
    )
    # class Config:
    #     from_attributes = True


class NoticiasCreate(CamelModel):
    title: str
    content: str


class NoticiasUpdate(CamelModel):
    title: Optional[str] = None
    content: Optional[str] = None


class NoticiasResponse(NoticiasCreate):
    id: int
    noticia_archivos: Optional[List[NoticiaArchivoResponse]] = None

    model_config = ConfigDict(
        from_attributes=True,
    )
    # class Config:
    #     from_attributes = True
