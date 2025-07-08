# ---------- Dockerfile para CodeBending ----------

# Imagen base oficial de Python (ligera)
FROM python:3.11-slim

# Evita que Python genere archivos .pyc
ENV PYTHONDONTWRITEBYTECODE=1
# Muestra logs en tiempo real
ENV PYTHONUNBUFFERED=1

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos los archivos del proyecto al contenedor
COPY . .

# Instalamos dependencias
RUN pip install --no-cache-dir -r requirements.txt

# (Opcional) Variables de entorno que necesite Flask
ENV FLASK_APP=main.py
ENV FLASK_RUN_PORT=3000

# Puerto expuesto por la aplicación
EXPOSE 3000

# Comando por defecto para ejecutar la app
CMD ["python", "main.py"]
