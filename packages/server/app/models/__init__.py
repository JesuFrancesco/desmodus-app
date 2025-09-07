from app.models.archivos import Archivo
from app.models.noticia_archivo import NoticiaArchivo
from app.models.avistamiento import Avistamiento
from app.models.noticias import Noticia
from app.models.ubigeos import Departamento, Distrito, Provincia
from app.models.users import Users

__all__ = [
    "Archivo",
    "NoticiaArchivo",
    "Avistamiento",
    "Noticia",
    "Departamento",
    "Distrito",
    "Provincia",
    "Users",
]
