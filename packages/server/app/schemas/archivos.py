from app.utils.camelcase_mapper import CamelModel


class ArchivosCreate(CamelModel):
    image_url: str


class ArchivosResponse(ArchivosCreate):
    id: int
