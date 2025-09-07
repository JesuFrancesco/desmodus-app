from fastapi import APIRouter, Depends
from sqlmodel import Session

from app.database import get_session
from app.services.senasa_producer import enviar_datos_a_senasa

router = APIRouter()


@router.get("/status")
def get_status():
    return {"status": "ok", "message": "Senasa Producer is running"}


@router.post("/enviar-datos")
def enviar_datos(session: Session = Depends(get_session)):
    return enviar_datos_a_senasa(session=session)
