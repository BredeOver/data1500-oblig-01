-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller
DROP TABLE IF EXISTS utleie CASCADE;
DROP TABLE IF EXISTS laas CASCADE;
DROP TABLE IF EXISTS sykkel CASCADE;
DROP TABLE IF EXISTS stasjon CASCADE;
DROP TABLE IF EXISTS kunde CASCADE;

CREATE TABLE kunde (
    kunde_id SERIAL PRIMARY KEY,
    mobilnummer VARCHAR(15) NOT NULL UNIQUE,
    fornavn VARCHAR(50) NOT NULL,
    etternavn VARCHAR(50) NOT NULL,
    epost VARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT check_kunde_mobilnummer
        CHECK (mobilnummer ~ '^[0-9]{8,15}$'),
    CONSTRAINT check_kunde_fornavn
        CHECK (length(trim(fornavn)) > 0),
    CONSTRAINT check_kunde_etternavn
        CHECK (length(trim(etternavn)) > 0),
    CONSTRAINT check_kunde_epost
        CHECK (epost ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$')
);

CREATE TABLE stasjon (
    stasjon_id SERIAL PRIMARY KEY,
    addresse VARCHAR(100) NOT NULL,

    CONSTRAINT check_stasjon
        CHECK (length(trim(sted)) > 0)
);

CREATE TABLE sykkel (
    sykkel_id SERIAL PRIMARY KEY,
    status BOOLEAN NOT NULL
);

CREATE TABLE laas (
    laas_id SERIAL PRIMARY KEY,
    stasjon_id INT NOT NULL REFERENCES stasjon(stasjon_id),
    status BOOLEAN NOT NULL
);

CREATE TABLE utleie (
    utleie_id SERIAL PRIMARY KEY,
    kunde_id INT NOT NULL REFERENCES kunde(kunde_id),
    sykkel_id INT NOT NULL REFERENCES sykkel(sykkel_id),

    utlevert_stasjon_id INT NOT NULL REFERENCES stasjon(stasjon_id),
    utlevert_tid TIMESTAMP NOT NULL,

    innlevert_tid TIMESTAMP NULL,
    innlevert_stasjon_id INT NULL REFERENCES stasjon(stasjon_id),

    belop NUMERIC NULL,

    CONSTRAINT check_utleie_belop
        CHECK (belop IS NULL OR belop >= 0),
    CONSTRAINT check_utleie_tid
        CHECK (innlevert_tid IS NULL OR innlevert_tid >= utlevert_tid),
    CONSTRAINT check_utleie_innlevering
        CHECK (
            (innlevert_tid IS NULL AND innlevert_stasjon_id IS NULL)
                OR
            (innlevert_tid IS NOT NULL AND innlevert_stasjon_id IS NOT NULL)
            )
);



-- Sett inn testdata



-- DBA setninger (rolle: kunde, bruker: kunde_1)
INSERT INTO kunde (mobilnummer, fornavn, etternavn, epost)
SELECT
    (90000000 + gs)::text,
    'Fornavn' || gs,
    'Etternavn' || gs,
    'kunde' || gs || '@example.com'
FROM generate_series(1, 5) gs;

INSERT INTO sykkel (status)
SELECT TRUE
FROM generate_series(1, 100);

INSERT INTO stasjon (addresse) VALUES
('Sentrum Stasjon'),
('Universitetet Stasjon'),
('Grünerløkka Stasjon'),
('Aker Brygge Stasjon'),
('Majorstuen Stasjon');

INSERT INTO laas (stasjon_id, status)
SELECT
    s.stasjon_id,
    TRUE
FROM  stasjon s
CROSS JOIN generate_series(1,20);

INSERT INTO utleie (kunde_id, sykkel_id, utlevert_stasjon_id, utlevert_tid, innlevert_tid, innlevert_stasjon_id, belop)
SELECT
    (1 + floor(random()*5))::int,
    (1 + floor(random()*100))::int,
    (1 + floor(random()*5))::int,
            CURRENT_TIMESTAMP - (random() * interval '30 days'),
    CURRENT_TIMESTAMP,
    (1 + floor(random()*5))::int,
    round((random()*100)::numeric, 2)
FROM generate_series(1, 50);

-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;