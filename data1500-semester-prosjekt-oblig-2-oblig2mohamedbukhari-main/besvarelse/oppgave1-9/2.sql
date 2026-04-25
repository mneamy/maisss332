TRUNCATE TABLE Posteringer, mva_linjer, Transaksjoner, Kontoer, Regnskapsperioder, 
               MVA_koder, Valutakurser, Valutaer, Kontoklasser, Bøker CASCADE;

-- 2. إدخال العملات (ISO 4217)
INSERT INTO Valutaer (guid, kode, navn, desimaler) VALUES 
('val-nok', 'NOK', 'Norske kroner', 2),
('val-usd', 'USD', 'US Dollar', 2),
('val-sek', 'SEK', 'Svenske kroner', 2);

-- 3. إدخال فئات الحسابات (NS 4102)
INSERT INTO Kontoklasser (klasse_nr, navn, type, normal_saldo) VALUES 
(1, 'Eiendeler', 'BALANSE', 'DEBET'),
(2, 'Egenkapital og gjeld', 'BALANSE', 'KREDIT'),
(3, 'Salgs- og driftsinntekt', 'RESULTAT', 'KREDIT'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET'),
(5, 'Lønnskostnad', 'RESULTAT', 'DEBET'),
(6, 'Annen driftskostnad', 'RESULTAT', 'DEBET'),
(7, 'Finansielle poster', 'RESULTAT', 'DEBET'),
(8, 'Skatt og årsavslutning', 'RESULTAT', 'DEBET');

-- 4. إدخال الكتاب (Bok) الأساسي
INSERT INTO Bøker (guid, navn, organisasjonsnr, regnskapsaar) 
VALUES ('bok-2026', 'DATA1500 Konsult AS', '987654321', '2026-01-01');

-- 5. إنشاء فترات المحاسبة لعام 2026
INSERT INTO Regnskapsperioder (guid, bok_guid, navn, fra_dato, til_dato)
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
    INSERT INTO Kontoer (guid, bok_guid, valuta_guid, navn, er_placeholder)
    VALUES (v_root_guid, v_bok_guid, 'val-nok', 'Root Account', 1);

    UPDATE Bøker SET rot_konto_guid = v_root_guid WHERE guid = v_bok_guid;

    -- ب. إدخال حسابات الفئات (Level 2)
    INSERT INTO Kontoer (guid, bok_guid, overordnet_guid, valuta_guid, navn, kontoklasse, er_placeholder)
    SELECT 'acc-class-' || klasse_nr, v_bok_guid, v_root_guid, 'val-nok', navn, klasse_nr, 1
    FROM Kontoklasser;

    -- ج. إدخال الحسابات التشغيلية المطلوبة في السيناريوهات (Level 3)
    INSERT INTO Kontoer (guid, bok_guid, overordnet_guid, valuta_guid, kontonummer, kontoklasse, navn) VALUES
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
    INSERT INTO MVA_koder (guid, kode, navn, type, sats_teller, mva_konto_guid) VALUES 
    (v_mva_out_guid, '3', 'Utgående MVA 25%', 'UTGAAENDE', 25, v_acc_2700),
    (v_mva_in_guid, '1', 'Inngående MVA 25%', 'INNGAAENDE', 25, v_acc_2710);

    -- هـ. إدخال أسعار الصرف (Scenario 6 & 8)
    INSERT INTO Valutakurser (guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner) VALUES
    (replace(gen_random_uuid()::text, '-', ''), 'val-usd', 'val-nok', '2026-01-15', 'manuell', 'last', 1050, 100), -- 10.50 NOK/USD
    (replace(gen_random_uuid()::text, '-', ''), 'val-sek', 'val-nok', '2026-02-01', 'manuell', 'last', 102, 100),  -- 1.02 NOK/SEK
    (replace(gen_random_uuid()::text, '-', ''), 'val-sek', 'val-nok', '2026-03-01', 'manuell', 'last', 98, 100);   -- 0.98 NOK/SEK

    ---------------------------------------------------------------------------
    -- السـيناريوهات الـ 8
    ---------------------------------------------------------------------------

    -- 1. Stiftelse (200,000 NOK)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B1', 'Innskudd aksjekapital', 'per-2026-01');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, 20000000),   -- Debet Bank
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2000, -20000000); -- Kredit AK

    -- 2. Kjøp rekvisita (4,375 inkl MVA)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B2', 'Kjøp rekvisita', 'per-2026-01');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_6560, 350000),    -- Debet Kostnad
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2710, 87500),     -- Debet MVA
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2400, -437500);  -- Kredit Leverandør
    INSERT INTO mva_linjer (guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, mva_belop_teller)
    VALUES (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_mva_in_guid, 350000, 87500);

    -- 3. Fakturering kunde (62,500 inkl MVA)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'F1', 'Konsulentoppdrag', 'per-2026-01');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, 6250000),   -- Debet Kunder
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_3100, -5000000),  -- Kredit Inntekt
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2700, -1250000); -- Kredit MVA
    INSERT INTO mva_linjer (guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, mva_belop_teller)
    VALUES (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_mva_out_guid, 5000000, 1250000);

    -- 4. Innbetaling fra kunde (Scenario 3)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B3', 'Betaling fra TechNord', 'per-2026-02');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, 6250000),   -- Debet Bank
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, -6250000); -- Kredit Kunder

    -- 5. Lønnsutbetaling (Scenario 5 A & B)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'L1', 'Lønn Mars 2026', 'per-2026-03');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_5000, 4500000),   -- Bruttolønn
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, -3300000),  -- Nettolønn
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2600, -1200000),  -- Skatt
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_5400, 634500),    -- AGA Kost
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2780, -634500);   -- AGA Gjeld

    -- 6. Kjøp USD-aksjer (Apple)
    -- 1750 USD = 18375 NOK (10.50 kurs)
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B4', 'Kjøp AAPL aksjer', 'per-2026-01');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1350, 1837500),   -- Debet Aksjer
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, -1837500); -- Kredit Bank

    -- 7. MVA-oppgjør (Scenario 7)
    -- Ut: 12500, Inn: 875 -> Betal: 11625
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'M1', 'MVA Oppgjør 1. termin', 'per-2026-03');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2700, 1250000),   -- Nuller Ut-MVA
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_2710, -87500),    -- Nuller Inn-MVA
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, -1162500); -- Betaling fra bank

    -- 8. Prosjektfakturering SEK (Disagio)
    -- Faktura: 51,000 NOK (Kurs 1.02)
    -- Innbet: 49,000 NOK (Kurs 0.98) -> Valutatap 2,000
    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'F2', 'Prosjekt Göteborg Tech', 'per-2026-02');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, 5100000),   -- Debet Kunder (Høy kurs)
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_3100, -5100000); -- Kredit Inntekt

    v_tx_guid := replace(gen_random_uuid()::text, '-', '');
    INSERT INTO Transaksjoner (guid, bok_guid, valuta_guid, bilagsnummer, beskrivelse, periode_guid)
    VALUES (v_tx_guid, v_bok_guid, 'val-nok', 'B5', 'Innbetaling SEK (Valutatap)', 'per-2026-03');
    INSERT INTO Posteringer (guid, transaksjon_guid, konto_guid, belop_teller) VALUES
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1920, 4900000),   -- Debet Bank (Lav kurs)
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_8160, 200000),    -- Debet Valutatap
    (replace(gen_random_uuid()::text, '-', ''), v_tx_guid, v_acc_1500, -5100000); -- Kredit Kunder (Full sum)

END $$;

-- 7. التحقق النهائي (Verification)
SELECT t.guid, t.beskrivelse, SUM(p.belop_teller::numeric / 100) AS saldo
FROM Transaksjoner t
JOIN Posteringer p ON p.transaksjon_guid = t.guid
GROUP BY t.guid, t.beskrivelse
HAVING ABS(SUM(p.belop_teller::numeric / 100)) > 0.001;











-----------------
محمد
---------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    bok_guid char(32) := replace(gen_random_uuid()::text,'-','');

    value_NOK_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_USD_guid char(32) := replace(gen_random_uuid()::text,'-','');

    valutakurser_guid char(32) := replace(gen_random_uuid()::text,'-','');

 -- GUIDs للحسابات الرئيسية (placeholders)
    kontoer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- GUIDs للحسابات الفرعية
    kontoer9_guid  char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer10_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer11_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer12_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer13_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer14_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer15_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer16_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer17_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer18_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer19_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer20_guid char(32) := replace(gen_random_uuid()::text,'-','');

BEGIN

-- 📘 BØKER
INSERT INTO bøker(guid, navn, organisasjonsnr, adresse, regnskapsaar)
VALUES
(bok_guid, 'DATA1500 Konsult AS', '123456789', 'Oslo', DATE '2026-01-01');

-- 💱 VALUTAER
INSERT INTO valutaer(guid, kode, navn, desimaler, hent_kurs_flag, kurs_kilde)
VALUES
(value_NOK_guid, 'NOK', 'krone', 2, 1, 'BANK'),
(value_USD_guid, 'USD', 'Dollar', 2, 0, 'GLOBAL_BANK');

-- 📊 VALUTAKURSER
INSERT INTO valutakurser(
    guid, fra_valuta_guid, til_valuta_guid, dato,
    kilde, type, kurs_teller, kurs_nevner
)
VALUES
(valutakurser_guid, value_USD_guid, value_NOK_guid, CURRENT_TIMESTAMP,
'norges-bank', 'last', 1000, 100);

-- 📚 KONTOKLASSER
INSERT INTO kontoklasser(klasse_nr, navn, type, normal_saldo, beskrivelse)
VALUES
(1, 'Eiendeler', 'BALANSE', 'DEBET', 'selskapets penger og eiendom.'),
(2, 'Gjeld og Egenkapital', 'BALANSE', 'KREDIT', 'Gjeld og Egenkapital'),
(3, 'innteker', 'RESULTAT', 'KREDIT', 'innteker'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET', 'Varekostnad'),
(5, 'lønn', 'RESULTAT', 'DEBET', 'utgift og lønn'),
(6, 'Andre kostnader', 'RESULTAT', 'DEBET', 'Andre kostnader'),
(7, 'Finans', 'RESULTAT', 'DEBET', 'Finans'),
(8, 'Skatt', 'RESULTAT', 'DEBET', 'Skatt til inntekter');

-- 🏦 KONTOER
INSERT INTO kontoer(
    guid, bok_guid, overordnet_guid,
    valuta_guid, kontonummer, kontoklasse,
    gnucash_type, navn, beskrivelse,
    er_placeholder, er_skjult, mva_pliktig, mva_kode_guid
)
VALUES
-- ==========================
-- Placeholders (Main Classes)
-- ==========================
(kontoer1_guid, 'bok-001', NULL, 'val-nok', 1000, 1, 'ASSET', 'Eiendeler', 'Hovedkonto eiendeler', 1, 0, 0, NULL),
(kontoer2_guid, 'bok-001', NULL, 'val-nok', 2000, 2, 'LIABILITY', 'Gjeld og EK', 'Hovedkonto gjeld/egenkapital', 1, 0, 0, NULL),
(kontoer3_guid, 'bok-001', NULL, 'val-nok', 3000, 3, 'INCOME', 'Inntekter', 'Hovedkonto inntekter', 1, 0, 0, NULL),
(kontoer4_guid, 'bok-001', NULL, 'val-nok', 4000, 4, 'EXPENSE', 'Varekostnad', 'Hovedkonto varekostnad', 1, 0, 0, NULL),
(kontoer5_guid, 'bok-001', NULL, 'val-nok', 5000, 5, 'EXPENSE', 'Lønn', 'Hovedkonto lønn', 1, 0, 0, NULL),
(kontoer6_guid, 'bok-001', NULL, 'val-nok', 6000, 6, 'EXPENSE', 'Andre kostnader', 'Hovedkonto kostnader', 1, 0, 0, NULL),
(kontoer7_guid, 'bok-001', NULL, 'val-nok', 7000, 7, 'EXPENSE', 'Finans', 'Hovedkonto finans', 1, 0, 0, NULL),
(kontoer8_guid, 'bok-001', NULL, 'val-nok', 8000, 8, 'EXPENSE', 'Skatt', 'Hovedkonto skatt', 1, 0, 0, NULL),

-- ==========================
-- Klasse 1 – Eiendeler
-- ==========================
(kontoer9_guid,  'bok-001', kontoer1_guid, 'val-nok', 1920, 1, 'BANK', 'Bankinnskudd', 'Bankkonto', 0, 0, 0, NULL),
(kontoer10_guid, 'bok-001', kontoer1_guid, 'val-nok', 1500, 1, 'ASSET', 'Kundefordringer', 'Fordringer', 0, 0, 0, NULL),
(kontoer11_guid, 'bok-001', kontoer1_guid, 'val-nok', 1350, 1, 'ASSET', 'Aksjer', 'Investeringer', 0, 0, 0, NULL),

-- ==========================
-- Klasse 2 – Gjeld/EK
-- ==========================
(kontoer12_guid, 'bok-001', kontoer2_guid, 'val-nok', 2000, 2, 'EQUITY', 'Aksjekapital', 'Egenkapital', 0, 0, 0, NULL),
(kontoer13_guid, 'bok-001', kontoer2_guid, 'val-nok', 2400, 2, 'LIABILITY', 'Leverandørgjeld', 'Gjeld leverandører', 0, 0, 0, NULL),
(kontoer14_guid, 'bok-001', kontoer2_guid, 'val-nok', 2700, 2, 'LIABILITY', 'Utgående MVA', 'Skyldig MVA', 0, 0, 1, NULL),
(kontoer15_guid, 'bok-001', kontoer2_guid, 'val-nok', 2710, 2, 'ASSET', 'Inngående MVA', 'Til gode MVA', 0, 0, 1, NULL),

-- ==========================
-- Klasse 3 – Inntekter
-- ==========================
(kontoer16_guid, 'bok-001', kontoer3_guid, 'val-nok', 3100, 3, 'INCOME', 'Salgsinntekt', 'Salg varer', 0, 0, 1, NULL),
(kontoer17_guid, 'bok-001', kontoer3_guid, 'val-nok', 3110, 3, 'INCOME', 'Tjenester', 'Salg tjenester', 0, 0, 1, NULL),

-- ==========================
-- Klasse 5 – Lønn
-- ==========================
(kontoer18_guid, 'bok-001', kontoer5_guid, 'val-nok', 5000, 5, 'EXPENSE', 'Lønn', 'Ansatte lønn', 0, 0, 0, NULL),

-- ==========================
-- Klasse 6 – Kostnader
-- ==========================
(kontoer19_guid, 'bok-001', kontoer6_guid, 'val-nok', 6560, 6, 'EXPENSE', 'Rekvisita', 'Kontorutstyr', 0, 0, 0, NULL),

-- ==========================
-- Klasse 8 – Skatt
-- ==========================
(kontoer20_guid, 'bok-001', kontoer8_guid, 'val-nok', 8300, 8, 'EXPENSE', 'Skatt', 'Skattekostnad', 0, 0, 0, NULL);


END;
$$;