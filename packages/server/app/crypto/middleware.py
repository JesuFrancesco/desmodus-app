from jwt import decode, exceptions
from fastapi import HTTPException, Request
from app.log import get_logger
from app.config import get_config

logger = get_logger(__name__)


def validate_token(request: Request):
    JWT_SECRET_KEY = get_config().JWT_SECRET_KEY
    if not JWT_SECRET_KEY:
        logger.error("La variable de entorno JWT_SECRET_KEY no está configurada")
        raise EnvironmentError(
            "La variable de entorno JWT_SECRET_KEY no está configurada"
        )

    token = request.cookies.get("access_token")

    if not token:
        logger.warning("No existe token en request %s", request)
        raise HTTPException(
            status_code=401, detail="No se ha encontrado el token en cookies"
        )
    try:
        payload = decode(token, key=JWT_SECRET_KEY, algorithms=["HS256"])
        return payload
    except exceptions.DecodeError:
        logger.warning("Error al decodificar el token %s", token)
        raise HTTPException(detail="Invalid token", status_code=401)
    except exceptions.ExpiredSignatureError:
        logger.warning("Token expirado %s", token)
        raise HTTPException(detail="Token expired", status_code=401)


def validate_admin_token(request: Request):
    JWT_SECRET_KEY = get_config().JWT_SECRET_KEY
    if not JWT_SECRET_KEY:
        logger.error("La variable de entorno JWT_SECRET_KEY no está configurada")
        raise EnvironmentError(
            "La variable de entorno JWT_SECRET_KEY no está configurada"
        )

    token = request.cookies.get("access_token")

    if not token:
        logger.warning("No existe token en request %s", request)
        raise HTTPException(
            status_code=401, detail="No se ha encontrado el token en cookies"
        )
    try:
        payload = decode(token, key=JWT_SECRET_KEY, algorithms=["HS256"])
        if not payload.get("role") == "admin":
            logger.warning("El usuario no es admin %s", payload)
            raise HTTPException(
                status_code=403, detail="Se requieren privilegios de administrador"
            )
    except exceptions.DecodeError:
        logger.warning("Error al decodificar el token %s", token)
        raise HTTPException(detail="Invalid token", status_code=401)
    except exceptions.ExpiredSignatureError:
        logger.warning("Token expirado %s", token)
        raise HTTPException(detail="Token expired", status_code=401)
