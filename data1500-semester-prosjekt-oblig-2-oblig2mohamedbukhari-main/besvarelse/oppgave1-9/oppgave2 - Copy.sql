DO $$
DECLARE
    bok_guid uuid := gen_random_uuid();

    valuta_nok uuid := gen_random_uuid();
    valuta_usd uuid := gen_random_uuid();
    valuta_sek uuid := gen_random_uuid();

    klasse1_guid uuid := gen_random_uuid();
    klasse2_guid uuid := gen_random_uuid();
    klasse3_guid uuid := gen_random_uuid();
    klasse4_guid uuid := gen_random_uuid();
    klasse5_guid uuid := gen_random_uuid();
    klasse6_guid uuid := gen_random_uuid();
    klasse7_guid uuid := gen_random_uuid();
    klasse8_guid uuid := gen_random_uuid();

    rotkonto_guid uuid := gen_random_uuid();
    bank_guid uuid := gen_random_uuid();
    aksjekapital_guid uuid := gen_random_uuid();
    kundefordringer_guid uuid := gen_random_uuid();
    salgsinntekt_guid uuid := gen_random_uuid();
    utgående_mva_guid uuid := gen_random_uuid();
    inngående_mva_guid uuid := gen_random_uuid();
    leverandorgjeld_guid uuid := gen_random_uuid();
    rekvisita_guid uuid := gen_random_uuid();
    lønn_guid uuid := gen_random_uuid();
    arbeidsgiveravgift_guid uuid := gen_random_uuid();
    skyldig_arbeidsgiveravgift_guid uuid := gen_random_uuid();
    aksjer_usd_guid uuid := gen_random_uuid();

    periode1_guid uuid := gen_random_uuid();
    periode2_guid uuid := gen_random_uuid();
    periode3_guid uuid := gen_random_uuid();

    tx_guid uuid;
BEGIN

    -- Bøker
    INSERT INTO "BØKER" (guid, navn) VALUES (bok_guid, 'DATA1500 Konsult AS');

    -- Valutaer
    INSERT INTO "VALUTAER" (guid, kode, navn) VALUES
        (valuta_nok, 'NOK', 'Norske kroner'),
        (valuta_usd, 'USD', 'US Dollar'),
        (valuta_sek, 'SEK', 'Svenske kroner');

    -- Kontoklasser
    INSERT INTO "KONTOKLASSER" (guid, nummer, navn, type, normal_saldo) VALUES
        (klasse1_guid, 1, 'Eiendeler', 'Assets', 'Debet'),
        (klasse2_guid, 2, 'Gjeld og Egenkapital', 'Liabilities', 'Kredit'),
        (klasse3_guid, 3, 'Salgsinntekter', 'Income', 'Kredit'),
        (klasse4_guid, 4, 'Varekostnad', 'Expenses', 'Debet'),
        (klasse5_guid, 5, 'Lønnskostnader', 'Expenses', 'Debet'),
        (klasse6_guid, 6, 'Andre driftskostnader', 'Expenses', 'Debet'),
        (klasse7_guid, 7, 'Finanskostnader', 'Expenses', 'Debet'),
        (klasse8_guid, 8, 'Skatt', 'Expenses', 'Debet');

    -- Kontoer
    INSERT INTO "KONTOER" (guid, bok_guid, kontoklasse_guid, kontonummer, navn, er_placeholder) VALUES
        (rotkonto_guid, bok_guid, klasse1_guid, 0, 'Rotkonto', TRUE),
        (bank_guid, bok_guid, klasse1_guid, 1920, 'Bankinnskudd', FALSE),
        (aksjekapital_guid, bok_guid, klasse2_guid, 2000, 'Aksjekapital', FALSE),
        (kundefordringer_guid, bok_guid, klasse1_guid, 1500, 'Kundefordringer', FALSE),
        (salgsinntekt_guid, bok_guid, klasse3_guid, 3100, 'Salgsinntekt', FALSE),
        (utgående_mva_guid, bok_guid, klasse2_guid, 2700, 'Utgående MVA 25%', FALSE),
        (inngående_mva_guid, bok_guid, klasse2_guid, 2710, 'Inngående MVA 25%', FALSE),
        (leverandorgjeld_guid, bok_guid, klasse2_guid, 2400, 'Leverandørgjeld', FALSE),
        (rekvisita_guid, bok_guid, klasse6_guid, 6560, 'Kontorrekvisita', FALSE),
        (lønn_guid, bok_guid, klasse5_guid, 5000, 'Lønn', FALSE),
        (arbeidsgiveravgift_guid, bok_guid, klasse5_guid, 5400, 'Arbeidsgiveravgift', FALSE),
        (skyldig_arbeidsgiveravgift_guid, bok_guid, klasse2_guid, 2780, 'Skyldig arbeidsgiveravgift', FALSE),
        (aksjer_usd_guid, bok_guid, klasse1_guid, 1350, 'Aksjer i utenlandske selskaper', FALSE);

    -- Regnskapsperioder
    INSERT INTO "REGNSKAPSPERIODER" (guid, bok_guid, navn, start_dato, slutt_dato) VALUES
        (periode1_guid, bok_guid, 'Januar 2026', '2026-01-01', '2026-01-31'),
        (periode2_guid, bok_guid, 'Februar 2026', '2026-02-01', '2026-02-28'),
        (periode3_guid, bok_guid, 'Mars 2026', '2026-03-01', '2026-03-31');

    -- Scenario 1: Innskudd aksjekapital
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Innskudd aksjekapital', '2026-01-01') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, bank_guid, 20000000, 100),
        (gen_random_uuid(), tx_guid, aksjekapital_guid, -20000000, 100);

    -- Scenario 2: Kjøp kontorrekvisita
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Kjøp kontorrekvisita', '2026-01-05') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, rekvisita_guid, 350000, 100),
        (gen_random_uuid(), tx_guid, inngående_mva_guid, 87500, 100),
        (gen_random_uuid(), tx_guid, leverandorgjeld_guid, -437500, 100);

    -- Scenario 3: Fakturering kunde
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Fakturering TechNord AS', '2026-01-10') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, kundefordringer_guid, 6250000, 100),
        (gen_random_uuid(), tx_guid, salgsinntekt_guid, -5000000, 100),
        (gen_random_uuid(), tx_guid, utgående_mva_guid, -1250000, 100);

    -- Scenario 4: Innbetaling fra kunde
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Innbetaling fra TechNord AS', '2026-01-15') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, bank_guid, 6250000, 100),
        (gen_random_uuid(), tx_guid, kundefordringer_guid, -6250000, 100);

    -- Scenario 5: Lønn og arbeidsgiveravgift
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Lønn mars 2026', '2026-03-31') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, lønn_guid, 4500000, 100),
        (gen_random_uuid(), tx_guid, bank_guid, -3300000, 100),
        (gen_random_uuid(), tx_guid, skyldig_arbeidsgiveravgift_guid, -1200000, 100);

    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Arbeidsgiveravgift mars 2026', '2026-03-31') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, arbeidsgiveravgift_guid, 634500, 100),
        (gen_random_uuid(), tx_guid, skyldig_arbeidsgiveravgift_guid, -634500, 100);

    -- Scenario 6: Kjøp aksjer USD
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Kjøp 10 AAPL aksjer', '2026-04-01') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, aksjer_usd_guid, 1837500, 100),
        (gen_random_uuid(), tx_guid, bank_guid, -1837500, 100);

    -- Scenario 7: MVA-avregning
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'MVA-avregning 1. termin', '2026-01-31') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, utgående_mva_guid, 1250000, 100),
        (gen_random_uuid(), tx_guid, inngående_mva_guid, -87500, 100),
        (gen_random_uuid(), tx_guid, bank_guid, -1162500, 100);

    -- Scenario 8: Prosjektfakturering SEK med delvis betaling
    INSERT INTO "TRANSAKSJONER" (guid, bok_guid, beskrivelse, dato)
        VALUES (gen_random_uuid(), bok_guid, 'Fakturering Göteborg Tech AB', '2026-05-01') RETURNING guid INTO tx_guid;
    INSERT INTO "POSTERINGER" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner) VALUES
        (gen_random_uuid(), tx_guid, kundefordringer_guid, 5100000, 100), -- Debet NOK
        (gen_random_uuid(), tx_guid, salgsinntekt_guid, -5000000, 100), -- Kredit NOK
        (gen_random_uuid(), tx_guid, utgående_mva_guid, -100000, 100); -- Kredit MVA

END $$;


















-- تأكد من تفعيل UUID
CREATE EXTENSION IF NOT EXISTS pgcrypto;

--------------------------------------------------
-- 1. VALUTAER
--------------------------------------------------
INSERT INTO Valutaer (guid, kode, navn, desimaler)
VALUES
(gen_random_uuid(), 'NOK', 'Norske kroner', 2),
(gen_random_uuid(), 'USD', 'US Dollar', 2),
(gen_random_uuid(), 'SEK', 'Svenske kroner', 2);

--------------------------------------------------
-- 2. KONTOKLASSER
--------------------------------------------------
INSERT INTO Kontoklasser (klasse_nr, navn, type, normal_saldo)
VALUES
(1, 'Eiendeler', 'BALANSE', 'DEBET'),
(2, 'Gjeld og egenkapital', 'BALANSE', 'KREDIT'),
(3, 'Inntekter', 'RESULTAT', 'KREDIT'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET'),
(5, 'Lønn', 'RESULTAT', 'DEBET'),
(6, 'Andre kostnader', 'RESULTAT', 'DEBET'),
(7, 'Finans', 'RESULTAT', 'DEBET'),
(8, 'Skatt', 'RESULTAT', 'DEBET');

--------------------------------------------------
-- 3. BØKER
--------------------------------------------------
INSERT INTO Bøker (guid, navn)
VALUES (gen_random_uuid(), 'DATA1500 Konsult AS');

--------------------------------------------------
-- 4. KONTOER
--------------------------------------------------
INSERT INTO Kontoer (guid, bok_guid, valuta_guid, kontonummer, kontoklasse, navn, er_placeholder)
SELECT gen_random_uuid(), b.guid, v.guid, 1920, 1, 'Bank', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';

INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 2000, 2, 'Aksjekapital', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 1500, 1, 'Kundefordringer', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 3100, 3, 'Salgsinntekt', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 2700, 2, 'Utgående MVA', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 2710, 2, 'Inngående MVA', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 2400, 2, 'Leverandørgjeld', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 6560, 6, 'Rekvisita', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 5000, 5, 'Lønn', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 5400, 5, 'Arbeidsgiveravgift', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 2780, 2, 'Skyldig AGA', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 1350, 1, 'Aksjer', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';
INSERT INTO Kontoer SELECT gen_random_uuid(), b.guid, v.guid, 8150, 7, 'Valutatap', 0 FROM Bøker b, Valutaer v WHERE v.kode='NOK';

--------------------------------------------------
-- 5. REGNSKAPSPERIODER
--------------------------------------------------
INSERT INTO Regnskapsperioder (guid, bok_guid, navn, fra_dato, til_dato)
SELECT gen_random_uuid(), guid, 'Jan 2026', '2026-01-01','2026-01-31' FROM Bøker;

--------------------------------------------------
-- 6. DO BLOCK (TRANSAKSJONER)
--------------------------------------------------
DO $$
DECLARE
    tx uuid;
    b uuid;
    bank uuid;
    aksjekapital uuid;
    kundefordring uuid;
    inntekt uuid;
    ut_mva uuid;
    inn_mva uuid;
    levgjeld uuid;
    rekv uuid;
    lønn uuid;
    aga uuid;
    aga_skyld uuid;
    aksjer uuid;
    valutatap uuid;
BEGIN

SELECT guid INTO b FROM Bøker LIMIT 1;

SELECT guid INTO bank FROM Kontoer WHERE kontonummer=1920;
SELECT guid INTO aksjekapital FROM Kontoer WHERE kontonummer=2000;
SELECT guid INTO kundefordring FROM Kontoer WHERE kontonummer=1500;
SELECT guid INTO inntekt FROM Kontoer WHERE kontonummer=3100;
SELECT guid INTO ut_mva FROM Kontoer WHERE kontonummer=2700;
SELECT guid INTO inn_mva FROM Kontoer WHERE kontonummer=2710;
SELECT guid INTO levgjeld FROM Kontoer WHERE kontonummer=2400;
SELECT guid INTO rekv FROM Kontoer WHERE kontonummer=6560;
SELECT guid INTO lønn FROM Kontoer WHERE kontonummer=5000;
SELECT guid INTO aga FROM Kontoer WHERE kontonummer=5400;
SELECT guid INTO aga_skyld FROM Kontoer WHERE kontonummer=2780;
SELECT guid INTO aksjer FROM Kontoer WHERE kontonummer=1350;
SELECT guid INTO valutatap FROM Kontoer WHERE kontonummer=8150;

--------------------------------------------------
-- Scenario 1
--------------------------------------------------
INSERT INTO Transaksjoner (guid, bok_guid, beskrivelse)
VALUES (gen_random_uuid(), b, 'Aksjekapital') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, bank, 20000000,100),
(gen_random_uuid(), tx, aksjekapital, -20000000,100);

--------------------------------------------------
-- Scenario 2
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Rekvisita') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, rekv, 350000,100),
(gen_random_uuid(), tx, inn_mva, 87500,100),
(gen_random_uuid(), tx, levgjeld, -437500,100);

--------------------------------------------------
-- Scenario 3
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Faktura') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, kundefordring, 6250000,100),
(gen_random_uuid(), tx, inntekt, -5000000,100),
(gen_random_uuid(), tx, ut_mva, -1250000,100);

--------------------------------------------------
-- Scenario 4
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Betaling') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, bank, 6250000,100),
(gen_random_uuid(), tx, kundefordring, -6250000,100);

--------------------------------------------------
-- Scenario 5
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Lønn') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, lønn, 4500000,100),
(gen_random_uuid(), tx, bank, -3300000,100),
(gen_random_uuid(), tx, aga_skyld, -1200000,100);

INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'AGA') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, aga, 634500,100),
(gen_random_uuid(), tx, aga_skyld, -634500,100);

--------------------------------------------------
-- Scenario 6
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Aksjer') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, aksjer, 1837500,100),
(gen_random_uuid(), tx, bank, -1837500,100);

--------------------------------------------------
-- Scenario 7
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'MVA') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, ut_mva, 1250000,100),
(gen_random_uuid(), tx, inn_mva, -87500,100),
(gen_random_uuid(), tx, bank, -1162500,100);

--------------------------------------------------
-- Scenario 8
--------------------------------------------------
INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Faktura SEK') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, kundefordring, 5100000,100),
(gen_random_uuid(), tx, inntekt, -5000000,100),
(gen_random_uuid(), tx, ut_mva, -100000,100);

INSERT INTO Transaksjoner VALUES (gen_random_uuid(), b,'Betaling SEK') RETURNING guid INTO tx;

INSERT INTO Posteringer VALUES
(gen_random_uuid(), tx, bank, 4900000,100),
(gen_random_uuid(), tx, kundefordring, -5100000,100),
(gen_random_uuid(), tx, valutatap, 200000,100);

END $$;
--------------.
----------------
----------------
-------------------




















--
-- تأكد من تفعيل extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    -- BOK
    bok_guid uuid := gen_random_uuid();

    -- VALUTA
    nok uuid := gen_random_uuid();
    usd uuid := gen_random_uuid();
    sek uuid := gen_random_uuid();

    -- KONTOER
    bank uuid := gen_random_uuid();
    aksjekapital uuid := gen_random_uuid();
    kundefordringer uuid := gen_random_uuid();
    salgsinntekt uuid := gen_random_uuid();
    utgaaende_mva uuid := gen_random_uuid();
    inngaaende_mva uuid := gen_random_uuid();
    leverandorgjeld uuid := gen_random_uuid();
    rekvisita uuid := gen_random_uuid();
    loenn uuid := gen_random_uuid();
    aga uuid := gen_random_uuid();
    skyldig_aga uuid := gen_random_uuid();
    aksjer uuid := gen_random_uuid();

    -- PERIODER
    p_jan uuid := gen_random_uuid();
    p_mar uuid := gen_random_uuid();

    -- MVA
    mva_out uuid := gen_random_uuid();
    mva_in uuid := gen_random_uuid();

    -- TRANS
    tx uuid;

BEGIN

-- =====================================
-- 1. BØKER
-- =====================================
INSERT INTO "Bøker"(guid, navn)
VALUES (bok_guid, 'DATA1500 Konsult AS');

-- =====================================
-- 2. VALUTAER
-- =====================================
INSERT INTO "VALUTAER"(guid, kode, navn, desimaler, hent_kurs_flag)
VALUES
(nok, 'NOK','Norske kroner',2,0),
(usd, 'USD','US Dollar',2,0),
(sek, 'SEK','Svenske kroner',2,0);

-- =====================================
-- 3. KONTOER (مبسطة للتسليم)
-- =====================================
INSERT INTO "Kontoer"(guid, bok_guid, valuta_guid, kontonummer, kontoklasse, navn, beskrivelse, er_placeholder)
VALUES
(bank, bok_guid, nok, 1920,1,'Bank','',0),
(aksjekapital, bok_guid, nok, 2000,2,'Aksjekapital','',0),
(kundefordringer, bok_guid, nok,1500,1,'Kundefordringer','',0),
(salgsinntekt, bok_guid, nok,3100,3,'Salgsinntekt','',0),
(utgaaende_mva, bok_guid, nok,2700,2,'Utgående MVA','',0),
(inngaaende_mva, bok_guid, nok,2710,2,'Inngående MVA','',0),
(leverandorgjeld, bok_guid, nok,2400,2,'Leverandørgjeld','',0),
(rekvisita, bok_guid, nok,6560,6,'Rekvisita','',0),
(loenn, bok_guid, nok,5000,5,'Lønn','',0),
(aga, bok_guid, nok,5400,5,'AGA','',0),
(skyldig_aga, bok_guid, nok,2780,2,'Skyldig AGA','',0),
(aksjer, bok_guid, nok,1350,1,'Aksjer','',0);

-- =====================================
-- 4. PERIODER
-- =====================================
INSERT INTO "Regnskapsperioder"(guid, bok_guid, navn, fra_dato, til_dato)
VALUES
(p_jan, bok_guid, 'Jan 2026','2026-01-01','2026-01-31'),
(p_mar, bok_guid, 'Mar 2026','2026-03-01','2026-03-31');

-- =====================================
-- 5. MVA KODER
-- =====================================
INSERT INTO "MVA_koder"(guid,kode,navn,type,sats_teller,mva_konto_guid)
VALUES
(mva_out,'25U','Utgående MVA','UTGAAENDE',25,utgaaende_mva),
(mva_in,'25I','Inngående MVA','INNGAAENDE',25,inngaaende_mva);

-- =====================================
-- SCENARIO 1
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Aksjekapital',p_jan)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,bank,NULL,NULL,'n',NULL,20000000,100,0,1,NULL),
(gen_random_uuid(),tx,aksjekapital,NULL,NULL,'n',NULL,-20000000,100,0,1,NULL);

-- =====================================
-- SCENARIO 2
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Rekvisita',p_jan)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,rekvisita,NULL,NULL,'n',NULL,350000,100,0,1,NULL),
(gen_random_uuid(),tx,inngaaende_mva,NULL,NULL,'n',NULL,87500,100,0,1,NULL),
(gen_random_uuid(),tx,leverandorgjeld,NULL,NULL,'n',NULL,-437500,100,0,1,NULL);

-- =====================================
-- SCENARIO 3
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Fakturering',p_jan)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,kundefordringer,NULL,NULL,'n',NULL,6250000,100,0,1,NULL),
(gen_random_uuid(),tx,salgsinntekt,NULL,NULL,'n',NULL,-5000000,100,0,1,NULL),
(gen_random_uuid(),tx,utgaaende_mva,NULL,NULL,'n',NULL,-1250000,100,0,1,NULL);

-- =====================================
-- SCENARIO 4
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Betaling kunde',p_jan)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,bank,NULL,NULL,'n',NULL,6250000,100,0,1,NULL),
(gen_random_uuid(),tx,kundefordringer,NULL,NULL,'n',NULL,-6250000,100,0,1,NULL);

-- =====================================
-- SCENARIO 5
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Lønn',p_mar)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,loenn,NULL,NULL,'n',NULL,4500000,100,0,1,NULL),
(gen_random_uuid(),tx,bank,NULL,NULL,'n',NULL,-3300000,100,0,1,NULL),
(gen_random_uuid(),tx,skyldig_aga,NULL,NULL,'n',NULL,-1200000,100,0,1,NULL);

-- =====================================
-- SCENARIO 6
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Aksjer kjøp',p_mar)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,aksjer,NULL,NULL,'n',NULL,1837500,100,0,1,NULL),
(gen_random_uuid(),tx,bank,NULL,NULL,'n',NULL,-1837500,100,0,1,NULL);

-- =====================================
-- SCENARIO 7
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'MVA oppgjør',p_jan)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,utgaaende_mva,NULL,NULL,'n',NULL,1250000,100,0,1,NULL),
(gen_random_uuid(),tx,inngaaende_mva,NULL,NULL,'n',NULL,-87500,100,0,1,NULL),
(gen_random_uuid(),tx,bank,NULL,NULL,'n',NULL,-1162500,100,0,1,NULL);

-- =====================================
-- SCENARIO 8 (الناقص سابقاً)
-- =====================================
INSERT INTO "Transaksjoner"(guid,bok_guid,beskrivelse,periode_guid)
VALUES (gen_random_uuid(),bok_guid,'Valutatap',p_mar)
RETURNING guid INTO tx;

INSERT INTO "Posteringer" VALUES
(gen_random_uuid(),tx,bank,NULL,NULL,'n',NULL,4900000,100,0,1,NULL),
(gen_random_uuid(),tx,kundefordringer,NULL,NULL,'n',NULL,-5100000,100,0,1,NULL),
(gen_random_uuid(),tx,rekvisita,NULL,NULL,'n',NULL,200000,100,0,1,NULL);

END $$;
--------------------
------------------------
------------
DO $$
DECLARE
    -- BOK
    bok_guid CHAR(32) := replace(gen_random_uuid()::text,'-','');

    -- VALUTA
    nok CHAR(32) := replace(gen_random_uuid()::text,'-','');
    usd CHAR(32) := replace(gen_random_uuid()::text,'-','');
    sek CHAR(32) := replace(gen_random_uuid()::text,'-','');

    -- KONTOER
    bank CHAR(32) := replace(gen_random_uuid()::text,'-','');
    aksjekapital CHAR(32) := replace(gen_random_uuid()::text,'-','');
    kundefordringer CHAR(32) := replace(gen_random_uuid()::text,'-','');
    leverandorgjeld CHAR(32) := replace(gen_random_uuid()::text,'-','');
    salgsinntekt CHAR(32) := replace(gen_random_uuid()::text,'-','');
    rekvisita CHAR(32) := replace(gen_random_uuid()::text,'-','');
    inng_mva CHAR(32) := replace(gen_random_uuid()::text,'-','');
    utg_mva CHAR(32) := replace(gen_random_uuid()::text,'-','');
    lønn CHAR(32) := replace(gen_random_uuid()::text,'-','');
    aga CHAR(32) := replace(gen_random_uuid()::text,'-','');
    aga_skyldig CHAR(32) := replace(gen_random_uuid()::text,'-','');
    aksjer CHAR(32) := replace(gen_random_uuid()::text,'-','');

    -- MVA
    mva_in CHAR(32) := replace(gen_random_uuid()::text,'-','');
    mva_ut CHAR(32) := replace(gen_random_uuid()::text,'-','');

    -- PERIODE
    periode CHAR(32) := replace(gen_random_uuid()::text,'-','');

    tx CHAR(32);
BEGIN

-- =========================
-- BOK
-- =========================
INSERT INTO "Bøker"(guid, navn)
VALUES (bok_guid, 'DATA1500 Konsult AS');

-- =========================
-- VALUTA
-- =========================
INSERT INTO "VALUTAER"(guid, kode, navn, desimaler)
VALUES
(nok,'NOK','Norske kroner',2),
(usd,'USD','US Dollar',2),
(sek,'SEK','Svenske kroner',2);

-- =========================
-- KONTOER
-- =========================
INSERT INTO "Kontoer"(guid,bok_guid,valuta_guid,kontonummer,kontoklasse,navn,beskrivelse,er_placeholder)
VALUES
(bank,bok_guid,nok,1920,1,'Bank','',0),
(aksjekapital,bok_guid,nok,2000,2,'Aksjekapital','',0),
(kundefordringer,bok_guid,nok,1500,1,'Kundefordringer','',0),
(leverandorgjeld,bok_guid,nok,2400,2,'Leverandørgjeld','',0),
(salgsinntekt,bok_guid,nok,3100,3,'Salgsinntekt','',0),
(rekvisita,bok_guid,nok,6560,6,'Rekvisita','',0),
(inng_mva,bok_guid,nok,2710,2,'Inngående MVA','',0),
(utg_mva,bok_guid,nok,2700,2,'Utgående MVA','',0),
(lønn,bok_guid,nok,5000,5,'Lønn','',0),
(aga,bok_guid,nok,5400,5,'AGA','',0),
(aga_skyldig,bok_guid,nok,2780,2,'Skyldig AGA','',0),
(aksjer,bok_guid,usd,1350,1,'Aksjer','',0);

-- =========================
-- MVA KODER
-- =========================
INSERT INTO "MVA_koder"(guid,kode,navn,type,sats_teller,mva_konto_guid)
VALUES
(mva_in,'IN25','Inngående','INNGAAENDE',25,inng_mva),
(mva_ut,'UT25','Utgående','UTGAAENDE',25,utg_mva);

-- =========================
-- PERIODE
-- =========================
INSERT INTO "Regnskapsperioder"(guid,bok_guid,navn,fra_dato,til_dato)
VALUES (periode,bok_guid,'Jan 2026','2026-01-01','2026-01-31');

-- =========================
-- SCENARIO 1
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'Aksjekapital',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,bank,NULL,NULL,'n',NULL,20000000,100),
(replace(gen_random_uuid()::text,'-',''),tx,aksjekapital,NULL,NULL,'n',NULL,-20000000,100);

-- =========================
-- SCENARIO 2
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'Rekvisita',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,rekvisita,NULL,NULL,'n',NULL,350000,100),
(replace(gen_random_uuid()::text,'-',''),tx,inng_mva,NULL,NULL,'n',NULL,87500,100),
(replace(gen_random_uuid()::text,'-',''),tx,leverandorgjeld,NULL,NULL,'n',NULL,-437500,100);

-- =========================
-- SCENARIO 3
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'Faktura',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,kundefordringer,NULL,NULL,'n',NULL,6250000,100),
(replace(gen_random_uuid()::text,'-',''),tx,salgsinntekt,NULL,NULL,'n',NULL,-5000000,100),
(replace(gen_random_uuid()::text,'-',''),tx,utg_mva,NULL,NULL,'n',NULL,-1250000,100);

-- =========================
-- SCENARIO 4
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'Betaling',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,bank,NULL,NULL,'n',NULL,6250000,100),
(replace(gen_random_uuid()::text,'-',''),tx,kundefordringer,NULL,NULL,'n',NULL,-6250000,100);

-- =========================
-- SCENARIO 5
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'Lønn',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,lønn,NULL,NULL,'n',NULL,4500000,100),
(replace(gen_random_uuid()::text,'-',''),tx,bank,NULL,NULL,'n',NULL,-3300000,100),
(replace(gen_random_uuid()::text,'-',''),tx,aga_skyldig,NULL,NULL,'n',NULL,-1200000,100);

-- =========================
-- SCENARIO 6
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'Aksjer',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,aksjer,NULL,NULL,'n',NULL,1837500,100),
(replace(gen_random_uuid()::text,'-',''),tx,bank,NULL,NULL,'n',NULL,-1837500,100);

-- =========================
-- SCENARIO 7
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,nok,'MVA',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,utg_mva,NULL,NULL,'n',NULL,1250000,100),
(replace(gen_random_uuid()::text,'-',''),tx,inng_mva,NULL,NULL,'n',NULL,-87500,100),
(replace(gen_random_uuid()::text,'-',''),tx,bank,NULL,NULL,'n',NULL,-1162500,100);

-- =========================
-- SCENARIO 8
-- =========================
tx := replace(gen_random_uuid()::text,'-','');

INSERT INTO "Transaksjoner"(guid,bok_guid,valuta_guid,beskrivelse,periode_guid)
VALUES (tx,bok_guid,sek,'Valutatap',periode);

INSERT INTO "Posteringer"
VALUES
(replace(gen_random_uuid()::text,'-',''),tx,bank,NULL,NULL,'n',NULL,4900000,100),
(replace(gen_random_uuid()::text,'-',''),tx,kundefordringer,NULL,NULL,'n',NULL,-5100000,100),
(replace(gen_random_uuid()::text,'-',''),tx,lønn,NULL,NULL,'n',NULL,200000,100);

END $$;




















DO $$
DECLARE
    -- ===========================================
    -- تعريف GUIDs لجميع السجلات
    -- ===========================================
    bok_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    valuta_nok_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    valuta_usd_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    kontoklasse_balans INT := 1;
    kontoklasse_resultat INT := 2;
    
    konto_bank_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    konto_gjeld_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    periode_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    transaksjon_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    postering_debet_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    postering_kredit_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    mva_kode_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    mva_linje_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    kunde_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    leverandor_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    faktura_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    fakturalinje1_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    fakturalinje2_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    budsjett_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    planlagt_transaksjon_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    lot_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    valutakurs_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
BEGIN

-- ===========================================
-- 1. Bøker (الشركة / الدفتر المحاسبي)
-- ===========================================
INSERT INTO Bøker(guid, navn, organisasjonsnr, adresse, regnskapsaar)
VALUES (replace(gen_random_uuid()::text, '-', ''), 'DATA1500 Konsult AS', '123456789', 'Oslo, Norway', '2026-01-01');


-- ===========================================
-- 2. Valutaer (العملات)
-- ===========================================
INSERT INTO Valutaer(guid, kode, navn, desimaler, hent_kurs_flag, kurs_kilde)
VALUES
(valuta_nok_guid, 'NOK', 'Norske kroner', 2, 1, 'norges-bank'),
(valuta_usd_guid, 'USD', 'US Dollar', 2, 0, 'ecb');

-- ===========================================
-- 3. Kontoklasser (تصنيف الحسابات)
-- ===========================================
INSERT INTO Kontoklasser(klasse_nr, navn, type, normal_saldo, beskrivelse)
VALUES
(kontoklasse_balans, 'Eiendeler', 'BALANSE', 'DEBET', 'حسابات الأصول'),
(kontoklasse_resultat, 'Inntekt', 'RESULTAT', 'KREDIT', 'حسابات الإيرادات');

-- ===========================================
-- 4. Kontoer (الحسابات)
-- ===========================================
INSERT INTO Kontoer(guid, bok_guid, kontonummer, kontoklasse, valuta_guid, navn, beskrivelse)
VALUES
(konto_bank_guid, bok_guid, 1000, kontoklasse_balans, valuta_nok_guid, 'Bankkonto', 'حساب البنك الرئيسي'),
(konto_gjeld_guid, bok_guid, 2000, kontoklasse_balans, valuta_nok_guid, 'Leverandørgjeld', 'ديون الموردين');

-- ربط الحساب الرئيسي بالدفتر
UPDATE Bøker SET rot_konto_guid = konto_bank_guid WHERE guid = bok_guid;

-- ===========================================
-- 5. Regnskapsperioder (فترات المحاسبة)
-- ===========================================
INSERT INTO Regnskapsperioder(guid, bok_guid, navn, fra_dato, til_dato, status)
VALUES (periode_guid, bok_guid, 'Januar 2026', '2026-01-01', '2026-01-31', 'AAPEN');

-- ===========================================
-- 6. Transaksjoner (المعاملات)
-- ===========================================
INSERT INTO Transaksjoner(guid, bok_guid, valuta_guid, bilagsnummer, bilagsdato, posteringsdato, registreringsdato, beskrivelse, kilde, periode_guid)
VALUES
(transaksjon_guid, bok_guid, valuta_nok_guid, 'BILAG-001', '2026-01-05', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'شراء معدات', 'manuell', periode_guid);

-- ===========================================
-- 7. Posteringer (القيود)
-- ===========================================
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, tekst, handling, avstemmingsstatus, belop_teller, belop_nevner)
VALUES
(postering_debet_guid, transaksjon_guid, konto_bank_guid, 'دفع للبنك', 'شراء', 'n', 10000, 100),
(postering_kredit_guid, transaksjon_guid, konto_gjeld_guid, 'ديون المورد', 'شراء', 'n', -10000, 100);

-- ===========================================
-- 8. MVA_koder (رموز ضريبة القيمة المضافة)
-- ===========================================
INSERT INTO MVA_koder(guid, kode, navn, type, sats_teller, sats_nevner, mva_konto_guid, aktiv)
VALUES
(mva_kode_guid, '1', 'MVA 25%', 'UTGAAENDE', 25, 100, konto_gjeld_guid, 1);

-- ===========================================
-- 9. mva_linjer (خطوط ضريبة القيمة المضافة)
-- ===========================================
INSERT INTO mva_linjer(guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, grunnlag_nevner, mva_belop_teller, mva_belop_nevner)
VALUES
(mva_linje_guid, transaksjon_guid, mva_kode_guid, 10000, 100, 2500, 100);

-- ===========================================
-- 10. Kunder (العملاء)
-- ===========================================
INSERT INTO Kunder(guid, bok_guid, kundenummer, navn, organisasjonsnr, adresse, valuta_guid, betalingsbetingelse_guid, mva_kode_guid, aktiv)
VALUES
(kunde_guid, bok_guid, 'K0001', 'Ola Nordmann', '987654321', 'Oslo', valuta_nok_guid, NULL, mva_kode_guid, 1);

-- ===========================================
-- 11. Leverandører (الموردين)
-- ===========================================
INSERT INTO Leverandører(guid, bok_guid, leverandornummer, navn, organisasjonsnr, adresse, valuta_guid, aktiv)
VALUES
(leverandor_guid, bok_guid, 'L0001', 'Leverandør AS', '111222333', 'Oslo', valuta_nok_guid, 1);

-- ===========================================
-- 12. Fakturaer (الفواتير)
-- ===========================================
INSERT INTO Fakturaer(guid, bok_guid, fakturanummer, type, kunde_guid, leverandor_guid, valuta_guid, fakturadato, forfallsdato, posteringsdato, status, betalingsbetingelse_guid, transaksjon_guid)
VALUES
(faktura_guid, bok_guid, 'F2026-001', 'SALG', kunde_guid, leverandor_guid, valuta_nok_guid, '2026-01-05', '2026-01-20', CURRENT_TIMESTAMP, 'UTKAST', NULL, transaksjon_guid);

-- ===========================================
-- 13. Fakturalinjer (خطوط الفواتير)
-- ===========================================
INSERT INTO Fakturalinjer(guid, faktura_guid, beskrivelse, antall_teller, antall_nevner, enhetspris_teller, enhetspris_nevner, inntekt_konto_guid, kostnad_konto_guid, mva_kode_guid, mva_inkludert)
VALUES
(fakturalinje1_guid, faktura_guid, 'Laptop', 1, 1, 15000, 100, konto_bank_guid, konto_gjeld_guid, mva_kode_guid, 1),
(fakturalinje2_guid, faktura_guid, 'Mus', 1, 1, 500, 100, konto_bank_guid, konto_gjeld_guid, mva_kode_guid, 1);

-- ===========================================
-- 14. Budsjetter (الميزانيات)
-- ===========================================
INSERT INTO Budsjetter(guid, bok_guid, navn, beskrivelse, antall_perioder)
VALUES (budsjett_guid, bok_guid, 'Årsbudsjett 2026', 'الميزانية السنوية', 12);

-- ===========================================
-- 15. Planlagte_Transaksjoner (المعاملات المخططة)
-- ===========================================
INSERT INTO Planlagte_Transaksjoner(guid, bok_guid, navn, aktiv, startdato, sluttdato, gjentakelse_type, gjentakelse_mult, auto_opprett, sist_opprettet)
VALUES
(planlagt_transaksjon_guid, bok_guid, 'إيجار شهري', 1, '2026-01-01', '2026-12-31', 'MAANED', 1, 1, CURRENT_DATE);

-- ===========================================
-- 16. Lot (الأوراق المالية / المخزون)
-- ===========================================
INSERT INTO Lot(guid, konto_guid, beskrivelse, er_lukket)
VALUES
(lot_guid, konto_bank_guid, 'شراء/بيع أسهم', 0);

-- ===========================================
-- 17. Valutakurser (أسعار الصرف)
-- ===========================================
INSERT INTO Valutakurser(guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner)
VALUES
(valutakurs_guid, valuta_usd_guid, valuta_nok_guid, CURRENT_TIMESTAMP, 'ecb', 'last', 1000, 100);

END;
$$;







DO $$
DECLARE
    -- ===========================================
    -- UUIDs for all records
    -- ===========================================
    book_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    currency_nok_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    currency_usd_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    account_class_balance INT := 1;
    account_class_result INT := 2;
    
    account_bank_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    account_liability_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    period_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    transaction_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    posting_debit_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    posting_credit_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    vat_code_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    vat_line_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    customer_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    supplier_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    invoice_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    invoice_line1_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    invoice_line2_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    budget_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    planned_transaction_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    lot_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    exchange_rate_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
BEGIN

-- ===========================================
-- 1. Books
-- ===========================================
INSERT INTO Books(guid, name, organization_number, address, accounting_year)
VALUES (book_guid, 'DATA1500 Consulting AS', '123456789', 'Oslo, Norway', '2026-01-01');

-- ===========================================
-- 2. Currencies
-- ===========================================
INSERT INTO Currencies(guid, code, name, decimals, fetch_rate_flag, rate_source)
VALUES
(currency_nok_guid, 'NOK', 'Norwegian Kroner', 2, 1, 'norges-bank'),
(currency_usd_guid, 'USD', 'US Dollar', 2, 0, 'ecb');

-- ===========================================
-- 3. Account Classes
-- ===========================================
INSERT INTO AccountClasses(class_number, name, type, normal_balance, description)
VALUES
(account_class_balance, 'Assets', 'BALANCE', 'DEBIT', 'Balance sheet accounts'),
(account_class_result, 'Revenue', 'INCOME', 'CREDIT', 'Income statement accounts');

-- ===========================================
-- 4. Accounts
-- ===========================================
INSERT INTO Accounts(guid, book_guid, account_number, account_class, currency_guid, name, description)
VALUES
(account_bank_guid, book_guid, 1000, account_class_balance, currency_nok_guid, 'Bank Account', 'Main bank account'),
(account_liability_guid, book_guid, 2000, account_class_balance, currency_nok_guid, 'Accounts Payable', 'Supplier liabilities');

UPDATE Books SET root_account_guid = account_bank_guid WHERE guid = book_guid;

-- ===========================================
-- 5. Accounting Periods
-- ===========================================
INSERT INTO AccountingPeriods(guid, book_guid, name, start_date, end_date, status)
VALUES (period_guid, book_guid, 'January 2026', '2026-01-01', '2026-01-31', 'OPEN');

-- ===========================================
-- 6. Transactions
-- ===========================================
INSERT INTO Transactions(guid, book_guid, currency_guid, voucher_number, voucher_date, posting_date, registration_date, description, source, period_guid)
VALUES
(transaction_guid, book_guid, currency_nok_guid, 'VCHR-001', '2026-01-05', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Equipment purchase', 'manual', period_guid);

-- ===========================================
-- 7. Postings (Debit and Credit)
-- ===========================================
INSERT INTO Postings(guid, transaction_guid, account_guid, text, action, reconciliation_status, amount_numerator, amount_denominator)
VALUES
(posting_debit_guid, transaction_guid, account_bank_guid, 'Payment to bank', 'purchase', 'N', 10000, 100),
(posting_credit_guid, transaction_guid, account_liability_guid, 'Supplier liability', 'purchase', 'N', -10000, 100);

-- ===========================================
-- 8. VAT Codes
-- ===========================================
INSERT INTO VATCodes(guid, code, name, type, rate_numerator, rate_denominator, vat_account_guid, active)
VALUES
(vat_code_guid, '1', 'VAT 25%', 'OUTPUT', 25, 100, account_liability_guid, 1);

-- ===========================================
-- 9. VAT Lines
-- ===========================================
INSERT INTO VATLines(guid, transaction_guid, vat_code_guid, base_numerator, base_denominator, vat_amount_numerator, vat_amount_denominator)
VALUES
(vat_line_guid, transaction_guid, vat_code_guid, 10000, 100, 2500, 100);

-- ===========================================
-- 10. Customers
-- ===========================================
INSERT INTO Customers(guid, book_guid, customer_number, name, organization_number, address, currency_guid, payment_term_guid, vat_code_guid, active)
VALUES
(customer_guid, book_guid, 'C0001', 'Ola Nordmann', '987654321', 'Oslo', currency_nok_guid, NULL, vat_code_guid, 1);

-- ===========================================
-- 11. Suppliers
-- ===========================================
INSERT INTO Suppliers(guid, book_guid, supplier_number, name, organization_number, address, currency_guid, active)
VALUES
(supplier_guid, book_guid, 'S0001', 'Supplier AS', '111222333', 'Oslo', currency_nok_guid, 1);

-- ===========================================
-- 12. Invoices
-- ===========================================
INSERT INTO Invoices(guid, book_guid, invoice_number, type, customer_guid, supplier_guid, currency_guid, invoice_date, due_date, posting_date, status, payment_term_guid, transaction_guid)
VALUES
(invoice_guid, book_guid, 'INV2026-001', 'SALES', customer_guid, supplier_guid, currency_nok_guid, '2026-01-05', '2026-01-20', CURRENT_TIMESTAMP, 'DRAFT', NULL, transaction_guid);

-- ===========================================
-- 13. Invoice Lines
-- ===========================================
INSERT INTO InvoiceLines(guid, invoice_guid, description, quantity_numerator, quantity_denominator, unit_price_numerator, unit_price_denominator, income_account_guid, expense_account_guid, vat_code_guid, vat_included)
VALUES
(invoice_line1_guid, invoice_guid, 'Laptop', 1, 1, 15000, 100, account_bank_guid, account_liability_guid, vat_code_guid, 1),
(invoice_line2_guid, invoice_guid, 'Mouse', 1, 1, 500, 100, account_bank_guid, account_liability_guid, vat_code_guid, 1);

-- ===========================================
-- 14. Budgets
-- ===========================================
INSERT INTO Budgets(guid, book_guid, name, description, number_of_periods)
VALUES (budget_guid, book_guid, 'Annual Budget 2026', 'Full year budget', 12);

-- ===========================================
-- 15. Planned Transactions
-- ===========================================
INSERT INTO PlannedTransactions(guid, book_guid, name, active, start_date, end_date, recurrence_type, recurrence_multiplier, auto_create, last_created)
VALUES
(planned_transaction_guid, book_guid, 'Monthly Rent', 1, '2026-01-01', '2026-12-31', 'MONTHLY', 1, 1, CURRENT_DATE);

-- ===========================================
-- 16. Lot (Inventory / Securities)
-- ===========================================
INSERT INTO Lots(guid, account_guid, description, closed)
VALUES
(lot_guid, account_bank_guid, 'Stock purchase/sale', 0);

-- ===========================================
-- 17. Exchange Rates
-- ===========================================
INSERT INTO ExchangeRates(guid, from_currency_guid, to_currency_guid, date, source, type, rate_numerator, rate_denominator)
VALUES
(exchange_rate_guid, currency_usd_guid, currency_nok_guid, CURRENT_TIMESTAMP, 'ecb', 'last', 1000, 100);

END;
$$;











































-------------------
----------------------
-------------------
-- 1. تنظيف البيانات لضمان نظافة الاختبار
TRUNCATE TABLE "Posteringer", "mva_linjer", "Transaksjoner", "Kontoer", "Regnskapsperioder", 
               "MVA_koder", "Valutakurser", "Valutaer", "Kontoklasser", "Bøker" CASCADE;

-- 2. إدخال العملات (ISO 4217)
INSERT INTO "Valutaer" (guid, kode, navn, desimaler) VALUES 
('val-nok', 'NOK', 'Norske kroner', 2),
('val-usd', 'USD', 'US Dollar', 2),
('val-sek', 'SEK', 'Svenske kroner', 2);

-- 3. إدخال فئات الحسابات (NS 4102)
INSERT INTO "Kontoklasser" (klasse_nr, navn, type, normal_saldo) VALUES 
(1, 'Eiendeler', 'BALANSE', 'DEBET'),
(2, 'Egenkapital og gjeld', 'BALANSE', 'KREDIT'),
(3, 'Salgs- og driftsinntekt', 'RESULTAT', 'KREDIT'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET'),
(5, 'Lønnskostnad', 'RESULTAT', 'DEBET'),
(6, 'Annen driftskostnad', 'RESULTAT', 'DEBET'),
(7, 'Finansielle poster', 'RESULTAT', 'DEBET'),
(8, 'Skatt og årsavslutning', 'RESULTAT', 'DEBET');

-- 4. إدخال "الكتاب" (Bok) الأساسي
INSERT INTO "Bøker" (guid, navn, organisasjonsnr, regnskapsaar) 
VALUES ('bok-2026', 'DATA1500 Konsult AS', '987654321', '2026-01-01');

-- 5. إنشاء فترات المحاسبة لعام 2026
INSERT INTO "Regnskapsperioder" (guid, bok_guid, navn, fra_dato, til_dato)
SELECT 
    'per-2026-' || LPAD(m::text, 2, '0'), 'bok-2026', 
    TO_CHAR(TO_DATE(m::text, 'MM'), 'Month 2026'),
    CAST('2026-' || m || '-01' AS DATE),
    (CAST('2026-' || m || '-01' AS DATE) + INTERVAL '1 month' - INTERVAL '1 day')::DATE
FROM generate_series(1, 12) m;

-- 6. كتلة البرمجة لتنفيذ السيناريوهات 8
DO $$
DECLARE
    v_bok_guid CHAR(32) := 'bok-2026';
    v_root_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    
    -- معرفات الحسابات (سنقوم بتوليدها واستخدامها للربط)
    v_acc_1920 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Bank
    v_acc_2000 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Aksjekapital
    v_acc_6560 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Rekvisita
    v_acc_2710 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Inng. MVA
    v_acc_2400 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Leverandørgjeld
    v_acc_1500 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Kundefordringer
    v_acc_3100 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Salgsinntekt
    v_acc_2700 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Utg. MVA
    v_acc_5000 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Lønn
    v_acc_2600 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Forskuddstrekk
    v_acc_5400 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- AGA Kostnad
    v_acc_2780 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- AGA Gjeld
    v_acc_1350 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Aksjer Apple
    v_acc_2740 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Oppgjørskonto MVA
    v_acc_8160 CHAR(32) := replace(gen_random_uuid()::text, '-', ''); -- Valutatap

    -- معرفات الـ MVA
    v_mva_in_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');
    v_mva_out_guid CHAR(32) := replace(gen_random_uuid()::text, '-', '');

    -- متغيرات مساعدة للعمليات
    v_tx_guid CHAR(32);
BEGIN
    -- أ. إدخال حساب الجذر والربط
    INSERT INTO "Kontoer" (guid, bok_guid, valuta_guid, navn, er_placeholder)
    VALUES (v_root_guid, v_bok_guid, 'val-nok', 'Root Account', 1);

    UPDATE "Bøker" SET rot_konto_guid = v_root_guid WHERE guid = v_bok_guid;

    -- ب. إدخال حسابات الفئات (Level 2)
    INSERT INTO "Kontoer" (guid, bok_guid, overordnet_guid, valuta_guid, navn, kontoklasse, er_placeholder)
    SELECT 'acc-class-' || klasse_nr, v_bok_guid, v_root_guid, 'val-nok', navn, klasse_nr, 1
    FROM "Kontoklasser";

    -- ج. إدخال الحسابات التشغيلية المطلوبة في السيناريوهات (Level 3)
    INSERT INTO "Kontoer" (guid, bok_guid, overordnet_guid, valuta_guid, kontonummer, kontoklasse, navn) VALUES
    (v_acc_1920, v_bok_guid, 'acc-class-1', 'val-nok', 1920, 1, 'Bankinnskudd'),
    (v_acc_1500, v_bok_guid, 'acc-class-1', 'val-nok', 1500, 1, 'Kundefordringer'),
    (v_acc_1350, v_bok_guid, 'acc-class-1', 'val-nok', 1350, 1, 'Aksjer i utl. selskaper'),
    (v_acc_2000, v_bok_guid, 'acc-class-2', 'val-nok', 2000, 2, 'Aksjekapital'),
    (v_acc_2400, v_bok_guid, 'acc-class-2', 'val-nok', 2400, 2, 'Leverandørgjeld'),
    (v_acc_2700, v_bok_guid, 'acc-class-2', 'val-nok', 2700, 2, 'Utgående MVA'),
    (v_acc_2710, v_bok_guid, 'acc-class-2', 'val-nok', 2710, 2, 'Inngående MVA'),
    (v_acc_2600, v_bok_guid, 'acc-class-2', 'val-nok', 2600, 2, 'Forskuddstrekk'),
    (v_acc_2780, v_bok_guid, 'acc-class-2', 'val-nok', 2780, 2, 'Skyldig AGA'),
    (v_acc_2740, v_bok_guid, 'acc-class-2', 'val-nok', 2740, 2, 'Oppgjørskonto MVA'),
    (v_acc_3100, v_bok_guid, 'acc-class-3', 'val-nok', 3100, 3, 'Salgsinntekt'),
    (v_acc_5000, v_bok_guid, 'acc-class-5', 'val-nok', 5000, 5, 'Lønn til ansatte'),
    (v_acc_5400, v_bok_guid, 'acc-class-5', 'val-nok', 5400, 5, 'Arbeidsgiveravgift'),
    (v_acc_6560, v_bok_guid, 'acc-class-6', 'val-nok', 6560, 6, 'Rekvisita'),
    (v_acc_8160, v_bok_guid, 'acc-class-8', 'val-nok', 8160, 8, 'Valutatap');

    -- د. إدخال أكواد الضريبة
    INSERT INTO "MVA_koder" (guid, kode, navn, type, sats_teller, mva_konto_guid) VALUES 
    (v_mva_out_guid, '3', 'Utgående MVA 25%', 'UTGAAENDE', 25, v_acc_2700),
    (v_mva_in_guid, '1', 'Inngående MVA 25%', 'INNGAAENDE', 25, v_acc_2710);

    -- هـ. إدخال أسعار الصرف (Scenario 6 & 8)
    INSERT INTO "Valutakurser" (guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner) VALUES
    (replace(gen_random_uuid()::text, '-', ''), 'val-usd', 'val-nok', '2026-01-15', 'manuell', 'last', 1050, 100), -- 10.50 NOK/USD
    (replace(gen_random_uuid()::text, '-', ''), 'val-sek', 'val-nok', '2026-02-01', 'manuell', 'last', 102, 100),  -- 1.02 NOK/SEK
    (replace(gen_random_uuid()::text, '-', ''), 'val-sek', 'val-nok', '2026-03-01', 'manuell', 'last', 98, 100);   -- 0.98 NOK/SEK

    ---------------------------------------------------------------------------
    -- السـيناريوهات الـ 8
    ---------------------------------------------------------------------------

    -- 1. Stiftelse (200,000 NOK)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B1', 'Innskudd aksjekapital', 'per-2026-01');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, 20000000),   -- Debet Bank
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2000, -20000000); -- Kredit AK

    -- 2. Kjøp rekvisita (4,375 inkl MVA)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B2', 'Kjøp rekvisita', 'per-2026-01');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_6560, 350000),    -- Debet Kostnad
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2710, 87500),     -- Debet MVA
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2400, -437500);  -- Kredit Leverandør
    INSERT INTO "mva_linjer" (guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, mva_belop_teller)
    VALUES (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_mva_in_guid, 350000, 87500);

    -- 3. Fakturering kunde (62,500 inkl MVA)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'F1', 'Konsulentoppdrag', 'per-2026-01');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, 6250000),   -- Debet Kunder
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_3100, -5000000),  -- Kredit Inntekt
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2700, -1250000); -- Kredit MVA
    INSERT INTO "mva_linjer" (guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, mva_belop_teller)
    VALUES (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_mva_out_guid, 5000000, 1250000);

    -- 4. Innbetaling fra kunde (Scenario 3)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B3', 'Betaling fra TechNord', 'per-2026-02');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, 6250000),   -- Debet Bank
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, -6250000); -- Kredit Kunder

    -- 5. Lønnsutbetaling (Scenario 5 A & B)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'L1', 'Lønn Mars 2026', 'per-2026-03');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_5000, 4500000),   -- Bruttolønn
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, -3300000),  -- Nettolønn
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2600, -1200000),  -- Skatt
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_5400, 634500),    -- AGA Kost
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2780, -634500);   -- AGA Gjeld

    -- 6. Kjøp USD-aksjer (Apple)
    -- 1750 USD = 18375 NOK (10.50 kurs)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B4', 'Kjøp AAPL aksjer', 'per-2026-01');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1350, 1837500),   -- Debet Aksjer
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, -1837500); -- Kredit Bank

    -- 7. MVA-oppgjør (Scenario 7)
    -- Ut: 12500, Inn: 875 -> Betal: 11625
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'M1', 'MVA Oppgjør 1. termin', 'per-2026-03');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2700, 1250000),   -- Nuller Ut-MVA
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2710, -87500),    -- Nuller Inn-MVA
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, -1162500); -- Betaling fra bank

    -- 8. Prosjektfakturering SEK (Disagio)
    -- Faktura: 51,000 NOK (Kurs 1.02)
    -- Innbet: 49,000 NOK (Kurs 0.98) -> Valutatap 2,000
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'F2', 'Prosjekt Göteborg Tech', 'per-2026-02');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, 5100000),   -- Debet Kunder (Høy kurs)
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_3100, -5100000); -- Kredit Inntekt

    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO "Transaksjoner" (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B5', 'Innbetaling SEK (Valutatap)', 'per-2026-03');
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, 4900000),   -- Debet Bank (Lav kurs)
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_8160, 200000),    -- Debet Valutatap
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, -5100000); -- Kredit Kunder (Full sum)

END $$;

-- 7. التحقق النهائي (Verification)
SELECT t.guid, t.beskrivelse, SUM(p.belop_teller::numeric / 100) AS saldo
FROM "Transaksjoner" t
JOIN "Posteringer" p ON p.transaksjon_guid = t.guid
GROUP BY t.guid, t.beskrivelse
HAVING ABS(SUM(p.belop_teller::numeric / 100)) > 0.001;