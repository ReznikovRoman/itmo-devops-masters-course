import os

from fastapi import FastAPI

app = FastAPI(title="delivery-demo")

# GIT_SHA и APP_VERSION попадают в образ на этапе сборки (ARG -> ENV, см. Dockerfile.*).
# По ним можно узнать, из какого коммита собран работающий контейнер.
GIT_SHA = os.getenv("GIT_SHA", "unknown")
APP_VERSION = os.getenv("APP_VERSION", "dev")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/version")
def version() -> dict:
    return {"version": APP_VERSION, "git_sha": GIT_SHA}


def discount(price: float, percent: float) -> float:
    """Цена со скидкой. percent -- от 0 до 100."""
    if not 0 <= percent <= 100:
        raise ValueError("percent must be between 0 and 100")
    return round(price * (100 - percent) / 100, 2)


@app.get("/discount")
def get_discount(price: float, percent: float) -> dict:
    return {"price": price, "percent": percent, "result": discount(price, percent)}
