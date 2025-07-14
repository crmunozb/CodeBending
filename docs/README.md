# 📄 Informe de Análisis Estático del Proyecto CodeBending

## 1. Introducción

Este informe presenta los resultados del análisis estático realizado sobre el proyecto **CodeBending**, una plataforma educativa para gestionar ejercicios y series en lenguajes de programación.

Se utilizaron las siguientes herramientas:

- **Radon**: Análisis de complejidad ciclomática.
- **Bandit**: Detección de vulnerabilidades de seguridad en Python.
- **Pylint**: Evaluación del cumplimiento de buenas prácticas y calidad de código Python.

---

## 2. Resultados del Análisis de Complejidad (Radon)

Radon evalúa la complejidad ciclomática de funciones y clases, asignando calificaciones de **A** (muy buena) a **F** (muy compleja).

### Principales hallazgos:

- Se detectaron funciones con complejidad alta:
  - `detallesEjerciciosEstudiantes` → **E (35)**
  - `detallesCurso` → **D (26)**
- Algunas funciones presentan complejidad moderada (**C**), como:
  - `detallesEjercicio`, `dashDocente`, `progresoCurso`.

- También hay muchas funciones bien evaluadas:
  - `manejoCarpetas.py` y `manejoArchivosJava.py`: mayoría con calificación **A**.
  - Modelos ORM (`basedatos/modelos.py`): bien estructurados con complejidad baja (**A**).

✅ **Recomendación:** Refactorizar funciones con notas **D**, **E** o superiores, dividiéndolas en subfunciones más pequeñas y reutilizables.

---

## 3. Resultados del Análisis de Seguridad (Bandit)

Bandit detectó las siguientes vulnerabilidades:

| Severidad | Problema                       | Archivo/Ubicación   | Descripción                                               |
|-----------|--------------------------------|----------------------|-----------------------------------------------------------|
| 🟥 Alta    | `debug=True` en Flask         | `main.py:1396`       | Expone la consola interactiva de Flask.                   |
| 🟨 Media   | `host='0.0.0.0'`              | `main.py:1396`       | Puede exponer el servidor a conexiones externas.          |
| 🟩 Baja    | Uso de `subprocess.run`       | `manejoMaven.py`     | Riesgo si se ejecuta entrada no confiable.                |
| 🟩 Baja    | Contraseña codificada         | `main.py:59`         | Uso de clave secreta codificada como string.              |

✅ **Recomendación:**
- Eliminar `debug=True` en producción.
- Usar variables de entorno para claves y configuraciones sensibles.
- Validar todas las entradas antes de ejecutar comandos externos.

---

## 4. Resultados del Análisis de Calidad de Código (Pylint)

### Puntaje general:
- **Pylint score promedio:** `6.43 / 10`

### Problemas frecuentes detectados:
- Falta de `docstrings` en módulos y funciones.
- Importaciones no utilizadas (`unused-import`).
- Atributos inexistentes o mal referenciados (`no-member`).
- Variables definidas pero no utilizadas (`unused-variable`).
- Estilo inconsistente en nombres o estructura de clases (`invalid-name`).

✅ **Recomendación:**
- Documentar todas las funciones y módulos con `docstrings`.
- Limpiar importaciones innecesarias.
- Mejorar consistencia en los nombres de variables y atributos.
- Validar atributos y relaciones antes de usarlos.

---

## 7. Retrospectiva Personal como Desarrollador

- Realizar este análisis estático me permitió ver el proyecto CodeBending desde una perspectiva más profunda, más allá de su funcionalidad superficial. Como desarrollador, pude observar que, si bien el código cumple su propósito educativo, hay varios aspectos técnicos que requieren atención para escalar o robustecer esta plataforma.

- Uno de los principales aprendizajes fue entender cómo la complejidad ciclomática puede afectar directamente la mantenibilidad. Al revisar funciones como detallesEjerciciosEstudiantes o detallesCurso, me di cuenta de que la dificultad para leerlas e interpretarlas se debe a una estructura monolítica. Esto me motivó a pensar en refactorizaciones utilizando principios como Single Responsibility y segmentación por bloques lógicos.

- El análisis de Bandit fue especialmente revelador. Aunque el contexto del proyecto sea académico, encontrar código que ejecuta comandos con subprocess sin validación previa me hizo cuestionar cómo podrían explotar esto si se llevara a producción. En particular, el uso directo de subprocess.run(["mvn", "clean", "install"]) representa un riesgo si algún parámetro llega a ser manipulable por un usuario. Me hizo tomar conciencia de que, aunque el entorno sea controlado, nunca debe subestimarse la importancia de asegurar cada punto de entrada o ejecución externa.

- Reemplazar Flake8 por Pylint también fue una decisión reflexionada. Pylint me entregó análisis más detallados, tanto de estilo como de calidad de código. Esto me ayudó a identificar problemas más profundos que van desde la reutilización de variables hasta convenciones de nombres que podrían afectar la claridad del código.

- En lo personal, esta experiencia reafirmó mi convicción de que el análisis estático no es una etapa extra, sino una necesidad profesional. Me gustaría implementar pipelines automáticos de revisión (CI/CD) en futuros proyectos, incluyendo herramientas como Bandit y Pylint desde el inicio. A largo plazo, creo que esto puede ahorrar tiempo, mejorar la colaboración y fortalecer la seguridad del software desde sus primeras líneas de código.

## 5. Conclusiones

- El proyecto **CodeBending** presenta una **arquitectura funcional sólida**, con modelos bien definidos y lógica estructurada.
- Se identificaron funciones con **alta complejidad ciclomática** que deben ser refactorizadas para mejorar mantenibilidad.
- Bandit alertó sobre **riesgos importantes de seguridad** que deben mitigarse antes de un despliegue en producción.
- Pylint evidenció **debilidades en documentación y estilo de código**, pero también una base sobre la cual mejorar.

---

## 6. Recomendaciones Finales

- Refactorizar funciones complejas y aplicar principios SOLID.
- Configurar un archivo `.env` para gestionar configuraciones sensibles.
- Automatizar revisiones con herramientas como Bandit y Pylint integradas en un pipeline CI/CD.
- Incorporar tests unitarios para asegurar estabilidad del sistema.

---

📌 *Última revisión: 14 de Julio 2025*

👤 Autor

**Cristóbal Muñoz Barrios**  
Estudiante de Ingeniería Civil Informática - Universidad de Concepción  
GitHub: [@crmunozb](https://github.com/crmunozb)  
