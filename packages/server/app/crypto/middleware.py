import os
from jwt import decode, exceptions
from fastapi import HTTPException, Request


def validate_token(request: Request):
    token = request.cookies.get("access_token")
    if not token:
        raise HTTPException(
            status_code=401, detail="No se ha encontrado el token en cookies"
        )
    try:
        payload = decode(token, key=os.getenv("JWT_SECRET_KEY"), algorithms=["HS256"])
        return payload
    except exceptions.DecodeError:
        raise HTTPException(detail="Invalid token", status_code=401)
    except exceptions.ExpiredSignatureError:
        raise HTTPException(detail="Token expired", status_code=401)
