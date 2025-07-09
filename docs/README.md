# 📄 Informe de Análisis Estático del Proyecto CodeBending

## 1. Introducción

Este informe presenta los resultados del análisis estático realizado sobre el proyecto **CodeBending**, una plataforma educativa para gestionar ejercicios y series en lenguajes de programación.  
Se utilizaron las siguientes herramientas:

- **Radon**: Análisis de complejidad ciclomática.
- **Bandit**: Detección de vulnerabilidades de seguridad en Python.
- **Flake8**: Validación de estilo y convenciones PEP8.

---

## 2. Resultados del Análisis de Complejidad (Radon)

Radon evalúa la complejidad ciclomática de funciones y clases, asignando calificaciones de **A** (muy buena) a **F** (muy compleja).

### Principales hallazgos:

- Se detectaron varias funciones con complejidad alta, destacando:
  - `detallesEjerciciosEstudiantes` → **E (35)**
  - `detallesCurso` → **D (26)**

- Sin embargo, también hay muchas funciones bien evaluadas, especialmente en:
  - `manejoCarpetas.py` y `manejoArchivosJava.py` (casi todas con nota **A**).
  - Modelos ORM (`basedatos/modelos.py`) bien estructurados con complejidad baja (**A**).

✅ **Recomendación:** Refactorizar las funciones con notas **D, E o F**, dividiéndolas en subfunciones más pequeñas y reutilizables para mejorar mantenibilidad y legibilidad del código.

---

## 3. Resultados del Análisis de Seguridad (Bandit)

Bandit detectó las siguientes vulnerabilidades:

| Severidad | Problema                       | Archivo/Ubicación   | Descripción                                               |
|-----------|--------------------------------|----------------------|-----------------------------------------------------------|
| 🟥 Alta    | `debug=True` en Flask         | `main.py:1396`       | Expone la consola interactiva de Flask.                   |
| 🟨 Media   | `host='0.0.0.0'`              | `main.py:1396`       | Puede exponer el servidor a conexiones externas.          |
| 🟩 Baja    | Uso de `subprocess`           | `manejoMaven.py`     | Riesgo si se ejecuta entrada no confiable.                |
| 🟩 Baja    | Contraseña codificada         | `main.py:59`         | Uso de clave secreta `secret-key-goes-here`.              |

✅ **Recomendación:**

- Eliminar `debug=True` en producción.
- Usar variables de entorno para claves y configuraciones sensibles.
- Validar cualquier entrada antes de ejecutar comandos con `subprocess`.

---

## 4. Resultados del Análisis de Estilo (Flake8)

Flake8 encontró múltiples errores de estilo en los archivos del proyecto.

### Tipos de errores más comunes:

- `E302`: Se esperaban 2 líneas en blanco entre funciones/clases.
- `W293`/`W292`: Líneas en blanco con espacios o sin salto de línea final.
- `F401`/`F841`: Importaciones y variables no utilizadas.
- `E501`: Líneas de código demasiado largas (>120 caracteres).
- `E225`/`E231`: Espaciado incorrecto alrededor de operadores o comas.

### Archivos más afectados:

- `main.py`: Formato inconsistente, uso de variables sin uso, líneas excesivamente largas.
- `modelos.py`: Problemas de indentación y orden.
- `manejoCarpetas.py` y `manejoMaven.py`: Varias inconsistencias de estilo.

✅ **Recomendación:** Utilizar herramientas como `black` o `autopep8` para aplicar correcciones automáticas y mantener una base de código limpia y consistente.

---

## 5. Conclusiones

- El proyecto **CodeBending** tiene una **estructura funcional sólida** y modelos bien definidos.
- Se identificaron funciones con **alta complejidad** que deben ser refactorizadas.
- Hay **vulnerabilidades de seguridad** importantes a corregir antes de su uso en producción.
- El código presenta **diversos errores de estilo PEP8** que podrían afectar la mantenibilidad a largo plazo.

---

## 6. Recomendaciones Finales

- Refactorizar funciones críticas, especialmente en `main.py`.
- Implementar un archivo `.env` para ocultar configuraciones sensibles.
- Automatizar revisiones de estilo y seguridad mediante un pipeline de CI/CD.
- Incorporar pruebas unitarias para asegurar la calidad tras las refactorizaciones.

---

📌 *Última revisión: 8 de Julio 2025.*

👤 Autor

**Cristóbal Muñoz Barrios**  
Estudiante de Ingeniería Civil Informática - Universidad de Concepción  
GitHub: [@crmunozb](https://github.com/crmunozb)  
Última revisión: 8 de Julio de 2025
