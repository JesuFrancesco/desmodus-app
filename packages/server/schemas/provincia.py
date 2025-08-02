from utils.camelcase_mapper import CamelModel


class ProvinciaResponse(CamelModel):
    id: str
    nombre: str
    departamento_id: str | None = None
