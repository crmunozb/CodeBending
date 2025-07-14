## 📄 Análisis Estático del Proyecto CodeBending

## 1. Introducción
Este informe documenta el análisis estático realizado al proyecto CodeBending, una plataforma desarrollada en Python para la gestión y seguimiento de ejercicios de programación paso a paso. El objetivo fue evaluar la calidad, seguridad y mantenibilidad del código, utilizando tres herramientas especializadas:

- **Bandit**: Detección de vulnerabilidades de seguridad.

- **Radon**: Evaluación de la complejidad ciclomática del código.

- **Pylint**: Análisis de calidad, estilo y convenciones de buenas prácticas Python.

## 2. Resultados del Análisis con Bandit

**Resumen**:

**Líneas analizadas**: 1346

**Archivos analizados**: 1

**Vulnerabilidades detectadas**: 5

**Alta**: 1

**Media**: 3

**Baja**: 1

**Hallazgos clave**:

- **Uso de subprocess sin validación segura**

Archivo: manejoMaven.py, líneas 1 y 7

Riesgo: Alto

Justificación: Aunque el comando ['mvn', 'clean', 'test'] es fijo, debe protegerse de entradas externas.

Recomendación: Validar entradas, mantener shell=False, y usar shlex.split().

- **Clave secreta hardcodeada**

Archivo: main.py, línea 59

Riesgo: Medio

Recomendación: Extraer a .env o usar os.getenv.

- **debug=True en entorno Flask**

Archivo: main.py, línea 1397

Riesgo: Alto

Recomendación: Controlar por variable de entorno y eliminar en producción.

- **host='0.0.0.0' expuesto**

Archivo: main.py, línea 1396

Riesgo: Medio

Recomendación: Restringir a localhost o usar firewall en producción.

## 3. Resultados del Análisis de Complejidad (Radon)
Radon analiza la complejidad ciclomática de funciones, asignando notas de A (simple) a F (muy compleja).

Principales funciones críticas:
Función	Ubicación	Complejidad	Nota	Observaciones
detallesEjerciciosEstudiantes	main.py:1199	35	E	Alta ramificación y múltiples responsabilidades.
detallesCurso	main.py:701	26	D	Muchas condiciones anidadas.
detallesEjercicio	main.py:561	18	C	Mezcla lógica de presentación y negocio.
progresoCurso	main.py:1035	18	C	Condicionales repetitivos.
dashDocente	main.py:297	15	C	Filtros condicionales en la vista.
Otras funciones	varias	11–15	C	Condiciones múltiples y lógica acoplada.

✅ Recomendación: Refactorizar funciones grandes y aplicar principios SOLID.

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

- Como desarrollador, este análisis me permitió tener una visión más crítica del código y entender que escribir funciones que "funcionan" no basta. Hay que escribir funciones comprensibles, seguras y escalables.

- Decidí reemplazar Flake8 por Pylint porque me ofrecía diagnósticos más profundos, detectando aspectos que antes pasaban desapercibidos como nombres poco claros o estructuras de control demasiado densas.

- Respecto al análisis de Bandit, el hallazgo más importante fue el uso de subprocess.run() sin validación. A pesar de usar un comando fijo (mvn clean test), me di cuenta del riesgo si alguien llegase a manipular esta parte en un entorno productivo. Esto refuerza la importancia de no confiar nunca en ninguna entrada sin validación, incluso en pruebas.

- En lo personal, reafirmé que el análisis estático no debe ser una etapa opcional, sino parte integral del desarrollo profesional. Planeo implementar escaneos automáticos desde el inicio de los proyectos, para evitar errores costosos más adelante.

📌 *Última revisión: 14 de Julio 2025*

👤 Autor

**Cristóbal Muñoz Barrios**  
Estudiante de Ingeniería Civil Informática - Universidad de Concepción  
GitHub: [@crmunozb](https://github.com/crmunozb)  
