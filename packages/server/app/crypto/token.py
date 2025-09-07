from datetime import datetime, timedelta
import os
from jwt import encode


def expire_date(days: int):
    date = datetime.now() + timedelta(days=days)
    return date


def write_token(data: dict):
    token = encode(
        payload={**data, "exp": expire_date(60)},
        key=os.getenv("JWT_SECRET_KEY"),
        algorithm="HS256",
    )
    return token
