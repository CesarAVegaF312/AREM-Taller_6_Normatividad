-- Datos de prueba de GobData. Todos son inventados: nunca use datos reales de ciudadanos.

INSERT INTO llave_cifrado (llave) VALUES ('llave-de-prueba-solo-para-la-maqueta');

INSERT INTO ciudadano (id_ciudadano, cedula, nombre, direccion) VALUES
    (1, '1000000001', 'Laura Méndez',   'Calle 1 # 2-03'),
    (2, '1000000002', 'Jorge Castillo', 'Carrera 4 # 5-06'),
    (3, '1000000003', 'Sofía Rincón',   'Avenida 7 # 8-09');

INSERT INTO tramite (id_tramite, id_ciudadano, tipo, estado, fecha_cierre) VALUES
    (100, 1, 'Certificado de residencia', 'cerrado', '2019-03-15'),
    (101, 2, 'Solicitud de cita médica',  'cerrado', '2018-11-02'),
    (102, 3, 'Petición ciudadana',        'abierto', NULL);

INSERT INTO historial_clinico (id_registro, id_ciudadano, diagnostico)
SELECT r.id, r.ciudadano, pgp_sym_encrypt(r.texto, (SELECT llave FROM llave_cifrado))
FROM (VALUES
    (500, 1, 'Hipertensión arterial controlada'),
    (501, 2, 'Control prenatal sin complicaciones'),
    (502, 3, 'Asma leve')
) AS r (id, ciudadano, texto);
