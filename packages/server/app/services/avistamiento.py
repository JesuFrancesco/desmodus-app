from fastapi import HTTPException, UploadFile
from sqlmodel import Session, select

from app.models.archivos import Archivo
from app.models.avistamiento import Avistamiento
from app.schemas.avistamiento import AvistamientoCreate, AvistamientoUpdate
from app.services.storage import upload_file_to_supabase
from app.services.siamese_gradio import verificacion_por_red_siamesa
from app.log import get_logger

logger = get_logger(__name__)


def create_avist(session: Session, avist_data: AvistamientoCreate, file: UploadFile):
    image_url = upload_file_to_supabase(file.file.read())

    archivo = Archivo(
        image_url=image_url,
    )
    session.add(archivo)
    session.commit()
    session.refresh(archivo)

    # Llamar a servicio red siamesa
    logger.info("Llamando a verificacion con red siamesa...")
    response = verificacion_por_red_siamesa(image_url=image_url)
    logger.info("Gradio response: %s", response)
    logger.info("Probabilidad: %s", response["confidences"][0]["confidence"])

    if response["confidences"][0]["confidence"] < 0.5:
        logger.warning("Baja confianza en la clasificacion")
        raise HTTPException(
            status_code=400, detail="Baja confianza en la clasificacion."
        )

    avist = Avistamiento(**avist_data.model_dump(exclude={"id"}))
    session.add(avist)
    session.commit()
    session.refresh(avist)

    avist.archivo_id = archivo.id
    session.add(avist)
    session.commit()
    session.refresh(avist)

    return avist


def get_all_avist(session: Session, offset: int, limit: int):
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


def get_one_avist(session: Session, avist_id: int):
    avist = session.get(Avistamiento, avist_id)
    if not avist:
        raise HTTPException(status_code=404, detail="Avistamiento not found")
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
