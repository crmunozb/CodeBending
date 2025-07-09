
# CodeBending

You need Java JRE > 21 installed and Apache Maven in your computer.

In your favorite virtual env :
`pip install -r requirements.txt`

Then to create the database :
`python .\crear_db.py`

Then to start the project :
`python .\main.py` 

Then you need to connect to http://127.0.0.1:3000/registerSupervisor to create the first supervsor account.

You can encounter an example of exercise for the platform here : https://github.com/GeoffreyHecht/FizzBuzzPasoAPaso

Important: There seems to be a problem with path management under Windows, so I recommend using Linux (or correcting the problem).

---

## 📊 Análisis Estático del Código

Se aplicaron tres herramientas para evaluar la calidad y seguridad del código fuente:

- 🔐 **Bandit**: detectó posibles vulnerabilidades en funciones de manipulación de archivos y uso de rutas.
- 📏 **Flake8**: permitió identificar errores de estilo, como violaciones a PEP8, líneas demasiado largas y espacios innecesarios.
- 🧠 **Radon**: analizó la complejidad ciclomática, permitiendo detectar funciones con lógica excesivamente compleja.

Los reportes generados se encuentran en la carpeta [`docs/`](./docs/):

- [`bandit_resultados.txt`](./docs/bandit_resultados.txt)
- [`flake8_resultados.txt`](./docs/flake8_resultados.txt)
- [`radon_resultados.txt`](./docs/radon_resultados.txt)

Para una explicación más detallada de los hallazgos, puede consultar el siguiente documento:  
👉 [`docs/README.md`](./docs/README.md)

---

## 💬 Retrospectiva

El uso de herramientas de análisis estático fue fundamental para mejorar la calidad del proyecto. Gracias a Bandit, se identificaron prácticas potencialmente inseguras que fueron corregidas a tiempo. Con Flake8 se mejoró la legibilidad y uniformidad del código, lo cual facilita el mantenimiento futuro. Por último, Radon ayudó a detectar funciones que requerían ser simplificadas para cumplir con buenas prácticas de diseño.

Consideramos que estas herramientas son valiosas no solo para este proyecto, sino también para otros proyectos Python de tipo educativo o profesional.

---

## 🐳 Cómo ejecutar el contenedor

```bash
docker build -t codebending-app .
docker run -p 3000:3000 codebending-app


---
## 👤 Autor

**Cristóbal Muñoz Barrios**  
Estudiante de Ingeniería Civil Informática  
Universidad de Concepción – Julio 2025  
Proyecto para el curso **Fundamentos de Testing y Aseguramiento de la Calidad**
