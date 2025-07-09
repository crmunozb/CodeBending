# ---------- Dockerfile para CodeBending ----------
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_APP=main.py
ENV FLASK_RUN_PORT=3000

EXPOSE 3000

CMD ["sh", "-c", "python crear_db.py && python main.py"]
