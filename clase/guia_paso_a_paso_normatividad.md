# 🧭 Guía Paso a Paso: Checklist de Cumplimiento Normativo

Esta guía complementa el `README.md` del taller. Su objetivo es que, antes de evaluar el cumplimiento normativo de GobData en clase (Parte 1) o del sistema del cliente real (Parte 2), el equipo tenga una referencia clara de qué exige cada marco y de la metodología para pasar de "marcar casillas" a un diagnóstico legal priorizado.

---

## 1. Marcos normativos de referencia

| Marco / Norma | Qué exige (resumen) | Aplica cuando... |
|---|---|---|
| Habeas Data (Ley 1581 de 2012 - Colombia) | Consentimiento informado, finalidad del tratamiento, derechos ARCO (Acceso, Rectificación, Cancelación, Oposición) | El sistema recolecta datos personales de ciudadanos o usuarios colombianos |
| ISO/IEC 27001 | Gestión sistemática de la seguridad de la información: control de accesos, gestión de incidentes, continuidad | El sistema maneja información que debe protegerse de forma sistemática |
| Protección contra fugas de datos | Cifrado, monitoreo y respuesta ante incidentes de exposición de datos | El sistema almacena o transmite datos sensibles |
| Consentimiento, auditoría y roles de acceso | Registro de quién accede a qué dato, bajo qué autorización | El sistema tiene múltiples roles con distinto nivel de acceso a datos sensibles |

---

## 2. Metodología en 5 pasos

1. **Identificar datos y procesos sensibles** — liste qué información procesa el sistema y qué normativa le aplica a cada una.
2. **Construir el checklist** — agrupe los requisitos a verificar por sección (consentimiento, seguridad, retención, roles/auditoría), basándose en los marcos de la sección 1.
3. **Evaluar el cumplimiento** — para cada ítem, marque **Cumple**, **Brecha** o **No aplica**, siempre con evidencia o justificación concreta.
4. **Documentar el riesgo de cada brecha** — explique qué pasa si esa brecha no se corrige (sanción, exposición de datos, pérdida de trazabilidad).
5. **Priorizar y recomendar** — ordene las brechas por riesgo y proponga una acción correctiva concreta para cada una.

---

## 3. Ejemplo guiado: Checklist de GobData

### Paso 1 — Identificar datos y procesos sensibles

| Dato / Proceso | Sensibilidad | Normativa aplicable |
|---|---|---|
| Número de identificación (cédula) | Dato personal | Ley 1581 |
| Historial clínico | Dato sensible (salud) | Ley 1581 (tratamiento reforzado) |
| Dirección de residencia | Dato personal | Ley 1581 |
| Certificados digitales | Dato de identidad / autenticación | ISO 27001 (control de accesos) |
| Trámites y peticiones ciudadanas | Trazabilidad de gestión pública | ISO 27001 (auditoría) |

### Paso 2 — Construir el checklist por sección

| Sección | Ítem |
|---|---|
| Consentimiento | C1: Existe aviso de privacidad accesible antes de recolectar datos |
| Consentimiento | C2: Se solicita consentimiento explícito para datos sensibles (ej. historial clínico) |
| Seguridad | S1: Los datos sensibles están cifrados en tránsito y en reposo |
| Seguridad | S2: Existe un procedimiento documentado de respuesta a incidentes de fuga de datos |
| Retención | R1: Existe una política de tiempo de retención y eliminación de datos |
| Retención | R2: Los datos se eliminan o anonimizan al vencer su finalidad |
| Roles y auditoría | A1: El acceso a datos sensibles está limitado por rol (RBAC) |
| Roles y auditoría | A2: Existe registro de auditoría de quién accede a qué dato y cuándo |

### Paso 3 — Evaluar el cumplimiento

| Ítem | Estado | Evidencia / Justificación |
|---|---|---|
| C1 | ✅ Cumple | El portal publica un aviso de privacidad visible antes del registro |
| C2 | ⚠️ Brecha | El formulario de trámites de salud no pide consentimiento separado para el historial clínico |
| S1 | ⚠️ Brecha | Los certificados digitales se transmiten sin verificar TLS en todos los subdominios |
| S2 | ⚠️ Brecha | No existe un procedimiento documentado de respuesta a incidentes |
| R1 | ⚠️ Brecha | No hay una política de retención publicada |
| R2 | ⚠️ Brecha | Consecuencia directa de R1: sin política, no hay eliminación programada |
| A1 | ✅ Cumple | El sistema define roles (ciudadano, funcionario, administrador) |
| A2 | ⚠️ Brecha | No hay registro visible de auditoría de accesos a historiales clínicos |

### Paso 4 — Documentar el riesgo de cada brecha

| Ítem | Riesgo si no se corrige |
|---|---|
| C2 | Sanción de la SIC por tratamiento de datos sensibles sin consentimiento explícito (Ley 1581) |
| S1 | Exposición de certificados digitales y posible suplantación de identidad ciudadana |
| S2 | Respuesta lenta y desordenada ante una fuga real, agravando el impacto |
| R1 / R2 | Acumulación indefinida de datos sensibles, incumpliendo el principio de finalidad de la Ley 1581 |
| A2 | Imposibilidad de demostrar cumplimiento ante una auditoría o investigación de la SIC |

### Paso 5 — Priorizar y recomendar

Esta es la tabla final que se entrega como `checklist-cliente.xlsx`, ordenada de mayor a menor prioridad:

| Prioridad | Ítem | Estado | Riesgo | Recomendación |
|---|---|---|---|---|
| 1 | C2 | Brecha | Sanción legal por dato sensible sin consentimiento | Agregar un consentimiento explícito y separado para historial clínico |
| 2 | S1 | Brecha | Exposición de datos de identidad | Forzar TLS en todos los subdominios y auditar certificados |
| 3 | A2 | Brecha | Sin trazabilidad ante auditoría | Implementar registro de auditoría (logs) de acceso a datos sensibles |
| 4 | R1 / R2 | Brecha | Retención indefinida de datos | Definir y publicar política de retención y eliminación |
| 5 | S2 | Brecha | Respuesta desordenada ante incidentes | Documentar procedimiento de respuesta a incidentes de fuga de datos |

---

## 4. Errores comunes a evitar

| Error frecuente | Por qué es un problema | Cómo corregirlo |
|---|---|---|
| Marcar "Cumple" sin evidencia concreta | El checklist se vuelve una opinión, no una auditoría verificable | Cite dónde se observa el cumplimiento (documento, pantalla, configuración) |
| Usar "No aplica" para evitar analizar un ítem incómodo | Oculta brechas reales en vez de documentarlas | Solo use "No aplica" cuando el sistema genuinamente no procesa ese tipo de dato/proceso |
| Copiar el checklist genérico sin adaptarlo al sector del cliente | Ignora normativas sectoriales específicas (salud, educación, finanzas) | Investigue y agregue normativas propias del sector del cliente (MinSalud, MinTIC, SuperSalud, SFC, etc.) |
| Recomendaciones sin relación con la brecha encontrada | El informe pierde utilidad práctica para el cliente | Cada recomendación debe corregir directamente el ítem marcado como brecha |

---

## 5. Checklist de autoevaluación antes de entregar

- [ ] Cada ítem está evaluado como Cumple, Brecha o No aplica, con evidencia o justificación.
- [ ] Los ítems están organizados por sección (consentimiento, seguridad, retención, roles, etc.).
- [ ] Cada brecha tiene un riesgo legal/operativo explicado, no solo "no cumple".
- [ ] Se investigaron normativas sectoriales adicionales aplicables al cliente.
- [ ] Las brechas están priorizadas y cada una tiene una recomendación correctiva concreta.
- [ ] El informe cita la normativa específica detrás de cada hallazgo, cuando aplica.

---

_Esta guía hace parte del Taller 6 de Checklist de Cumplimiento Normativo — curso Arquitectura Empresarial, Universidad de La Sabana._
