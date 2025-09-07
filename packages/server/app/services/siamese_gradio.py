import requests

from app.config import get_config
from app.log import get_logger

logger = get_logger(__name__)

GRADIO_SERVICE_URL = get_config().GRADIO_SERVICE_URL


def verificacion_por_red_siamesa(image_url: str):
    with requests.Session() as s:
        headers = {"Content-Type": "application/json"}
        data = {"image_url": image_url}
        response = s.post(GRADIO_SERVICE_URL, headers=headers, json=data)
        if response.status_code == 200:
            return response.json()
        else:
            logger.error("Error al enviar datos a Gradio: %s", response.text)
            return {"error": "Error al enviar datos a Gradio"}
