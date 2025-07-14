## 📄 Análisis Estático del Proyecto CodeBending

## 📌 1. Introducción

Este informe documenta el análisis estático realizado al proyecto **CodeBending**, una plataforma desarrollada en Python para la gestión y seguimiento de ejercicios de programación paso a paso.  
El objetivo fue evaluar la **calidad**, **seguridad** y **mantenibilidad** del código, utilizando tres herramientas especializadas:

- 🔐 **Bandit**: Detección de vulnerabilidades de seguridad.
- 📊 **Radon**: Evaluación de la complejidad ciclomática del código.
- 🧹 **Pylint**: Análisis de calidad, estilo y convenciones de buenas prácticas Python.

---

## 🛡️ 2. Resultados del Análisis de Seguridad (Bandit)

### 📌 Resumen General:

| Métrica                  | Valor |
|--------------------------|-------|
| **Líneas analizadas**    | 1346  |
| **Archivos analizados**  | 1     |
| **Vulnerabilidades**     | 5     |
| 🔴 **Alta**              | 1     |
| 🟡 **Media**             | 3     |
| 🟢 **Baja**              | 1     |

---

### 🔍 Hallazgos Clave:

#### 🔴 Uso de `subprocess` sin validación segura  
- **Archivo**: `manejoMaven.py`, líneas 1 y 7  
- **Riesgo**: Alto  
- **Justificación**: Aunque se usa un comando fijo (`['mvn', 'clean', 'test']`), debe protegerse de entradas externas.  
- **Recomendación**: Validar entradas, mantener `shell=False` y usar `shlex.split()`.

---

#### 🟡 Clave secreta hardcodeada  
- **Archivo**: `main.py`, línea 59  
- **Riesgo**: Medio  
- **Recomendación**: Extraer la clave a un archivo `.env` y acceder mediante `os.getenv`.

---

#### 🔴 `debug=True` en entorno Flask  
- **Archivo**: `main.py`, línea 1397  
- **Riesgo**: Alto  
- **Recomendación**: Controlar mediante una variable de entorno. Eliminar en producción.

---

#### 🟡 `host='0.0.0.0'` expuesto  
- **Archivo**: `main.py`, línea 1396  
- **Riesgo**: Medio  
- **Recomendación**: Restringir a `localhost` o proteger con firewall.

---

## 📈 3. Resultados del Análisis de Complejidad (Radon)

Radon evalúa la **complejidad ciclomática** de funciones, asignando notas de **A** (muy simple) a **F** (muy compleja).

### 📌 Principales Funciones Críticas

| Función                      | Ubicación       | Complejidad | Nota | Observaciones                                   |
|-----------------------------|------------------|-------------|------|-------------------------------------------------|
| `detallesEjerciciosEstudiantes` | `main.py:1199` | 35          | E    | Alta ramificación, múltiples responsabilidades |
| `detallesCurso`             | `main.py:701`    | 26          | D    | Muchas condiciones anidadas                    |
| `detallesEjercicio`         | `main.py:561`    | 18          | C    | Mezcla lógica de presentación y negocio        |
| `progresoCurso`             | `main.py:1035`   | 18          | C    | Condicionales repetitivos                      |
| `dashDocente`               | `main.py:297`    | 15          | C    | Filtros condicionales en la vista              |
| *(Otras funciones)*         | `varias`         | 11–15       | C    | Condiciones múltiples y lógica acoplada        |

---

✅ **Recomendación**: Refactorizar funciones complejas aplicando principios **SOLID**, modularización y separación de responsabilidades.

## 4. Resultados del Análisis de Calidad (Pylint)
Puntuación general: 6.43 / 10

Observaciones frecuentes:
❌ Falta de docstrings en funciones y módulos.

🔄 Variables e imports no utilizados.

📛 Nombres poco descriptivos en variables.

🚫 Referencias a atributos inexistentes (warnings tipo no-member).

✅ Recomendaciones:

Añadir docstrings claros.

Eliminar código muerto.

Usar nombres autoexplicativos.

Verificar integridad de atributos en clases.

## 5. Conclusión Técnica
El proyecto CodeBending presenta una base sólida, pero también áreas críticas a mejorar:

🛡️ Seguridad: El uso de subprocess debe ser estrictamente controlado. No es trivial en entornos reales, donde un input mal validado puede comprometer el sistema.

🔧 Mantenibilidad: La alta complejidad en funciones clave sugiere una urgente modularización.

🧹 Calidad de código: Si bien aceptable, es necesario elevar el estándar adoptando reglas más estrictas.

✅ Recomendación General: Automatizar estos chequeos en pipelines de CI/CD con Bandit y Pylint.

## 6. Retrospectiva del Desarrollador

- Durante este análisis estático, me di cuenta de que, aunque el proyecto CodeBending funcionaba correctamente a nivel funcional, había aspectos técnicos fundamentales que no había considerado lo suficiente desde una perspectiva de ingeniería profesional.

- Una de las herramientas más reveladoras fue Bandit. El hallazgo más crítico fue el uso de subprocess.run() en manejoMaven.py, líneas 1 y 7. Este código ejecuta el comando ['mvn', 'clean', 'test'] sin validación de entrada, lo cual puede parecer inofensivo porque el comando es fijo. Sin embargo, al analizarlo desde una perspectiva de producción, entendí que si alguien lograra modificar ese script (por ejemplo, mediante inyección de código o manipulación de entorno), se podría ejecutar cualquier comando arbitrario en el sistema. Este fue un punto de inflexión para mí, ya que comprendí que la seguridad no se trata solo de prevenir lo obvio, sino de proteger incluso lo que asumimos como seguro.

- En cuanto a Radon, me llamó la atención que funciones clave como detallesEjerciciosEstudiantes tenían una complejidad ciclomática muy alta (nota E). Al revisar esa función, noté que combinaba lógica de negocio, presentación y validaciones, lo que dificultaba su lectura y modificación. Antes no le habría dado importancia, pero ahora entiendo que una función así no solo es difícil de mantener, sino también riesgosa en términos de errores futuros. Esto me motivó a estudiar y aplicar los principios SOLID, particularmente el de Responsabilidad Única.

- Respecto a Pylint, decidí reemplazar Flake8 ya que Pylint me ofrecía diagnósticos más amplios. Por ejemplo, me alertó sobre atributos mal definidos y nombres de variables poco claros, cosas que suelen pasar desapercibidas cuando uno desarrolla solo. Noté que varios archivos carecían de docstrings y contenían código muerto, lo cual afectaba directamente la mantenibilidad y legibilidad.

- En resumen, esta experiencia me hizo entender que el análisis estático no es una formalidad, sino una herramienta poderosa para anticiparse a problemas que pueden costar caro en producción. De ahora en adelante, pienso incorporar análisis automático con Bandit y Pylint en mis flujos de trabajo desde el primer commit.

📌 *Última revisión: 14 de Julio 2025*

👤 Autor

**Cristóbal Muñoz Barrios**  
Estudiante de Ingeniería Civil Informática - Universidad de Concepción  
GitHub: [@crmunozb](https://github.com/crmunozb)  
