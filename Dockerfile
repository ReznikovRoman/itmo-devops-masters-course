FROM python:3.12-slim

WORKDIR /app

COPY requirements.monitoring.txt .

RUN pip install --no-cache-dir -r requirements.monitoring.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "monitoring.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
