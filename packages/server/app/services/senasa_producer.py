import requests
from fastapi import HTTPException
from sqlmodel import Session

from app.services.avistamiento import get_all_avist


def enviar_datos_a_senasa(session: Session):
    avists = get_all_avist(session, 0, 120)

    # post method to localhost:5000/avistamientos
    response = requests.post(
        "http://172.28.192.1:5000/avistamientos/batch-upload",
        json=[
            avist.model_dump(
                mode="json",
                exclude=[
                    "archivo_id",
                    "departamento_id",
                    "id",
                    "user_id",
                    "detected_at",
                ],
            )
            for avist in avists
        ],
    )

    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="Error al enviar los datos")

    return {
        "status": "ok",
        "message": "Datos enviados correctamente",
        "senasa_status": response.status_code,
    }
