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

| **Métrica**              | **Valor** |
|--------------------------|-----------|
| Líneas analizadas        | 1346      |
| Archivos analizados      | 1         |
| Vulnerabilidades         | 5         |
| 🔴 Alta                  | 1         |
| 🟡 Media                 | 3         |
| 🟢 Baja                  | 1         |

---

### 🔍 Hallazgos Clave:

#### 🔴 **1. Uso de `subprocess.run()` sin validación segura**
- **Archivo**: `manejoMaven.py`, líneas 1 y 7  
- **Comando ejecutado**:
  ```python
  subprocess.run(['mvn', 'clean', 'test'])
  ```
- **Riesgo**: Alto  
- **Justificación**: Aunque el comando parece fijo, en proyectos Python es común reutilizar scripts. Si este archivo se adapta para aceptar parámetros externos (por ejemplo, nombre del paquete a testear), una entrada mal validada podría permitir la ejecución arbitraria de comandos.  
- **Recomendación**: Validar cualquier entrada futura, mantener `shell=False`, y usar `shlex.split()` si se transforma a string.  
- **Reflexión como desarrollador**: Me di cuenta de que incluso cuando el comando es controlado, el simple hecho de usar `subprocess` exige una mentalidad de seguridad preventiva. Es un recordatorio de que **la seguridad debe aplicarse también a los scripts auxiliares**, no solo a las interfaces principales.

---

#### 🟡 **2. Clave secreta hardcodeada**
- **Archivo**: `main.py`, línea 59  
- **Riesgo**: Medio  
- **Contexto**: Se detectó una clave de API o token directamente en el código. Aunque era una prueba, esto es una mala práctica incluso en entornos locales.  
- **Recomendación**: Mover la clave a un archivo `.env` e importar con `os.getenv()`. En producción, esto permite rotar credenciales sin alterar el código fuente.

---

#### 🟡 **3. `debug=True` en entorno Flask**
- **Archivo**: `main.py`, línea 1397  
- **Riesgo**: Medio  
- **Justificación**: El modo debug expone trazas completas de error, lo que podría mostrar información sensible en producción (como rutas internas o variables).  
- **Recomendación**: Desactivar el debug en producción, controlarlo con una variable de entorno (`DEBUG=False`).

---

#### 🟡 **4. host='0.0.0.0' expuesto**
- **Archivo**: `main.py`, línea 1396  
- **Riesgo**: Medio  
- **Justificación**: Esta configuración hace que el servidor esté accesible desde cualquier IP. Útil en desarrollo remoto, pero riesgoso en entornos abiertos.  
- **Recomendación**: Restringir a `localhost` o proteger con reglas de firewall si se expone públicamente.

#### 🟢 **5. Variables no utilizadas**

- **Archivo**: main.py

- **Riesgo**: Bajo

- **Justificación**: Variables definidas que nunca se usan, lo que ensucia el código y complica su mantenimiento.

- **Recomendación**: Eliminar código muerto para mantener claridad y mantenibilidad.



---

### ✅ Conclusión Parcial (Seguridad)

El análisis realizado me permitió identificar que incluso decisiones de configuración aparentemente menores —como habilitar el modo `debug`, exponer el host o almacenar claves directamente en el código— pueden representar riesgos significativos para la seguridad de una aplicación.

Si bien este proyecto corresponde a un entorno académico, los hallazgos detectados son plenamente aplicables a contextos reales de desarrollo. Esta experiencia me llevó a valorar la importancia de adoptar una **postura preventiva en materia de seguridad desde las primeras etapas del desarrollo**.

En función de lo anterior, a futuro incorporaré herramientas como **Bandit** de manera temprana en los pipelines de integración continua (CI/CD), aplicaré estándares más estrictos para la gestión de credenciales y reforzaré la validación de entradas externas. Estas acciones me permitirán mejorar la calidad y robustez del software que desarrollo.

**A nivel personal**, este trabajo me hizo tomar conciencia de que escribir código funcional no es suficiente: también es mi responsabilidad que ese código sea seguro. Fue una llamada de atención sobre la profundidad que puede tener un análisis estático bien ejecutado y lo valioso que es incluirlo como parte integral del proceso de desarrollo.

---

## 🧾 3. Resultados del Análisis de Complejidad (Radon)

Radon evalúa la **complejidad ciclomática** de funciones, asignando notas de **A** (muy simple) a **F** (muy compleja).

### 📌 Principales Funciones Críticas

| Función                        | Ubicación     | Complejidad | Nota | Observaciones                                 |
|-------------------------------|---------------|-------------|------|-----------------------------------------------|
| `detallesEjerciciosEstudiantes` | `main.py:1199` | 35          | E    | Alta ramificación, múltiples responsabilidades |
| `detallesCurso`               | `main.py:701`  | 26          | D    | Muchas condiciones anidadas                   |
| `detallesEjercicio`           | `main.py:561`  | 18          | C    | Mezcla lógica de presentación y negocio       |
| `progresoCurso`               | `main.py:1035` | 18          | C    | Condicionales repetitivos                     |
| `dashDocente`                 | `main.py:297`  | 15          | C    | Filtros condicionales en la vista             |
| *(Otras funciones)*           | `varias`       | 11–15       | C    | Condiciones múltiples y lógica acoplada       |

✅ **Recomendación**: Refactorizar funciones complejas aplicando principios **SOLID**, modularización y separación de responsabilidades.

---

### 🧩 Análisis Personal

Al revisar las funciones con mayor complejidad, me llamó especialmente la atención `detallesEjerciciosEstudiantes`, con una complejidad de 35 (nota E). Al leerla, noté que mezcla múltiples responsabilidades: accede a la base de datos, filtra resultados, prepara estructuras para renderizar la vista, y maneja errores, todo en una misma función. Esto hace que entender su flujo lógico sea difícil y propenso a errores.

Algo similar ocurre con `detallesCurso` y `progresoCurso`, donde hay múltiples condicionales anidados y repetidos. Estas funciones son difíciles de testear, y cualquier cambio pequeño puede afectar múltiples partes. Esto confirma lo que aprendí teóricamente: alta complejidad = bajo mantenimiento.

Lo más preocupante fue notar que muchas funciones mezclan la lógica de presentación con la lógica de negocio (por ejemplo, HTML embebido con estructuras de control), lo que rompe con los principios de separación de capas.

🛠️ Como solución, propongo:
- Extraer funciones auxiliares pequeñas con responsabilidad única.
- Aplicar el principio **SRP** (Single Responsibility Principle).
- Mover la lógica de negocio fuera de las vistas hacia controladores/modulos aparte.

Este análisis me ayudó a comprender por qué la complejidad no es solo un número, sino un reflejo de cuán mantenible y comprensible es el código.

---

### 4. Resultados del Análisis de Calidad (Pylint)

**📊 Puntuación general del código:** `6.43 / 10`

Este resultado refleja una calidad intermedia en términos de estilo, claridad y buenas prácticas, lo cual es consistente con el desarrollo de un proyecto universitario en etapa de prototipo.

**🔍 Observaciones frecuentes detectadas:**

- ❌ **Falta de docstrings** en funciones y módulos, especialmente en archivos como `main.py` y `manejadorUsuarios.py`. Esto dificulta la comprensión del propósito de cada componente para futuros mantenedores.
- 🧩 **Variables e imports no utilizados**, lo que sugiere presencia de código muerto o parcialmente eliminado.
- 🔻 **Nombres poco descriptivos**, como `data2` o `x`, que afectan la legibilidad.
- 🚫 **Referencias a atributos inexistentes**, advertencias del tipo `no-member`, detectadas en métodos que acceden a propiedades no definidas en la clase.

**🧠 Análisis personal:**

Durante la revisión, noté que gran parte del código fue construido sin aplicar una guía de estilo unificada. Al tratarse de una plataforma que gestiona usuarios, ejercicios y retroalimentación paso a paso, la claridad del código es esencial para su mantenibilidad. El puntaje bajo en docstrings es particularmente crítico, ya que este proyecto podría ser extendido por otros desarrolladores y sin comentarios claros, la curva de aprendizaje se vuelve más empinada.

**✅ Recomendaciones específicas:**

- Añadir **docstrings claros** en funciones y clases para facilitar la comprensión del código.
- Eliminar **código muerto** o redundante.
- Usar **nombres más descriptivos** y acordes al dominio del problema.
- Validar y revisar los atributos de las clases para evitar **errores de acceso** (`no-member`) en tiempo de ejecución.

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
