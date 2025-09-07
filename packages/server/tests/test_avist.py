import io
import json
import pytest
from fastapi.testclient import TestClient

from app.schemas.avistamiento import (
    AvistamientoResponse,
    AvistamientoUpdate,
)
from app.main import app

client = TestClient(app)

from unittest.mock import patch


@pytest.fixture()
def mock_create_avist():
    with patch("app.controllers.avistamiento.create_avist") as mock:
        yield mock


@pytest.fixture()
def mock_get_all_avist():
    with patch("app.controllers.avistamiento.get_all_avist") as mock:
        yield mock


@pytest.fixture()
def mock_get_user_avist():
    with patch("app.controllers.avistamiento.get_user_avist") as mock:
        yield mock


@pytest.fixture()
def mock_get_one_avist():
    with patch("app.controllers.avistamiento.get_one_avist") as mock:
        yield mock


@pytest.fixture()
def mock_update_one_avist():
    with patch("app.controllers.avistamiento.update_one_avist") as mock:
        yield mock


# ==================


def test_create_avist(mock_create_avist):
    mock_create_avist.return_value = AvistamientoResponse(
        id=1,
        longitud=72.65415132,
        latitud=-8.654651321,
        description="Avistamiento de prueba",
        user_id=0,
        departamento_id="21",
        archivo=None,
        detected_at="2023-01-01T00:00:00Z",
    )

    avist_data = {
        "longitud": 72.65415132,
        "latitud": 8.654651321,
        "description": "Avistamiento de prueba",
        "user_id": 0,
        "departamento_id": "21",
        "detected_at": "2023-01-01T00:00:00Z",
    }

    file = io.BytesIO(b"fake image")
    response = client.post(
        "/avist/",
        data={"data": json.dumps(avist_data)},
        files={"file": ("image.jpg", file, "image/jpeg")},
    )

    assert response.status_code == 200
    assert response.json()["description"] == "Avistamiento de prueba"


def test_get_all_avist(mock_get_all_avist):
    mock_get_all_avist.return_value = [
        AvistamientoResponse(
            id=1,
            longitud=72.65415132,
            latitud=-8.654651321,
            description="Avistamiento de prueba",
            user_id=0,
            departamento_id="21",
            archivo=None,
            detected_at="2023-01-01T00:00:00Z",
        )
    ]

    response = client.get("/avist/")

    assert response.status_code == 200
    assert len(response.json()) == 1
    assert response.json()[0]["description"] == "Avistamiento de prueba"


def test_get_user_avist(mock_get_user_avist):
    from app.crypto.middleware import validate_token

    override_validate_token = lambda: {"id": 1}
    app.dependency_overrides[validate_token] = override_validate_token

    mock_get_user_avist.return_value = [
        AvistamientoResponse(
            id=1,
            longitud=72.65415132,
            latitud=-8.654651321,
            description="Avistamiento de prueba",
            user_id=1,
            departamento_id="21",
            archivo=None,
            detected_at="2023-01-01T00:00:00Z",
        )
    ]

    response = client.get("/avist/user")

    assert response.status_code == 200
    assert response.json()[0]["description"] == "Avistamiento de prueba"

    app.dependency_overrides[validate_token] = None


def test_get_one_avist(mock_get_one_avist):
    mock_get_one_avist.return_value = AvistamientoResponse(
        id=1,
        longitud=72.65415132,
        latitud=-8.654651321,
        description="Avistamiento de prueba",
        user_id=0,
        departamento_id="21",
        archivo=None,
        detected_at="2023-01-01T00:00:00Z",
    )

    response = client.get("/avist/1")
    assert response.status_code == 200
    assert response.json()["description"] == "Avistamiento de prueba"


def test_patch_avist(mock_update_one_avist):
    mock_update_one_avist.return_value = AvistamientoResponse(
        id=1,
        longitud=72.65415132,
        latitud=-8.654651321,
        description="Actualizado",
        user_id=0,
        departamento_id="21",
        archivo=None,
        detected_at="2023-01-01T00:00:00Z",
    )

    update_data = AvistamientoUpdate(id=1, description="Actualizado")
    response = client.patch("/avist/1", json=update_data.model_dump(exclude_unset=True))

    assert response.status_code == 200
    assert response.json()["description"] == "Actualizado"
