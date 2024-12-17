from prometheus_fastapi_instrumentator import Instrumentator
from fastapi import FastAPI

app = FastAPI()
Instrumentator().instrument(app).expose(app)

@app.get("/")
def read_root():
    eval('print("Test")')
    return {"message": "Hello, world!"}
