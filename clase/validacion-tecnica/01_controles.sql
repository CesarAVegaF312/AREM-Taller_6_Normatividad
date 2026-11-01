-- Maqueta de GobData (caso base del Taller 6) con los controles técnicos
-- que el checklist marca como "Cumple". Cada bloque indica el ítem del checklist.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Ítem 11: roles y permisos documentados. Cada rol de negocio es un usuario
-- de la base de datos con permisos distintos.
CREATE ROLE funcionario_tramites LOGIN PASSWORD 'tramites';
CREATE ROLE profesional_salud    LOGIN PASSWORD 'salud';

CREATE TABLE ciudadano (
    id_ciudadano   INTEGER      PRIMARY KEY,
    cedula         VARCHAR(20)  NOT NULL UNIQUE,
    nombre         VARCHAR(100) NOT NULL,
    direccion      VARCHAR(150) NOT NULL
);

CREATE TABLE tramite (
    id_tramite     INTEGER      PRIMARY KEY,
    id_ciudadano   INTEGER      NOT NULL REFERENCES ciudadano (id_ciudadano),
    tipo           VARCHAR(60)  NOT NULL,
    estado         VARCHAR(20)  NOT NULL CHECK (estado IN ('abierto', 'cerrado')),
    fecha_cierre   DATE
);

-- Ítem 4: cifrado de campos sensibles. El diagnóstico (dato sensible de salud,
-- Ley 1581) se guarda cifrado; en la tabla solo hay bytes ilegibles.
CREATE TABLE historial_clinico (
    id_registro    INTEGER      PRIMARY KEY,
    id_ciudadano   INTEGER      NOT NULL REFERENCES ciudadano (id_ciudadano),
    diagnostico    BYTEA        NOT NULL
);

-- La llave de cifrado vive en una tabla a la que ningún rol de negocio tiene acceso.
-- En producción iría en un gestor de llaves (KMS), nunca dentro de la misma base.
CREATE TABLE llave_cifrado (
    llave          TEXT         NOT NULL
);

-- Ítem 7: logs de acceso a información personal.
CREATE TABLE auditoria_acceso (
    id_evento      SERIAL       PRIMARY KEY,
    usuario        TEXT         NOT NULL,
    id_ciudadano   INTEGER      NOT NULL,
    momento        TIMESTAMP    NOT NULL DEFAULT now()
);

-- Única puerta de entrada al historial clínico: descifra y deja registro de
-- quién consultó a quién y cuándo. Nadie lee la tabla directamente.
CREATE FUNCTION consultar_historial(p_id_ciudadano INTEGER)
RETURNS TABLE (id_registro INTEGER, diagnostico TEXT)
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
    INSERT INTO auditoria_acceso (usuario, id_ciudadano) VALUES (session_user, p_id_ciudadano);
    RETURN QUERY
        SELECT h.id_registro, pgp_sym_decrypt(h.diagnostico, (SELECT llave FROM llave_cifrado))
        FROM historial_clinico h
        WHERE h.id_ciudadano = p_id_ciudadano;
END;
$$;

-- Permisos (ítem 11): el funcionario de trámites ve ciudadanos y trámites, pero no
-- el historial clínico; el profesional de salud solo accede al historial por la función.
REVOKE ALL ON FUNCTION consultar_historial(INTEGER) FROM PUBLIC;
GRANT SELECT ON ciudadano, tramite TO funcionario_tramites;
GRANT SELECT ON ciudadano TO profesional_salud;
GRANT EXECUTE ON FUNCTION consultar_historial(INTEGER) TO profesional_salud;
