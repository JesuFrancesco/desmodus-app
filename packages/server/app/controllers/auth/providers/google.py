from fastapi import APIRouter, Depends, HTTPException, Request, Response
import httpx
from sqlmodel import Session, select
from app.crypto.token import write_token

from app.database import get_session
from app.models.users import Users
from app.config import get_config

GOOGLE_CLIENT_ID = get_config().GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET = get_config().GOOGLE_CLIENT_SECRET
REDIRECT_URI = get_config().GOOGLE_CALLBACK_URL

router = APIRouter()

TOKEN_URL = "https://oauth2.googleapis.com/token"
USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo"


async def get_google_user(request: Request):
    access_token = request.cookies.get("access_token")
    if not access_token:
        raise HTTPException(
            status_code=401,
            detail="El google access_token no se encontró en las cookies",
        )

    async with httpx.AsyncClient() as client:
        user_res = await client.get(
            USERINFO_URL, headers={"Authorization": f"Bearer {access_token}"}
        )

    if user_res.status_code != 200:
        raise HTTPException(
            status_code=401, detail="El google access_token es invalido"
        )

    return user_res.json()


@router.get("/login")
def login():
    return {
        "auth_url": f"https://accounts.google.com/o/oauth2/auth"
        f"?client_id={GOOGLE_CLIENT_ID}&redirect_uri={REDIRECT_URI}"
        f"&response_type=code&scope=openid email profile"
    }


@router.get("/web-callback")
async def auth_callback(
    code: str, response: Response, session: Session = Depends(get_session)
):
    async with httpx.AsyncClient() as client:
        token_data = {
            "code": code,
            "client_id": GOOGLE_CLIENT_ID,
            "client_secret": GOOGLE_CLIENT_SECRET,
            "redirect_uri": REDIRECT_URI,
            "grant_type": "authorization_code",
        }
        token_res = await client.post(TOKEN_URL, data=token_data)

        if token_res.status_code != 200:
            raise HTTPException(
                status_code=400, detail="Failed to retrieve access token"
            )

        token_json = token_res.json()
        access_token = token_json.get("access_token")

        if not access_token:
            raise HTTPException(status_code=400, detail="Invalid token response")

        user_res = await client.get(
            USERINFO_URL, headers={"Authorization": f"Bearer {access_token}"}
        )
        user_info = user_res.json()

    existing_user = session.exec(
        select(Users).where(Users.email == user_info["email"])
    ).first()

    if not existing_user:
        new_user = Users(
            name=user_info["name"],
            email=user_info["email"],
            phone="",
            dni="",
            distrito_id=None,
        )
        session.add(new_user)
        session.commit()
        session.refresh(new_user)
        existing_user = new_user

    jWebToken = write_token(
        {"id": existing_user.id, "sub": user_info["email"], "role": "user"}
    )

    response.set_cookie(
        key="access_token",
        value=jWebToken,
        httponly=True,
        secure=False,
        samesite="Lax",
    )

    return {"ok": True}


@router.post("/flutter-callback")
async def flutter_callback(
    response: Response,
    user: dict = Depends(get_google_user),
    session: Session = Depends(get_session),
):
    existing_user = session.exec(
        select(Users).where(Users.email == user["email"])
    ).first()

    if not existing_user:
        new_user = Users(
            name=user["name"],
            email=user["email"],
            avatar_url=user["picture"],
            phone="",
            dni="",
            distrito_id=None,
        )
        session.add(new_user)
        session.commit()
        session.refresh(new_user)
        existing_user = new_user

    jWebToken = write_token(
        {"id": existing_user.id, "sub": user["email"], "role": "user"}
    )

    response.set_cookie(
        key="desmodus_access_token",
        value=jWebToken,
        httponly=True,
        secure=False,
        samesite="Lax",
    )

    return {"ok": True}


@router.post("/logout")
def logout(response: Response):
    response.delete_cookie("desmodus_access_token")
    return {"message": "Logged out successfully"}
