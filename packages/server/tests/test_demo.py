from fastapi.testclient import TestClient

from app.models.demo import app

client = TestClient(app)


def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data == {"message": "Hello, World!"}
