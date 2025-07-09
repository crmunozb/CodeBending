# CodeBending

You need Java JRE > 21 installed and Apache Maven in your computer.

In your favorite virtual env :
`pip install -r requirements.txt`

Then to create the database :
`python .\crear_db.py`

Then to start the project :
`python .\main.py`

Then you need to connect to [http://127.0.0.1:3000/registerSupervisor](http://127.0.0.1:3000/registerSupervisor) to create the first supervsor account.

You can encounter an example of exercise for the platform here : [https://github.com/GeoffreyHecht/FizzBuzzPasoAPaso](https://github.com/GeoffreyHecht/FizzBuzzPasoAPaso)

Important: There seems to be a problem with path management under Windows, so I recommend using Linux (or correcting the problem).

---

## 📊 Análisis Estático del Código

Se aplicaron tres herramientas para evaluar la calidad y seguridad del código fuente:

* 🔐 **Bandit**: detectó posibles vulnerabilidades en funciones de manipulación de archivos y uso de rutas.
* 📏 **Flake8**: permitió identificar errores de estilo, como violaciones a PEP8, líneas demasiado largas y espacios innecesarios.
* 🧠 **Radon**: analizó la complejidad ciclomática, permitiendo detectar funciones con lógica excesivamente compleja.

Los reportes generados se encuentran en la carpeta [`docs/`](./docs/):

* [`bandit_resultados.txt`](./docs/bandit_resultados.txt)
* [`flake8_resultados.txt`](./docs/flake8_resultados.txt)
* [`radon_resultados.txt`](./docs/radon_resultados.txt)

Para una explicación más detallada de los hallazgos, puede consultar el siguiente documento:
👉 [`docs/README.md`](./docs/README.md)

---

## 💬 Retrospectiva

El uso de herramientas de análisis estático fue fundamental para mejorar la calidad del proyecto. Gracias a Bandit, se identificaron prácticas potencialmente inseguras que fueron corregidas a tiempo. Con Flake8 se mejoró la legibilidad y uniformidad del código, lo cual facilita el mantenimiento futuro. Por último, Radon ayudó a detectar funciones que requerían ser simplificadas para cumplir con buenas prácticas de diseño.

Consideramos que estas herramientas son valiosas no solo para este proyecto, sino también para otros proyectos Python de tipo educativo o profesional.

---

## 🐳 Cómo ejecutar el contenedor

Este proyecto puede ejecutarse fácilmente en cualquier entorno con Docker instalado. El contenedor fue configurado para construir automáticamente el entorno, instalar dependencias, crear la base de datos y lanzar la aplicación web.

### ⚙️ Construcción del contenedor

```bash
docker build -t codebending .
```

---

### ▶️ Ejecución del contenedor

```bash
docker run -p 3000:3000 codebending
```

---

### 🌐 Acceso a la plataforma

Una vez iniciado el contenedor, puede ingresar a:

```bash
http://127.0.0.1:3000/registerSupervisor
```

---

### ❗ Posibles errores y soluciones

#### ❗ Error: `port is already allocated`

Este error ocurre si ya hay una aplicación o contenedor utilizando el puerto 3000.

---

**🔧 Solución A: Detener el contenedor anterior**

```bash
docker ps
docker stop <CONTAINER_ID>
```

---

**🔁 Solución B: Usar otro puerto local**

```bash
docker run -p 3001:3000 codebending
```

Y luego acceder a:

```bash
http://127.0.0.1:3001/registerSupervisor
```

---

### 📄 Explicación del Dockerfile

```dockerfile
FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000
CMD ["sh", "-c", "python crear_db.py && python main.py"]
```

---

## 👤 Autor

**Cristóbal Muñoz Barrios**
Estudiante de Ingeniería Civil Informática
Universidad de Concepción – Julio 2025
Proyecto para el curso **Fundamentos de Testing y Aseguramiento de la Calidad**
