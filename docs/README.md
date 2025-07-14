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

En el caso específico del uso de subprocess.run(['mvn', 'clean', 'test']), este comando permite ejecutar pruebas con Maven desde un script Python. En el contexto del proyecto, se utiliza para verificar automáticamente el funcionamiento de ejercicios antes de ser cargados a la plataforma. Si bien no recibe entrada externa en esta versión, al estar ubicado en un script que podría ser modificado o reutilizado, se vuelve relevante pensar en su validación y sanitización para evitar ejecución arbitraria en escenarios futuros.

---

#### 🟡 **2. Clave secreta incrustada en el código fuente**
- **Archivo**: `main.py`, línea 59  
- **Riesgo**: Medio  
- **Contexto**:Se detectó una clave de API o token directamente en el código. Aunque se trataba de una prueba, esto representa una mala práctica incluso en entornos de desarrollo   
- **Recomendación**: Mover la clave a un archivo .env e importarla mediante os.getenv(). En entornos productivos, esto facilita la rotación de credenciales sin modificar el código fuente y permite aplicar buenas prácticas de seguridad.
---

#### 🟡 **3. Entorno de desarrollo con Flask**
- **Archivo**: `main.py`, línea 1397  
- **Riesgo**: Medio  
- **Justificación**: Ejecutar Flask con debug=True habilita la traza completa de errores, lo que podría revelar rutas internas, estructuras del código o variables sensibles en caso de fallo.
- **Recomendación**: Desactivar el modo debug en producción y gestionarlo mediante una variable de entorno (DEBUG=False), respetando el principio de configuración externa.



---

#### 🟡 **4. host='0.0.0.0' expuesto**
- **Archivo**: `main.py`, línea 1396  
- **Riesgo**: Medio  
- **Justificación**: Esta configuración hace que el servidor esté accesible desde cualquier IP. Útil en desarrollo remoto, pero riesgoso en entornos abiertos.  
- **Recomendación**: Restringir a `localhost` o proteger con reglas de firewall si se expone públicamente.

---
#### 🟢 **5. Variables no utilizadas**

- **Archivo**: main.py

- **Riesgo**: Bajo

- **Justificación**: Variables definidas que nunca se usan, lo que ensucia el código y complica su mantenimiento.

- **Recomendación**: Eliminar código muerto para mantener claridad y mantenibilidad.



---

### Conclusión Parcial (Seguridad)

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

### Análisis Personal

Al revisar las funciones con mayor complejidad, me llamó especialmente la atención `detallesEjerciciosEstudiantes`, con una complejidad de 35 (nota E). Al leerla, noté que mezcla múltiples responsabilidades: accede a la base de datos, filtra resultados, prepara estructuras para renderizar la vista, y maneja errores, todo en una misma función. Esto hace que entender su flujo lógico sea difícil y propenso a errores.

Algo similar ocurre con `detallesCurso` y `progresoCurso`, donde hay múltiples condicionales anidados y repetidos. Estas funciones son difíciles de testear, y cualquier cambio pequeño puede afectar múltiples partes. Esto confirma lo que aprendí teóricamente: alta complejidad = bajo mantenimiento.

Lo más preocupante fue notar que muchas funciones mezclan la lógica de presentación con la lógica de negocio (por ejemplo, HTML embebido con estructuras de control), lo que rompe con los principios de separación de capas.

🛠️ Como solución, propongo:
- Extraer funciones auxiliares pequeñas con responsabilidad única.
- Aplicar el principio **SRP** (Single Responsibility Principle).
- Mover la lógica de negocio fuera de las vistas hacia controladores/modulos aparte.

---

## 🧹 4. Resultados del Análisis de Calidad (Pylint)

📊 **Puntuación general del código:** `6.43 / 10`

Este resultado refleja una calidad intermedia en cuanto a estilo, claridad y buenas prácticas, lo que es coherente con un proyecto académico en fase de prototipo.

🔍 **Observaciones frecuentes detectadas:**

- ❌ *Falta de docstrings* en funciones y módulos, especialmente en archivos como `main.py` y `manejadorUsuarios.py`, lo que dificulta la comprensión del propósito de cada componente.
- 🟢 *Variables e imports no utilizados*, evidencia de código redundante o parcialmente eliminado.
- 🔻 *Nombres poco descriptivos*, como `data2` o `x`, que afectan la legibilidad y claridad semántica del código.
- ⛔ *Referencias a atributos inexistentes* (`no-member`), asociadas a errores de acceso a propiedades no definidas.

🧠 **Análisis personal:**

Durante la revisión, observé que gran parte del código se construyó sin seguir una guía de estilo unificada. Siendo esta una plataforma orientada al acompañamiento progresivo de usuarios, mantener un código claro, documentado y coherente es esencial. La ausencia de *docstrings* y la presencia de nombres genéricos dificultan la lectura y el traspaso del proyecto a otros desarrolladores, comprometiendo su mantenibilidad.

🔧 **Recomendaciones específicas:**

- Incorporar *docstrings* claros y precisos en todas las funciones y clases.
- Eliminar *código muerto* o redundante para mejorar la limpieza del repositorio.
- Utilizar *nombres descriptivos* y significativos, acordes al dominio de la aplicación.
- Validar atributos de clase y corregir *errores de acceso* (`no-member`) en tiempo de ejecución.

📌 **Reflexión final:**  
Esta evaluación me permitió comprender que la calidad del código no se limita a su funcionamiento, sino que también se manifiesta en su estructura, legibilidad y capacidad de evolución. Me di cuenta de que seguir principios de estilo no es solo una formalidad, sino algo clave para que el código sea entendible y mantenible en el tiempo.

---

## 🧾 Conclusión Final

El análisis realizado a lo largo del proyecto *CodeBending* reveló tanto fortalezas como oportunidades claras de mejora en aspectos críticos del desarrollo de software:

- 🛡️ **Seguridad**: Se identificaron malas prácticas potencialmente riesgosas, como el uso de `subprocess` sin validación adecuada. En entornos reales, estas decisiones pueden derivar en vulnerabilidades graves. Este hallazgo refuerza la necesidad de adoptar una postura de seguridad desde el inicio del desarrollo.

- 🔧 **Mantenibilidad**: La complejidad ciclomática elevada en funciones clave refleja un diseño con responsabilidades poco claras. Esto dificulta la lectura, el testeo y la evolución del sistema, haciendo urgente una refactorización basada en principios como *SRP* y separación de capas.

- 🧹 **Calidad de código**: Aunque la puntuación obtenida es aceptable para un prototipo académico, se detectaron múltiples aspectos que afectan la legibilidad y consistencia, como nombres poco descriptivos y ausencia de *docstrings*. Elevar el estándar es clave si se busca escalar o mantener el proyecto en el tiempo.

✅ **Recomendación general**: Automatizar los análisis de seguridad y calidad como parte integral del ciclo de desarrollo, incorporando herramientas como **Bandit** y **Pylint** en pipelines de CI/CD. Esto no solo permitirá detectar problemas tempranamente, sino que fomentará una cultura de desarrollo más profesional y sostenible.

---


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
