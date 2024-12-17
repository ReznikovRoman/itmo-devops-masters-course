import logging
from time import perf_counter

from fastapi import FastAPI, Request
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_client import Counter, Histogram

# Инициализация логгера
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

app = FastAPI()

# Метрики Prometheus
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total number of requests",
    ["method", "endpoint", "http_status"]
)

REQUEST_LATENCY = Histogram(
    "http_request_latency_seconds",
    "Request latency in seconds",
    ["method", "endpoint"]
)

Instrumentator().instrument(app).expose(app)


@app.middleware("http")
async def log_and_metrics(request: Request, call_next):
    """Middleware для логирования и сбора метрик.

    - Логирование входящих запросов и результатов.
    - Сбор кастомных метрик для Prometheus.
    """
    method = request.method
    path = request.url.path

    logger.info(f"Incoming request: {method} {path}")

    start_time = perf_counter()
    response = await call_next(request)
    latency = perf_counter() - start_time

    # Логирование времени выполнения и статус-кода
    logger.info(
        f"Completed request: {method} {path} | Status: {response.status_code} | Latency: {latency:.4f}s"
    )

    # Обновление метрик
    REQUEST_COUNT.labels(method=method, endpoint=path, http_status=response.status_code).inc()
    REQUEST_LATENCY.labels(method=method, endpoint=path).observe(latency)

    return response


@app.get("/")
def read_root():
    return {"message": "Hello, Monitoring with Logs!"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    if q:
        return {"item_id": item_id, "q": q}
    return {"item_id": item_id}
