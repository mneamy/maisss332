CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    --  GUIDs الكتب والعملات
    bok_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_NOK_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_USD_guid char(32) := replace(gen_random_uuid()::text,'-','');
    valutakurser_guid char(32) := replace(gen_random_uuid()::text,'-','');

    --  GUIDs الحسابات الرئيسية
    kontoer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer60_guid char(32) := replace(gen_random_uuid()::text,'-','');
    --  GUIDs الحسابات الفرعية
    kontoer9_guid char(32) := replace(gen_random_uuid()::text,'-','');
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
    kontoer150_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer151_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer152_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5000_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5400_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3100_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6560_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8160_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- GUIDs المعاملات
    transaksjoner1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner9_guid char(32) := replace(gen_random_uuid()::text,'-','');

    --  GUIDs MVA
    mva1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva1_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva4_linjer char(32) := replace(gen_random_uuid()::text,'-','');

    --  فترة محاسبية
    regnskapsperioder1 char(32) := replace(gen_random_uuid()::text,'-','');
     regnskapsperioder2 char(32) := replace(gen_random_uuid()::text,'-','');
      regnskapsperioder3 char(32) := replace(gen_random_uuid()::text,'-','');

       regnskapsperioder4 char(32) := replace(gen_random_uuid()::text,'-','');
        regnskapsperioder5 char(32) := replace(gen_random_uuid()::text,'-','');
         regnskapsperioder6 char(32) := replace(gen_random_uuid()::text,'-',''); 
         regnskapsperioder7 char(32) := replace(gen_random_uuid()::text,'-','');

          regnskapsperioder8 char(32) := replace(gen_random_uuid()::text,'-','');
          regnskapsperioder9 char(32) := replace(gen_random_uuid()::text,'-','');
          regnskapsperioder10 char(32) := replace(gen_random_uuid()::text,'-','');
          regnskapsperioder11 char(32) := replace(gen_random_uuid()::text,'-','');

          regnskapsperioder12 char(32) := replace(gen_random_uuid()::text,'-','');


    --  GUIDs Budsjetter
    budsjetter1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    --  GUIDs Lot
    lot1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    lot2_guid char(32) := replace(gen_random_uuid()::text,'-','');

    --  GUIDs kunder
    kunder1 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder2 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder3 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder4 char(32) := replace(gen_random_uuid()::text,'-','');

    --  GUIDs fakturaer
    fakturaer1 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturaer2 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturaer3 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner1 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner2 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner3 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner4 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner5 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner6 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner7 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner8 char(32) := replace(gen_random_uuid()::text,'-','');
    
    Betalingsbetingelser1 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser2 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser3 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser4 char(32) := replace(gen_random_uuid()::text,'-','');

    leverandor1 char(32) := replace(gen_random_uuid()::text,'-','');
    leverandor2 char(32) := replace(gen_random_uuid()::text,'-','');
    leverandor3 char(32) := replace(gen_random_uuid()::text,'-','');
    leverandor4 char(32) := replace(gen_random_uuid()::text,'-','');

    fakturalinje1 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinje2 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinje3 char(32) := replace(gen_random_uuid()::text,'-','');

    P1 char(32) := replace(gen_random_uuid()::text,'-','');
    P2 char(32) := replace(gen_random_uuid()::text,'-','');
    P3 char(32) := replace(gen_random_uuid()::text,'-','');
    P4 char(32) := replace(gen_random_uuid()::text,'-','');
    P5 char(32) := replace(gen_random_uuid()::text,'-','');
    P6 char(32) := replace(gen_random_uuid()::text,'-','');
    P7 char(32) := replace(gen_random_uuid()::text,'-','');
    P8 char(32) := replace(gen_random_uuid()::text,'-','');
    P9 char(32) := replace(gen_random_uuid()::text,'-','');
    P10 char(32) := replace(gen_random_uuid()::text,'-','');
    P11 char(32) := replace(gen_random_uuid()::text,'-','');
    P12 char(32) := replace(gen_random_uuid()::text,'-','');
    P13 char(32) := replace(gen_random_uuid()::text,'-','');
    P14 char(32) := replace(gen_random_uuid()::text,'-','');
    P15 char(32) := replace(gen_random_uuid()::text,'-','');
    P16 char(32) := replace(gen_random_uuid()::text,'-','');
    P17 char(32) := replace(gen_random_uuid()::text,'-','');
    P18 char(32) := replace(gen_random_uuid()::text,'-','');
    P19 char(32) := replace(gen_random_uuid()::text,'-','');
    P20 char(32) := replace(gen_random_uuid()::text,'-','');
    P21 char(32) := replace(gen_random_uuid()::text,'-','');
BEGIN

--  Bøker
INSERT INTO bøker(guid, navn, organisasjonsnr, adresse, regnskapsaar)
VALUES (bok_guid, 'DATA1500 Konsult AS', '123456789', 'Oslo', DATE '2026-01-01');

--  Valutaer
INSERT INTO valutaer(guid, kode, navn, desimaler, hent_kurs_flag, kurs_kilde)
VALUES
(value_NOK_guid, 'NOK', 'krone', 2, 1, 'BANK'),
(value_USD_guid, 'USD', 'Dollar', 2, 0, 'GLOBAL_BANK');

--  Valutakurser
INSERT INTO valutakurser(guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner)
VALUES (valutakurser_guid, value_USD_guid, value_NOK_guid, CURRENT_TIMESTAMP, 'norges-bank', 'last', 1000, 100);

--  Kontoklasser
INSERT INTO kontoklasser(klasse_nr, navn, type, normal_saldo, beskrivelse)
VALUES
(1, 'Eiendeler', 'BALANSE', 'DEBET', 'selskapets penger og eiendom.'),
(2, 'Gjeld og Egenkapital', 'BALANSE', 'KREDIT', 'Gjeld og Egenkapital'),
(3, 'Inntekter', 'RESULTAT', 'KREDIT', 'inntekter'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET', 'Varekostnad'),
(5, 'Lønn', 'RESULTAT', 'DEBET', 'utgift og lønn'),
(6, 'Andre kostnader', 'RESULTAT', 'DEBET', 'Andre kostnader'),
(7, 'Finans', 'RESULTAT', 'DEBET', 'Finans'),
(8, 'Skatt', 'RESULTAT', 'DEBET', 'Skatt til inntekter')
ON CONFLICT (klasse_nr) DO NOTHING;
--  Kontoer
--  
INSERT INTO kontoer(guid, bok_guid, overordnet_guid, valuta_guid, kontonummer, kontoklasse, gnucash_type, navn, beskrivelse, er_placeholder, er_skjult, mva_pliktig, mva_kode_guid)
VALUES
-- 1. الأصول
(kontoer1_guid, bok_guid, NULL, value_NOK_guid, 1000, 1, 'ASSET', 'Eiendeler', 'Hovedkonto eiendeler', 1, 0, 0, NULL),
(kontoer9_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1920, 1, 'BANK', 'Bankinnskudd', 'Bankkonto', 0, 0, 0, NULL),
(kontoer10_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1500, 1, 'ASSET', 'Kundefordringer', 'Fordringer', 0, 0, 0, NULL),
(kontoer11_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1350, 1, 'ASSET', 'Aksjer', 'Investeringer', 0, 0, 0, NULL),
-- 2. الخصوم وحقوق الملكية
(kontoer2_guid, bok_guid, NULL, value_NOK_guid, 2000, 2, 'LIABILITY', 'Gjeld og EK', 'Hovedkonto gjeld/egenkapital', 1, 0, 0, NULL),
(kontoer12_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2010, 2, 'EQUITY', 'Aksjekapital', 'Egenkapital', 0, 0, 0, NULL),
(kontoer13_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2400, 2, 'LIABILITY', 'Leverandørgjeld', 'Gjeld leverandører', 0, 0, 0, NULL),
(kontoer14_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2700, 2, 'LIABILITY', 'Utgående MVA', 'Skyldig MVA', 0, 0, 1, NULL),
(kontoer15_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2710, 2, 'ASSET', 'Inngående MVA', 'Til gode MVA', 0, 0, 1, NULL),
(kontoer150_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2600, 2, 'LIABILITY', 'Forskuddstrekk', 'Skatt til forskudd', 0, 0, 0, NULL),
(kontoer151_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2780, 2, 'LIABILITY', 'Skyldig AGA', 'Arbeidsgiveravgift', 0, 0, 0, NULL),
(kontoer152_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2793, 2, 'LIABILITY', 'Oppgjørskonto MVA', 'MVA-oppgjør', 0, 0, 0, NULL),
-- 3. الإيرادات
(kontoer3100_guid, bok_guid, NULL, value_NOK_guid, 3100, 3, 'INCOME', 'Salgsinntekt', 'Inntekt fra tjenester', 0, 0, 0, NULL),
-- 4. المصاريف
(kontoer5000_guid, bok_guid, NULL, value_NOK_guid, 5000, 5, 'EXPENSE', 'Lønn til ansatte', 'Kostnader til lønn', 0, 0, 0, NULL),
(kontoer5400_guid, bok_guid, NULL, value_NOK_guid, 5400, 5, 'EXPENSE', 'Arbeidsgiveravgift', 'Kostnad arbeidsgiveravgift', 0, 0, 0, NULL),
(kontoer6560_guid, bok_guid, NULL, value_NOK_guid, 6560, 6, 'EXPENSE', 'Rekvisita', 'Kontorrekvisita', 0, 0, 0, NULL),
(kontoer60_guid, bok_guid, NULL, value_NOK_guid, 2760, 2, 'LIABILITY', 'Oppgjørskonto MVA', 'MVA-oppgjør', 0, 0, 0, NULL),
(kontoer8160_guid, bok_guid, NULL, value_NOK_guid, 8160, 8, 'EXPENSE', 'Valutatap', 'Tap ved valutakursendring', 0, 0, 0, NULL);-- تم جعل الأب NULL لتجنب خطأ الربط
--  Regnskapsperioder
INSERT INTO regnskapsperioder(guid, bok_guid, navn, fra_dato, til_dato, status)
VALUES
(regnskapsperioder1, bok_guid, 'Januar 2026', '2026-01-01', '2026-01-31', 'AAPEN'),
(regnskapsperioder2, bok_guid, 'Februar 2026', '2026-02-01', '2026-02-28', 'AAPEN'),
(regnskapsperioder3, bok_guid, 'Mars 2026', '2026-03-01', '2026-03-31', 'AAPEN'),
(regnskapsperioder4, bok_guid, 'April 2026', '2026-04-01', '2026-04-30', 'AAPEN'),
(regnskapsperioder5, bok_guid, 'Mai 2026', '2026-05-01', '2026-05-31', 'AAPEN'),
(regnskapsperioder6, bok_guid, 'Juni 2026', '2026-06-01', '2026-06-30', 'AAPEN'),
(regnskapsperioder7, bok_guid, 'Juli 2026', '2026-07-01', '2026-07-31', 'AAPEN'),
(regnskapsperioder8, bok_guid, 'August 2026', '2026-08-01', '2026-08-31', 'AAPEN'),
(regnskapsperioder9, bok_guid, 'September 2026', '2026-09-01', '2026-09-30', 'AAPEN'),
(regnskapsperioder10, bok_guid, 'Oktober 2026', '2026-10-01', '2026-10-31', 'AAPEN'),
(regnskapsperioder11, bok_guid, 'November 2026', '2026-11-01', '2026-11-30', 'AAPEN'),
(regnskapsperioder12, bok_guid, 'Desember 2026', '2026-12-01', '2026-12-31', 'AAPEN');
-- Transaksjoner
INSERT INTO transaksjoner(guid, bok_guid, valuta_guid, bilagsnummer, bilagsdato, posteringsdato, registreringsdato, beskrivelse, kilde, periode_guid)
VALUES
(transaksjoner1_guid, bok_guid, value_NOK_guid, 'T1', DATE '2026-04-01', current_timestamp, current_timestamp, 'Innskudd aksjekapital fra eier', 'manuell', regnskapsperioder4),
(transaksjoner2_guid, bok_guid, value_NOK_guid, 'T2', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøpe kontorrekvisita på kreditt', 'manuell', regnskapsperioder4),
(transaksjoner3_guid, bok_guid, value_NOK_guid, 'T3', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøp varer fra leverandør', 'manuell', regnskapsperioder4),
(transaksjoner4_guid, bok_guid, value_NOK_guid, 'T4', DATE '2026-04-01', current_timestamp, current_timestamp, 'Utbetaling lønn 2026', 'manuell', regnskapsperioder4),
(transaksjoner5_guid, bok_guid, value_NOK_guid, 'T5', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøp 10 aksjer', 'manuell', regnskapsperioder4),
(transaksjoner6_guid, bok_guid, value_NOK_guid, 'T6', DATE '2026-04-01', current_timestamp, current_timestamp, 'Salg tjenester til kunde A', 'manuell', regnskapsperioder4),
(transaksjoner7_guid, bok_guid, value_NOK_guid, 'T7', DATE '2026-04-01', current_timestamp, current_timestamp, 'Salg tjenester til kunde B', 'manuell', regnskapsperioder4),
(transaksjoner8_guid, bok_guid, value_NOK_guid, 'T8', DATE '2026-04-01', current_timestamp, current_timestamp, 'Betaling netto MVA', 'manuell', regnskapsperioder4),
(transaksjoner9_guid, bok_guid, value_NOK_guid, 'T9', DATE '2026-04-01', current_timestamp, current_timestamp, 'Prosjektfakturering med delvis betaling og valutatap', 'manuell', regnskapsperioder4);
--  MVA_koder
--  MVA_koder (التصحيح النهائي بناءً على هيكل الجدول الخاص بك)
INSERT INTO mva_koder(guid, kode, navn, type, sats_teller, sats_nevner, mva_konto_guid, aktiv)
VALUES
(mva1_guid, 'mva1', 'Utgående MVA, høy sats (25%)', 'UTGAAENDE', 25, 100, kontoer14_guid, 1),
(mva2_guid, 'mva2', 'Inngående MVA 25%', 'INNGAAENDE', 25, 100, kontoer15_guid, 1),
-- ملاحظة: يجب ربط حساب حتى لو كانت القيمة INGEN لأن العمود mva_konto_guid لا يقبل NULL في تعريفك
(mva3_guid, 'mva3', 'INGEN MVA 0%', 'INGEN', 0, 100, kontoer15_guid, 1);
--  MVA_linjer
INSERT INTO mva_linjer(guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, grunnlag_nevner, mva_belop_teller, mva_belop_nevner)
VALUES
(mva1_linjer, transaksjoner6_guid, mva1_guid, 50000, 100, 12500, 100),
(mva2_linjer, transaksjoner3_guid, mva2_guid, 800, 100, 200, 100),
(mva3_linjer, transaksjoner2_guid, mva1_guid, 1000, 100, 250, 100),
(mva4_linjer, transaksjoner8_guid, mva1_guid, 12500, 100, 12500, 100);

-- Lot
INSERT INTO Lot(guid, konto_guid, beskrivelse, er_lukket)
VALUES
(lot1_guid, kontoer11_guid, 'Kjøp 10 aksjer for investering', 0),
(lot2_guid, kontoer11_guid, 'Kjøp ekstra aksjer for portefølje', 0);

--  Budsjetter
INSERT INTO Budsjetter(guid, bok_guid, navn, beskrivelse, antall_perioder)
VALUES
(budsjetter1_guid, bok_guid, 'Årsbudsjett 2026', 'Budsjett for regnskapsåret 2026 + inntekter og utgifter', 12),
(budsjetter2_guid, bok_guid, 'Fakturering mars 2026', 'Budsjett for fakturering kunder', 12),
(budsjetter3_guid, bok_guid, 'Innbetaling kunde mars 2026', 'Budsjett for innbetalinger', 12),
(budsjetter4_guid, bok_guid, 'Lønn mars 2026', 'Budsjett for lønn og arbeidsgiveravgift', 12),
(budsjetter6_guid, bok_guid, 'Kjøp aksjer Apple', 'Budsjett for kjøp av 10 Apple-aksjer, flervaluta', 12),
(budsjetter7_guid, bok_guid, 'MVA 1. termin 2026', 'Budsjett for innbetaling MVA til staten', 12),
(budsjetter8_guid, bok_guid, 'Fakturering internasjonal prosjekt mars 2026', 'Budsjett for fakturering internasjonal kunde og valutakurstap', 12),
(budsjetter9_guid, bok_guid, 'Årsbudsjett 2026', 'Budsjett for oppstart av selskapet', 12);

-- Budsjettlinjer
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter1_guid, kontoer9_guid, 3, 20 000 000, 100),
(budsjetter1_guid, kontoer12_guid, 3, -20000000, 100),

(budsjetter1_guid, kontoer6560_guid, 3, 350000, 100),
(budsjetter1_guid, kontoer15_guid, 3, 87500, 100),
(budsjetter1_guid, kontoer13_guid, 3, -437500, 100),

(budsjetter2_guid, kontoer10_guid, 3, 6250000, 100),
(budsjetter2_guid, kontoer3100_guid, 3, -5000000, 100),
(budsjetter2_guid, kontoer14_guid, 3, -1250000, 100),



(budsjetter3_guid, kontoer9_guid, 3, 6250000, 100),
(budsjetter3_guid, kontoer10_guid, 3, -6250000, 100),


(budsjetter4_guid, kontoer5000_guid, 3, 4500000, 100),
(budsjetter4_guid, kontoer9_guid, 3, -3300000, 100),
(budsjetter4_guid, kontoer150_guid, 3, -1200000, 100),
(budsjetter4_guid, kontoer5400_guid, 3, 634500, 100),
(budsjetter4_guid, kontoer151_guid, 3, -634500, 100),


(budsjetter6_guid, kontoer11_guid, 3, 1837500, 100),
(budsjetter6_guid, kontoer9_guid, 3, -1837500, 100),


(budsjetter7_guid, kontoer14_guid, 3, 1250000, 100),
(budsjetter7_guid, kontoer15_guid, 3, -87500, 100),
(budsjetter7_guid, kontoer9_guid, 3, -1162500, 100),





(budsjetter8_guid, kontoer10_guid, 3, 5100000, 100),
(budsjetter8_guid, kontoer3100_guid, 3, -5100000, 100),


(budsjetter8_guid, kontoer9_guid, 3, 4900000, 100),

(budsjetter8_guid, kontoer8160_guid, 3, 200000, 100),
(budsjetter8_guid, kontoer10_guid, 3, -5100000, 100);

-- Planlagte_Transaksjoner
INSERT INTO Planlagte_Transaksjoner(guid, bok_guid, navn, aktiv, startdato, sluttdato, gjentakelse_type, gjentakelse_mult, auto_opprett, sist_opprettet)
VALUES
(Planlagte_Transaksjoner1, bok_guid, 'Innskudd aksjekapital fra eier', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner2, bok_guid, 'Kjøpe kontorrekvisita på kreditt', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner3, bok_guid, 'Kjøپ varer fra leverandør', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner4, bok_guid, 'Utbetaling lønn 2026', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner5, bok_guid, 'Kjøp 10 aksjer', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner6, bok_guid, 'Salg tjenester til kunde A', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner7, bok_guid, 'Betaling netto MVA', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),
(Planlagte_Transaksjoner8, bok_guid, 'Prosjektfakturering med delvis betaling og valutatap', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL);

-- Betalingsbetingelser
INSERT INTO Betalingsbetingelser(guid, navn, type, forfallsdager, kontantrabatt_dager, rabatt_teller, rabatt_nevner)
VALUES
(Betalingsbetingelser1, '30 dager netto', 'DAGER', 30, 0, 0, 100),
(Betalingsbetingelser2, '14 dager med 2% rabatt', 'DAGER', 14, 14, 2, 100),
(Betalingsbetingelser3, 'Proximo slutten av måneden', 'PROXIMO', 30, 0, 0, 100),
(Betalingsbetingelser4, '10 dager med 5% rabatt', 'DAGER', 10, 10, 5, 100);

-- Kunder
INSERT INTO kunder(guid, bok_guid, kundenummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, mva_kode_guid, aktiv)
VALUES
(kunder1, bok_guid, 'K001', 'Kunde AS', '987654321', 'Oslo, Norge', 'kontakt@kunde.no', value_NOK_guid, Betalingsbetingelser1, mva2_guid, 1),
(kunder2, bok_guid, 'K002', 'Global AB', '55667788', 'Stockholm, Sweden', 'info@global.se', value_USD_guid, Betalingsbetingelser1, mva3_guid, 1),
(kunder3, bok_guid, 'K003', 'Svensk Kunde AB', '11223344', 'Göteborg, Sweden', 'faktura@svensk.se', value_USD_guid, Betalingsbetingelser2, mva3_guid, 1);

INSERT INTO Leverandører(
    guid,
    bok_guid,
    leverandornummer,
    navn,
    organisasjonsnr,
    adresse,
    epost,
    valuta_guid,
    betalingsbetingelse_guid,
    aktiv
)
VALUES
(leverandor1, bok_guid, 'L001', 'Office Supplies AS', '12345678', 'Oslo, Norway', 'kontakt@office.no', value_NOK_guid, Betalingsbetingelser1, 1),
(leverandor2, bok_guid, 'L002', 'Grossist Varer AS', '87654321', 'Bergen, Norway', 'faktura@grossist.no', value_NOK_guid, Betalingsbetingelser2, 1),
(leverandor3, bok_guid, 'L003', 'Apple Inc.', '00000000', '1 Apple Park Way, Cupertino, CA, USA', 'invest@apple.com', value_USD_guid, Betalingsbetingelser1, 1),
(leverandor4, bok_guid, 'L004', 'Global Consulting AB', '55667788', 'Stockholm, Sweden', 'kontakt@globalconsulting.se', value_USD_guid, Betalingsbetingelser2, 1);
INSERT INTO Fakturaer (
    guid,
    bok_guid,
    fakturanummer,
    type,
    kunde_guid,
    leverandor_guid,
    valuta_guid,
    fakturadato,
    forfallsdato,
    posteringsdato,
    status,
    betalingsbetingelse_guid,
    transaksjon_guid
)
VALUES
-- فاتورة بيع
(fakturaer1, bok_guid, 'FN1', 'SALG', kunder1, leverandor1, value_NOK_guid, '2026-03-15', '2026-04-14', NOW(), 'BETALT', Betalingsbetingelser1, transaksjoner6_guid),

-- فاتورة شراء
(fakturaer2, bok_guid, 'FN2', 'KJOP', kunder2, leverandor2, value_USD_guid, '2026-03-20', '2026-04-19', NOW(), 'UTKAST', Betalingsbetingelser2, transaksjoner5_guid),

-- فاتورة مشروع  
(fakturaer3, bok_guid, 'FN3', 'SALG', kunder3, leverandor3, value_NOK_guid, '2026-03-25', '2026-04-24', NOW(), 'SENDT', Betalingsbetingelser2, transaksjoner9_guid);



-- Fakturalinjer
INSERT INTO fakturalinjer(guid, faktura_guid, beskrivelse, antall_teller, antall_nevner, enhetspris_teller, enhetspris_nevner, inntekt_konto_guid,
 kostnad_konto_guid, mva_kode_guid, mva_inkludert, rabatt_teller, rabatt_nevner)
VALUES
(fakturalinje1, fakturaer1, 'Konsulenttjenester mars', 1, 1, 50000, 1, kontoer3100_guid, kontoer6560_guid, mva2_guid, 0, 0, 100),
(fakturalinje2, fakturaer2, 'Kjøp 10 Apple-aksjer', 10, 1, 1837, 1, kontoer11_guid, kontoer60_guid, mva3_guid, 0, 0, 100),
(fakturalinje3, fakturaer3, 'Prosjektarbeid mars', 1, 1, 51000, 1, kontoer3100_guid, kontoer5000_guid, mva3_guid, 0, 0, 100);



-- Posteringer مصححة بالكامل مع الإشارات المحاسبية (مدين/دائن)
INSERT INTO Posteringer (
    guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, tekst, handling,
    avstemmingsstatus, avstemmingsdato, antall_teller, antall_nevner, lot_guid
)
VALUES
-- Transaksjon 1: Innskudd aksjekapital (Bank مدين، Aksjekapital دائن)
(P1, transaksjoner1_guid, kontoer9_guid, 20000000, 100, 'Innskudd aksjekapital fra eier', 'Innskudd', 'n', NULL, 0, 1, NULL),
(P2, transaksjoner1_guid, kontoer12_guid, -20000000, 100, 'Aksjekapital fra eier', 'Innskudd', 'n', NULL, 0, 1, NULL),

-- Transaksjon 2: Rekvisita + MVA + Gjeld (المصاريف والضريبة مدين، المورد دائن)
(P3, transaksjoner2_guid, kontoer6560_guid, 350000, 100, 'Rekvisita', 'Kjøp', 'n', NULL, 0, 1, NULL),
(P4, transaksjoner2_guid, kontoer15_guid, 87500, 100, 'MVA', 'Kjøp', 'n', NULL, 0, 1, NULL),
(P5, transaksjoner2_guid, kontoer13_guid, -437500, 100, 'Gjeld', 'Kjøp', 'n', NULL, 0, 1, NULL),

-- Transaksjon 3: Lønn (المصروف مدين، البنك دائن)
(P6, transaksjoner3_guid, kontoer5000_guid, 5100000, 100, 'Lønn mars', 'Lønn', 'n', NULL, 0, 1, NULL),
(P7, transaksjoner3_guid, kontoer9_guid, -5100000, 100, 'Utbetaling lønn', 'Lønn', 'n', NULL, 0, 1, NULL),

-- Transaksjon 4: Kjøp aksjer (الأصول مدين، المورد دائن)
(P8, transaksjoner4_guid, kontoer11_guid, 18370, 100, 'Kjøp 10 Apple-aksjer', 'Kjøp', 'n', NULL, 10, 1, NULL),
(P9, transaksjoner4_guid, kontoer13_guid, -18370, 100, 'Betaling til leverandør', 'Kjøp', 'n', NULL, 0, 1, NULL),

-- Transaksjon 5: Kjøp tjenester (المصروف والضريبة مدين، المورد دائن)
(P10, transaksjoner5_guid, kontoer6560_guid, 100000, 100, 'Kjøp tjenester leverandør', 'Kjøp', 'n', NULL, 0, 1, NULL),
(P11, transaksjoner5_guid, kontoer14_guid, 25000, 100, 'MVA', 'Kjøp', 'n', NULL, 0, 1, NULL),
(P12, transaksjoner5_guid, kontoer13_guid, -125000, 100, 'Leverandørgjeld', 'Kjøp', 'n', NULL, 0, 1, NULL),

-- Transaksjon 6: Fakturert kunde (العميل مدين، الإيراد والضريبة دائن)
(P13, transaksjoner6_guid, kontoer10_guid, 6250000, 100, 'Fakturert Kunde AB', 'Salg', 'n', NULL, 0, 1, NULL),
(P14, transaksjoner6_guid, kontoer3100_guid, -5000000, 100, 'Salgskonto', 'Salg', 'n', NULL, 0, 1, NULL),
(P15, transaksjoner6_guid, kontoer14_guid, -1250000, 100, 'Utgående MVA', 'Salg', 'n', NULL, 0, 1, NULL),

-- Transaksjon 7: Bankinnbetaling kunde (البنك مدين، العميل دائن لنقص الأصول)
(P16, transaksjoner7_guid, kontoer9_guid, 6250000, 100, 'Bankinnbetaling Kunde AB', 'Innbetaling', 'n', NULL, 0, 1, NULL),
(P17, transaksjoner7_guid, kontoer10_guid, -6250000, 100, 'Reduksjon kundefordringer', 'Innbetaling', 'n', NULL, 0, 1, NULL),

-- Transaksjon 8: Betaling leverandør (المورد مدين لنقص الالتزام، البنك دائن)
(P18, transaksjoner8_guid, kontoer13_guid, 125000, 100, 'Betaling leverandør', 'Betaling', 'n', NULL, 0, 1, NULL),
(P19, transaksjoner8_guid, kontoer9_guid, -125000, 100, 'Bankutbetaling', 'Betaling', 'n', NULL, 0, 1, NULL),

-- Transaksjon 9: Strøm og telefon (المصروف مدين، البنك دائن)
(P20, transaksjoner9_guid, kontoer6560_guid, 200000, 100, 'Strøm og telefon', 'Kostnad', 'n', NULL, 0, 1, NULL),
(P21, transaksjoner9_guid, kontoer9_guid, -200000, 100, 'Bankbetaling', 'Kostnad', 'n', NULL, 0, 1, NULL);
END;
$$;









-- TRUNCATE TABLE 
--     posteringer, 
--     transaksjoner, 
--     mva_linjer, 
--     fakturalinjer, 
--     fakturaer, 
--     kunder, 
--     leverandører, 
--     kontoer, 
--     regnskapsperioder, 
--     valutakurser, 
--     valutaer, 
--     bøker,
--     kontoklasser,
--     betalingsbetingelser,
--     budsjetter,
--     budsjettlinjer,
--     lot,
--     mva_koder,
--     planlagte_transaksjoner
-- RESTART IDENTITY CASCADE;