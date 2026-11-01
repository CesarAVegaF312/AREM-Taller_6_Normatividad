-- Validación de los controles técnicos del checklist de GobData.
-- Cada bloque comprueba un ítem marcado "Cumple" (o confirma un "Parcial")
-- con evidencia que sale de la base de datos, no de un documento.

\echo ''
\echo '=== Ítem 4: cifrado de campos sensibles ==='
\echo 'Así ve el diagnóstico quien abre la tabla directamente (bytes, no texto):'
SELECT id_registro, left(encode(diagnostico, 'hex'), 40) || '...' AS diagnostico_en_tabla
FROM historial_clinico;

\echo ''
\echo '=== Ítem 11: roles y permisos (cada instrucción DEBE fallar con ERROR) ==='
\c - funcionario_tramites
\echo 'R1. El funcionario de trámites no puede leer el historial clínico:'
SELECT * FROM historial_clinico;
\echo 'R2. Tampoco puede usar la función de consulta del historial:'
SELECT * FROM consultar_historial(1);
\echo 'R3. Ni leer la llave de cifrado:'
SELECT * FROM llave_cifrado;

\echo ''
\echo '=== Ítem 7: registro de accesos a información personal ==='
\c - profesional_salud
\echo 'El profesional de salud consulta el historial de la ciudadana 1 (permitido):'
SELECT * FROM consultar_historial(1);
\echo 'R4. Pero no puede borrar el rastro de esa consulta (DEBE fallar con ERROR):'
DELETE FROM auditoria_acceso;

\c - gobdata
\echo 'El registro de auditoría muestra quién consultó a quién y cuándo:'
SELECT usuario, id_ciudadano, momento FROM auditoria_acceso ORDER BY id_evento;

\echo ''
\echo '=== Ítem 10: anonimización de datos que ya no son necesarios (marcado Parcial) ==='
\echo 'Ciudadanos cuyos trámites se cerraron hace más de 5 años y conservan todos sus datos:'
SELECT c.cedula, c.nombre, c.direccion, t.tipo, t.fecha_cierre
FROM ciudadano c
JOIN tramite t ON t.id_ciudadano = c.id_ciudadano
WHERE t.estado = 'cerrado' AND t.fecha_cierre < current_date - INTERVAL '5 years';
\echo 'Si esta consulta devuelve filas, la brecha del ítem 10 está confirmada con evidencia.'
