from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session
from app.crypto.middleware import validate_token

from app.database import get_session
from app.models.users import Users


router = APIRouter()


@router.get("/verify/token")
def verify_token(payload=Depends(validate_token)):
    return {"success": True, "payload": payload}


@router.get("/current-user")
async def get_current_user(
    payload: dict = Depends(validate_token), session: Session = Depends(get_session)
):
    user = session.get(Users, payload["id"])

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    return {
        "user_data": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "telefono": user.phone,
            "dni": user.dni,
            "distrito_id": user.distrito_id,
        }
    }
