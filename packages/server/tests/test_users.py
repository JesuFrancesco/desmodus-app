from unittest.mock import patch
import pytest
from fastapi.testclient import TestClient

from app.schemas.users import UserResponse, UserCreate
from app.main import app

client = TestClient(app)


@pytest.fixture()
def mock_get_all_users():
    with patch("app.controllers.users.get_all_users") as mock:
        yield mock


@pytest.fixture()
def mock_get_one_user():
    with patch("app.controllers.users.get_one_user") as mock:
        yield mock


@pytest.fixture()
def mock_update_one_user():
    with patch("app.controllers.users.update_one_user") as mock:
        yield mock


@pytest.fixture()
def mock_create_user():
    with patch("app.controllers.users.create_user") as mock:
        yield mock


def test_create_user(mock_create_user):
    mock_create_user.return_value = UserResponse(
        id=26,
        name="John Doe",
        email="john@example.com",
        phone="1234567890",
        dni="12345678",
        distrito_id=None,
    )

    user = UserCreate(
        name="John Doe", email="john@example.com", phone="1234567890", dni="12345678"
    )

    response = client.post("/users/", json=user.model_dump())

    assert response.status_code == 200
    assert response.json() == {
        "id": 26,
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "1234567890",
        "dni": "12345678",
        "distritoId": None,
    }


def test_get_all_users(mock_get_all_users):
    mock_get_all_users.return_value = [
        UserResponse(
            id=22,
            name="John Doe",
            email="john@example.com",
            phone="1234567890",
            dni="12345678",
            distrito_id=None,
        ),
        UserResponse(
            id=23,
            name="Jane Doe",
            email="jane@example.com",
            phone="0987654321",
            dni="87654321",
            distrito_id=None,
        ),
    ]

    response = client.get("/users/")

    assert response.status_code == 200
    assert len(response.json()) == 2
    assert response.json()[0]["name"] == "John Doe"


def test_get_one_user(mock_get_one_user):
    mock_get_one_user.return_value = UserResponse(
        id=23,
        name="John Doe",
        email="john@example.com",
        phone="1234567890",
        dni="12345678",
        distrito_id=None,
    )

    response = client.get("/users/23")

    assert response.status_code == 200
    assert response.json()["name"] == "John Doe"


def test_patch_user(mock_update_one_user):
    mock_update_one_user.return_value = UserResponse(
        id=1,
        name="John Doe Updated",
        email="john@example.com",
        phone="1234567890",
        dni="12345678",
        distrito_id=None,
    )

    user_data = {
        "name": "John Doe Updated",
        "email": "john@example.com",
        "phone": "1234567890",
    }

    response = client.patch("/users/1", json=user_data)

    assert response.status_code == 200
    assert response.json()["name"] == "John Doe Updated"
