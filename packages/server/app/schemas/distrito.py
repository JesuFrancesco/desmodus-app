from app.utils.camelcase_mapper import CamelModel


class DistritoResponse(CamelModel):
    id: str
    nombre: str
    provincia_id: str | None = None
