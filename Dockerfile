# ---------- Dockerfile para CodeBending ----------
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Crear usuario no-root y cambiar propietario de la carpeta
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

ENV FLASK_APP=main.py
ENV FLASK_RUN_PORT=3000

EXPOSE 3000

CMD ["sh", "-c", "python crear_db.py && python main.py"]
