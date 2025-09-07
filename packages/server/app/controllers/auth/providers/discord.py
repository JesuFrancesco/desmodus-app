import httpx
from fastapi import APIRouter, Depends, HTTPException, Request, Response
from sqlmodel import Session, select
from app.crypto.token import write_token

from app.database import get_session
from app.models.users import Users
from app.schemas.users import UserResponse
from app.config import get_config

DISCORD_CLIENT_ID = get_config().DISCORD_CLIENT_ID
DISCORD_CLIENT_SECRET = get_config().DISCORD_CLIENT_SECRET
DISCORD_CALLBACK_URL = get_config().DISCORD_CALLBACK_URL

# ============================

router = APIRouter()

TOKEN_URL = "https://discord.com/api/oauth2/token"
USERINFO_URL = "https://discord.com/api/users/@me"


@router.get("/login")
def login():
    return {
        "auth_url": f"https://discord.com/oauth2/authorize"
        f"?client_id={DISCORD_CLIENT_ID}&redirect_uri={DISCORD_CALLBACK_URL}"
        f"&response_type=code&scope=email+identify"
    }


async def get_discord_user(request: Request):
    access_token = request.cookies.get("access_token")

    if not access_token:
        raise HTTPException(
            status_code=401, detail="Token no encontrado en las cookies"
        )

    async with httpx.AsyncClient() as client:
        user_res = await client.get(
            USERINFO_URL, headers={"Authorization": f"Bearer {access_token}"}
        )

    if user_res.status_code != 200:
        raise HTTPException(status_code=401, detail="Token no autorizado chaval")

    return user_res.json()


@router.get("/callback", response_model=UserResponse)
async def auth_callback(
    code: str, response: Response, session: Session = Depends(get_session)
):
    async with httpx.AsyncClient() as client:
        token_data = {
            "client_id": DISCORD_CLIENT_ID,
            "client_secret": DISCORD_CLIENT_SECRET,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": DISCORD_CALLBACK_URL,
            "scope": "identify email",
        }
        token_res = await client.post(
            TOKEN_URL,
            data=token_data,
            headers={"Content-Type": "application/x-www-form-urlencoded"},
        )

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
            name=user_info["username"],
            email=user_info["email"],
            avatar_url=user_info.get("avatar", ""),
            phone="",
            dni="",
            distrito_id=None,
        )
        session.add(new_user)
        session.commit()
        session.refresh(new_user)
        existing_user = new_user
    else:
        existing_user.name = user_info["username"]
        existing_user.email = user_info["email"]
        existing_user.avatar_url = user_info.get("avatar", "")
        session.add(existing_user)
        session.commit()
        session.refresh(existing_user)

    jWebToken = write_token(
        {
            "id": existing_user.id,
            "sub": user_info["email"],
            "role": "user",
        }
    )

    response.set_cookie(
        key="access_token",
        value=jWebToken,
        httponly=True,
        secure=False,
        samesite="Lax",
    )

    return {"ok": True}


@router.get(
    "/callback-android", summary="Callback que redirige con DeepLink a Desmodus App"
)
async def auth_callback_android(
    code: str, response: Response, session: Session = Depends(get_session)
):
    # 1. Validate and exchange the authorization code for an access token
    async with httpx.AsyncClient() as client:
        token_data = {
            "client_id": DISCORD_CLIENT_ID,
            "client_secret": DISCORD_CLIENT_SECRET,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": DISCORD_CALLBACK_URL,
            "scope": "identify email",
        }

        token_res = await client.post(
            TOKEN_URL,
            data=token_data,
            headers={"Content-Type": "application/x-www-form-urlencoded"},
        )

        if token_res.status_code != 200:
            print(token_res.text)
            raise HTTPException(
                status_code=400, detail="No se pudo leer el access token"
            )

        token_json: dict = token_res.json()
        access_token = token_json.get("access_token")

        if not access_token:
            raise HTTPException(status_code=400, detail="Invalid token response")

        user_res = await client.get(
            USERINFO_URL, headers={"Authorization": f"Bearer {access_token}"}
        )
        user_info = user_res.json()
        print("User Info:", user_info)

    # 2. Check if the user exists in the database
    existing_user = session.exec(
        select(Users).where(Users.email == user_info["email"])
    ).first()

    if not existing_user:
        avatar_url = (
            f'https://cdn.discordapp.com/avatars/{user_info["id"]}/{user_info.get("avatar")}.png'
            if user_info.get("avatar")
            else ""
        )
        new_user = Users(
            name=user_info["username"],
            email=user_info["email"],
            avatar_url=avatar_url,
            phone="",
            dni="",
            distrito_id=None,
        )
        session.add(new_user)
        session.commit()
        session.refresh(new_user)
        existing_user = new_user
    else:
        existing_user.name = user_info["username"]
        existing_user.email = user_info["email"]
        existing_user.avatar_url = (
            f'https://cdn.discordapp.com/avatars/{user_info["id"]}/{user_info.get("avatar")}.png'
            if user_info.get("avatar")
            else existing_user.avatar_url
        )
        session.add(existing_user)
        session.commit()
        session.refresh(existing_user)

    jWebToken = write_token(
        {
            "id": existing_user.id,
            "sub": user_info["email"],
            "role": "user",
        }
    )

    response.set_cookie(
        key="access_token",
        value=jWebToken,
        httponly=True,
        secure=False,
        samesite="Lax",
    )

    response.headers["Content-Type"] = "text/plain"
    response.headers["Location"] = (
        f"github.jesufrancesco.desmodus-app://main/auth-callback?jwt={jWebToken}"
    )
    response.status_code = 302
    response.body = b"Redirecting..."

    return response
