import traceback as tb
from fastapi import HTTPException, UploadFile
from sqlmodel import Session, select, desc

from app.models.archivos import Archivo
from app.models.avistamiento import Avistamiento
from app.schemas.avistamiento import AvistamientoCreate, AvistamientoUpdate
from app.services.storage import (
    upload_image_to_azure_blob,
    delete_files_from_azure_blob,
)
from app.log import get_logger
from app.utils.exceptions import BajaConfianzaError, DuplicateArchivoError

logger = get_logger(__name__)


def create_avist(session: Session, avist_data: AvistamientoCreate, file: UploadFile):
    def eliminar_archivo(archivo: Archivo, img_key: str):
        if archivo:
            session.delete(archivo)
            session.commit()
        if img_key:
            delete_files_from_azure_blob([img_key.split("/public/")[-1]])
        logger.info("Archivo eliminado de Azure y DB")

    def guardar_archivo(img_url: str) -> Archivo:
        archivo = Archivo(image_url=img_url)
        session.add(archivo)
        session.commit()
        session.refresh(archivo)
        return archivo

    img_url = img_key = None
    archivo = None

    # Fase 1: Subida de imagen y guardado en DB
    try:
        azure_response = upload_image_to_azure_blob(file.file.read())
        img_url, img_key = azure_response["url"], azure_response["path"]
        logger.info("Imagen subida a Azure: img_url=%s, img_key=%s", img_url, img_key)
        archivo = guardar_archivo(img_url)
        logger.info("Archivo guardado en DB: %s", archivo)

    except DuplicateArchivoError as e:
        logger.warning("DuplicateArchivoError subiendo imagen a Blob Service: %s", e)
        img_url, img_key = e.image_url, e.image_path
        archivo = session.exec(
            select(Archivo).where(Archivo.image_url == img_url)
        ).first() or guardar_archivo(img_url)

    except Exception as e:
        logger.error("Error subiendo imagen a Blob Service: %s", e)
        raise HTTPException(status_code=500, detail="Error al subir imagen.")

    if not img_url or not img_key or not archivo:
        logger.error("img_url, img_key o archivo es None")
        raise HTTPException(status_code=500, detail="Error al obtener URL de imagen.")

    # Fase 2: Verificación por red siamesa
    try:
        x, y, w, h = avist_data.x, avist_data.y, avist_data.w, avist_data.h
        if None in [x, y, w, h]:
            raise ValueError("Coordenadas de recorte incompletas")

    except BajaConfianzaError as e:
        logger.warning(str(e))
        eliminar_archivo(archivo, img_key)
        raise HTTPException(status_code=400, detail=str(e))

    except Exception as e:
        tb.print_exc()
        eliminar_archivo(archivo, img_key)
        raise HTTPException(status_code=500, detail=f"Algo salió mal: {e}")

    # Fase 3: Crear avistamiento
    avist = Avistamiento(**avist_data.model_dump(exclude={"id"}))
    avist.archivo = archivo

    session.add(avist)
    session.commit()
    session.refresh(avist)

    logger.info("Avistamiento creado: %s", avist)
    logger.info("Archivo asociado: %s", avist.archivo)
    logger.debug("Archivo de avist id: %s", avist.archivo_id)

    return avist


def get_all_avist(session: Session):
    avist = (
        session.exec(
            select(Avistamiento).order_by(desc(Avistamiento.detected_at))  # type: ignore
        )
        .unique()
        .all()
    )
    return avist


def get_paged_avist(session: Session, offset: int, limit: int):
    avist = (
        session.exec(select(Avistamiento).offset(offset).limit(limit)).unique().all()
    )
    return avist


def get_user_avist(session: Session, user_id: int, offset: int = 0, limit: int = 50):
    avist = (
        session.exec(
            select(Avistamiento)
            .where(Avistamiento.user_id == user_id)
            .offset(offset)
            .limit(limit)
        )
        .unique()
        .all()
    )
    return avist


def delete_user_avist(session: Session, user_id: int, avist_id: int):
    avist = session.get(Avistamiento, avist_id)
    if not avist or avist.user_id != user_id:
        raise HTTPException(
            status_code=404, detail="Avistamiento no encontrado o no autorizado"
        )

    # Eliminar archivo asociado si existe
    if avist.archivo:
        try:
            delete_files_from_azure_blob([avist.archivo.image_url.split("/public/")[-1]])
        except Exception as e:
            logger.error("Error eliminando archivo de Azure Blob: %s", e)
        session.delete(avist.archivo)

    session.delete(avist)
    session.commit()
    return get_user_avist(session=session, user_id=user_id)


def get_one_avist(session: Session, avist_id: int):
    avist = session.get(Avistamiento, avist_id)
    if not avist:
        raise HTTPException(status_code=404, detail="Avistamiento no encontrado")
    return avist


def update_one_avist(session: Session, avist: AvistamientoUpdate, avist_id: int):
    db_avist = session.get(Avistamiento, avist_id)

    if not db_avist:
        return None

    avist_data = avist.model_dump(exclude_unset=True)
    db_avist.sqlmodel_update(avist_data)
    session.add(db_avist)
    session.commit()
    session.refresh(db_avist)
    return db_avist
