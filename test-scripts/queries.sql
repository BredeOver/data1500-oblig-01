-- ============================================================================
-- TEST-SKRIPT FOR OBLIG 1
-- ============================================================================

-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/queries.sql

-- En test med en SQL-spørring mot metadata i PostgreSQL (kan slettes fra din script)
select nspname as schema_name from pg_catalog.pg_namespace;

-- 5.1 Viser alle sykler
SELECT *
FROM sykkel;

-- 5.2 Viser etternavn, fornavn og mobilnummer for alle kunder, sortert alfabetisk på etternavn
SELECT etternavn, fornavn, mobilnummer
FROM kunde
ORDER BY etternavn ASC;

-- 5.3 Viser alle sykler som er tatt i bruk etter 1. april 2023
SELECT *
FROM sykkel;

-- 5.4 Viser antallet kunder i bysykkelordningen
SELECT COUNT(*) AS antall_kunder
FROM kunde;

-- 5.5 Viser alle kunder og teller antall utleier per kunde
SELECT k.kunde_id,
       k.fornavn,
       k.etternavn,
       COUNT(u.utleie_id) AS antall_utleier
FROM kunde k
         LEFT JOIN utleie u
                   ON k.kunde_id = u.kunde_id
GROUP BY k.kunde_id, k.fornavn, k.etternavn
ORDER BY k.etternavn;

-- 5.6 Viser hvilke kunder som aldri har leid en sykkel
SELECT k.kunde_id,
       k.fornavn,
       k.etternavn
FROM kunde k
         LEFT JOIN utleie u
                   ON k.kunde_id = u.kunde_id
WHERE u.utleie_id IS NULL;

-- 5.7 Viser hvilke sykler som aldri har vært utleid
SELECT s.sykkel_id
FROM sykkel s
         LEFT JOIN utleie u
                   ON s.sykkel_id = u.sykkel_id
WHERE u.utleie_id IS NULL;

-- 5.8 Viser sykler som ikke er levert etter ett døgn
SELECT s.sykkel_id,
       k.fornavn,
       k.etternavn,
       u.utlevert_tid
FROM utleie u