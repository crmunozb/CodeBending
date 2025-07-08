# 📊 Análisis Estático del Proyecto CodeBending

Este documento resume los resultados obtenidos mediante herramientas de análisis estático aplicadas al código del proyecto.

---

## ✅ Herramientas Utilizadas

Se emplearon tres herramientas reconocidas para evaluar aspectos clave del código:

| Herramienta | Propósito                                | Resultado                   |
|-------------|-------------------------------------------|-----------------------------|
| **Bandit**  | Detección de vulnerabilidades de seguridad en código Python. | [`docs/bandit_resultados.txt`](docs/bandit_resultados.txt) |
| **Flake8**  | Revisión de estilo de código (PEP8) y errores sintácticos. | [`docs/flake8_resultados.txt`](docs/flake8_resultados.txt) |
| **Radon**   | Análisis de complejidad ciclomática.      | [`docs/radon_resultados.txt`](docs/radon_resultados.txt) |

---

## 📌 Ubicación de los reportes

Los archivos de salida de cada herramienta están ubicados en la carpeta `/docs` del repositorio para su revisión directa.

---

## 📈 Conclusiones generales

- **Bandit** identificó algunas funciones que pueden requerir revisión por buenas prácticas de seguridad.
- **Flake8** reportó detalles de estilo que ya fueron corregidos en parte del código.
- **Radon** entregó niveles de complejidad mayor en algunas funciones del archivo `main.py`, lo cual puede servir para futuras refactorizaciones.

Este análisis contribuye a mejorar la **calidad, seguridad y mantenibilidad** del proyecto.

---

_Última actualización: 8 de julio de 2025._

