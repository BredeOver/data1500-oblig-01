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
    innlevert_stasjon_id INT NOT NULL REFERENCES stasjon(stasjon_id),

    belop NUMERIC NULL,

    COONSTRAINT check_utleie_belop
        CHECK (beløp IS NULL OR beløp >= 0)
    CONSTRAINT check_utleie_tid
        CHECK (innlevert_tid IS NULL OR innlevert_tid >= utlevert_tid)
    CONSTRAINT check_utleie_innlevering
        CHECK (
            (innlevert_tid IS NULL AND innlevert_stasjon_id IS NULL)
                OR
            (innlevert_tid IS NOT NULL AND innlevert_stasjon_id IS NOT NULL)
            )
);



-- Sett inn testdata



-- DBA setninger (rolle: kunde, bruker: kunde_1)



-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;