from utils.camelcase_mapper import CamelModel


class DepartamentoResponse(CamelModel):
    id: str
    nombre: str
    thumbnail_url: str | None


class DepartamentoRankingResponse(CamelModel):
    id: str
    nombre: str
    thumbnail_url: str
    total_avistamientos: int
