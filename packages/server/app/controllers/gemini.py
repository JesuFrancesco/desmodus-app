from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlmodel import Session

from app.crypto.middleware import validate_token
from app.database import get_session
from app.services.gemini import ask_question

router = APIRouter()


class QuestionRequest(BaseModel):
    question: str


@router.post("/")
def get_departamento_endpoint(
    request: QuestionRequest,
    _: dict = Depends(validate_token),
    session: Session = Depends(get_session),
):
    question = request.question
    return ask_question(question, session)
