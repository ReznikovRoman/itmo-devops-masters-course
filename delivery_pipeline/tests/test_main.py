import pytest
from fastapi.testclient import TestClient

from app.main import app, discount

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_version_has_git_sha_field():
    response = client.get("/version")
    assert response.status_code == 200
    assert set(response.json()) == {"version", "git_sha"}


def test_discount_regular():
    assert discount(200, 10) == 180.0


def test_discount_rejects_bad_percent():
    with pytest.raises(ValueError):
        discount(100, 150)
