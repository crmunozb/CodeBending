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

📊 **Análisis Estático del Código**

Se realizó un análisis del código fuente utilizando herramientas de seguridad y calidad de código:

- 🔐 **Bandit**: análisis de vulnerabilidades comunes en scripts Python.
- 📏 **Flake8**: verificación de estilo y errores comunes de sintaxis.
- 🧠 **Radon**: cálculo de la complejidad ciclomática de las funciones.

Los reportes generados se encuentran en la carpeta [`docs/`](./docs/):

- [`bandit_resultados.txt`](./docs/bandit_resultados.txt)
- [`flake8_resultados.txt`](./docs/flake8_resultados.txt)
- [`radon_resultados.txt`](./docs/radon_resultados.txt)

Para más detalles, consulta el resumen explicativo en  
👉 [`docs/README.md`](./docs/README.md)

---

## 🐳 Cómo ejecutar el contenedor

```bash
docker build -t codebending-app .
docker run -p 3000:3000 codebending-app
