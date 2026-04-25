CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    bok_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_NOK_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_USD_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_SEK_guid char(32) := replace(gen_random_uuid()::text,'-','');
    valutakurser1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    valutakurser_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- الحسابات الرئيسية
    kontoer_rot_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- الحسابات الفرعية
    kontoer9_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer10_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer11_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer12_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer13_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer14_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer15_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer150_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer151_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer152_guid char(32) := replace(gen_random_uuid()::text,'-','');
    
    -- حسابات إضافية تم استخدامها في الكود
    kontoer5000_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5400_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3100_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6560_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8160_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer60_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- المعاملات
    transaksjoner1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner9_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner10_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- القيود (Posteringer)
    posteringer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer9_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer10_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer11_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer12_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer13_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer14_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer15_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer16_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer17_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer18_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer19_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer20_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer21_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer22_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer23_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer24_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer25_guid char(32) := replace(gen_random_uuid()::text,'-','');
    posteringer26_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- regnskapsperioder_guid 
p1_guid char(32) := replace(gen_random_uuid()::text,'-',''); 
p2_guid char(32) := replace(gen_random_uuid()::text,'-','');  
p3_guid char(32) := replace(gen_random_uuid()::text,'-',''); 
p4_guid char(32) := replace(gen_random_uuid()::text,'-','');  
p5_guid char(32) := replace(gen_random_uuid()::text,'-',''); 
p6_guid char(32) := replace(gen_random_uuid()::text,'-','');  
p7_guid char(32) := replace(gen_random_uuid()::text,'-',''); 
p8_guid char(32) := replace(gen_random_uuid()::text,'-','');  
p9_guid char(32) := replace(gen_random_uuid()::text,'-',''); 
p10_guid char(32) := replace(gen_random_uuid()::text,'-','');  
p11_guid char(32) := replace(gen_random_uuid()::text,'-',''); 
p12_guid char(32) := replace(gen_random_uuid()::text,'-','');  


    mva1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_guid char(32) := replace(gen_random_uuid()::text,'-','');

    mva1_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva4_linjer char(32) := replace(gen_random_uuid()::text,'-','');

    lot_guid1 char(32) := replace(gen_random_uuid()::text,'-','');
     lot_guid2 char(32) := replace(gen_random_uuid()::text,'-','');

    budsjetter1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    planlagte_transaksjoner1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    planlagte_transaksjoner8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    betalingsbetingelser1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    betalingsbetingelser2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    betalingsbetingelser3_guid char(32) := replace(gen_random_uuid()::text,'-','');

    kunder_guid1 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder_guid2 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder_guid3 char(32) := replace(gen_random_uuid()::text,'-','');

    leverandører1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    leverandører2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    leverandører3_guid char(32) := replace(gen_random_uuid()::text,'-','');

    fakturaer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    fakturaer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    fakturaer3_guid char(32) := replace(gen_random_uuid()::text,'-','');

    fakturalinjer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinjer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinjer3_guid char(32) := replace(gen_random_uuid()::text,'-','');

BEGIN

--  BØKER
INSERT INTO bøker(guid, navn, organisasjonsnr, adresse, regnskapsaar)
VALUES (bok_guid, 'DATA1500 Konsult AS', '123456789', 'Oslo', DATE '2026-01-01');

--  VALUTAER
INSERT INTO valutaer(guid, kode, navn, desimaler, hent_kurs_flag, kurs_kilde)
VALUES
(value_NOK_guid, 'NOK', 'Krone', 2, 1, 'BANK'),
(value_SEK_guid, 'SEK', 'Krone', 2, 1, 'BANK_SWEDEN'),
(value_USD_guid, 'USD', 'Dollar', 2, 0, 'GLOBAL_BANK');

--  VALUTAKURSER
INSERT INTO valutakurser(guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner)
VALUES
(valutakurser1_guid, value_SEK_guid, value_NOK_guid, CURRENT_TIMESTAMP, 'SWEDEN-bank', 'last', 102, 100),
(valutakurser_guid, value_USD_guid, value_NOK_guid, CURRENT_TIMESTAMP, 'norges-bank', 'last', 1000, 100);

--  KONTOKLASSER
INSERT INTO kontoklasser(klasse_nr, navn, type, normal_saldo, beskrivelse)
VALUES
(1, 'Eiendeler', 'BALANSE', 'DEBET', 'Selskapets penger og eiendom.'),--
(2, 'Gjeld og Egenkapital', 'BALANSE', 'KREDIT', 'Gjeld og Egenkapital'),--
(3, 'Inntekter', 'RESULTAT', 'KREDIT', 'Inntekter'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET', 'Varekostnad'),
(5, 'Lønn', 'RESULTAT', 'DEBET', 'Utgift og lønn'),
(6, 'Andre kostnader', 'RESULTAT', 'DEBET', 'Andre kostnader'),
(7, 'Finans', 'RESULTAT', 'DEBET', 'Finans'),
(8, 'Skatt', 'RESULTAT', 'DEBET', 'Skatt til inntekter');

-- KONTOER: إدخال جميع الحسابات المطلوبة للقيود والميزانية
INSERT INTO kontoer(guid, bok_guid, overordnet_guid, valuta_guid, kontonummer, kontoklasse, gnucash_type, navn, beskrivelse, er_placeholder, er_skjult, mva_pliktig)
VALUES
-- الجذر والفئات
(kontoer_rot_guid, bok_guid, NULL, value_NOK_guid, 9999, 1, 'ROOT', 'Rotkonto', 'Root', 1, 0, 0),-- حساب الجذر
(kontoer1_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 1000, 1, 'ASSET', 'Eiendeler', 'Assets', 1, 0, 0),--أصول 
(kontoer2_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 2000, 2, 'LIABILITY', 'Gjeld', 'Liabilities', 1, 0, 0),--الإلتزامات والمستحقات 
(kontoer3_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 3000, 3, 'INCOME', 'Inntekter', 'Income', 1, 0, 0),-- دخل
(kontoer8_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 8000, 8, 'EXPENSE', 'Finans', 'Financial', 1, 0, 0),-- حساب مالي

-- الحسابات الفرعية (تأكد من وجود كل الـ GUIDs المستخدمة في القيود هنا)
(kontoer9_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1920, 1, 'BANK', 'Bankinnskudd', 'Bank', 0, 0, 0),--ايداع بنكي
(kontoer10_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1500, 1, 'ASSET', 'Kundefordringer', 'Receivables', 0, 0, 0),-- حسابات القبض
(kontoer11_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1350, 1, 'ASSET', 'Aksjer', 'Stocks', 0, 0, 0),-- الوصف: الاستثمارات والأسهم

(kontoer12_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2080, 2, 'EQUITY', 'Aksjekapital', 'Equity', 0, 0, 0),-- الوصف: رأس المال وحقوق المساهمين
(kontoer13_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2400, 2, 'LIABILITY', 'Leverandørgjeld', 'Payables', 0, 0, 0),-- الوصف: الديون المستحقة للموردين
(kontoer14_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2700, 2, 'LIABILITY', 'Utgående MVA', 'VAT Out', 0, 0, 1),--ضريبة  مخرجات دائن 
(kontoer15_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2710, 2, 'ASSET', 'Inngående MVA', 'VAT In', 0, 0, 1),--ضريبة  مخرجات مدين 
(kontoer150_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2600, 2, 'LIABILITY', 'Forskuddstrekk', 'Tax', 0, 0, 0),--ضريبة الاستقطاع، ضريبة الاستقطاع
(kontoer151_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2780, 2, 'LIABILITY', 'Skyldig AGA', 'Employer Tax', 0, 0, 0),--ضريبة تأمينات اجتماعية/مساهمات صاحب العمل
(kontoer152_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2740, 2, 'LIABILITY', 'Oppgjørskonto MVA', 'VAT Settle', 0, 0, 0),
(kontoer3100_guid, bok_guid, kontoer3_guid, value_NOK_guid, 3100, 3, 'INCOME', 'Salgsinntekt', 'Sales', 0, 0, 0),--مبيعات
(kontoer5000_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 5000, 5, 'EXPENSE', 'Lønn', 'Salary', 0, 0, 0),--رواتب
(kontoer5400_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 5400, 5, 'EXPENSE', 'AGA Kostnad', 'Employer Tax Exp', 0, 0, 0),--هو "ضريبة حصة صاحب العمل
(kontoer6560_guid, bok_guid, kontoer_rot_guid, value_NOK_guid, 6560, 6, 'EXPENSE', 'Rekvisita', 'Supplies', 0, 0, 0),--'لوازم مكتبية'،
(kontoer8160_guid, bok_guid, kontoer8_guid, value_NOK_guid, 8160, 8, 'EXPENSE', 'Valutatap', 'FX Loss', 0, 0, 0),--"خسارة صرف العملات الأجنبية"
(kontoer60_guid, bok_guid, kontoer11_guid, value_NOK_guid, 1520, 1, 'ASSET', 'Kjøp aksjer', 'Stock purchase interim', 0, 0, 0);--شراء الاسهم
-- ربط الروت بالكتاب
UPDATE bøker SET rot_konto_guid = kontoer_rot_guid WHERE guid = bok_guid;
--  Regnskapsperioder
UPDATE bøker SET rot_konto_guid = kontoer1_guid WHERE guid = bok_guid;

-- INSERT INTO regnskapsperioder(guid, bok_guid, navn, fra_dato, til_dato, status)
-- VALUES (regnskapsperioder_guid, bok_guid, 'Mars 2026', DATE '2026-03-01', DATE '2026-03-31', 'AAPEN');

-- --  Transaksjoner
INSERT INTO transaksjoner(guid, bok_guid, valuta_guid, bilagsnummer, bilagsdato, posteringsdato, registreringsdato, beskrivelse, kilde, periode_guid)
VALUES
(transaksjoner1_guid, bok_guid, value_NOK_guid, 'T1', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Innskudd aksjekapital fra eier', 'manuell', regnskapsperioder_guid),
(transaksjoner2_guid, bok_guid, value_NOK_guid, 'T2', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Kjøpe kontorrekvisita på kreditt', 'manuell', regnskapsperioder_guid),
(transaksjoner3_guid, bok_guid, value_NOK_guid, 'T3', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Kjøp varer fra leverandør', 'manuell', regnskapsperioder_guid),
(transaksjoner4_guid, bok_guid, value_NOK_guid, 'T4', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Utbetaling lønn 2026', 'manuell', regnskapsperioder_guid),
(transaksjoner5_guid, bok_guid, value_NOK_guid, 'T5', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Kjøp 10 aksjer', 'manuell', regnskapsperioder_guid),
(transaksjoner6_guid, bok_guid, value_NOK_guid, 'T6', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Salg tjenester til kunde A', 'manuell', regnskapsperioder_guid),
(transaksjoner7_guid, bok_guid, value_NOK_guid, 'T7', '2026-05-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Betaling fra kunde A', 'manuell', regnskapsperioder_guid),
(transaksjoner8_guid, bok_guid, value_NOK_guid, 'T8', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Betaling netto MVA', 'manuell', regnskapsperioder_guid),
(transaksjoner9_guid, bok_guid, value_NOK_guid, 'T9', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Prosjektfakturering', 'manuell', regnskapsperioder_guid),
(transaksjoner10_guid, bok_guid, value_NOK_guid, 'T10', '2026-06-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Betaling faktura med valutatap', 'manuell', regnskapsperioder_guid);



INSERT INTO regnskapsperioder(guid, bok_guid, navn, fra_dato, til_dato, status) VALUES
(p1_guid, bok_guid, 'Januar 2026',  '2026-01-01', '2026-01-31', 'LUKKET'),
(p2_guid, bok_guid, 'Februar 2026', '2026-02-01', '2026-02-28', 'LUKKET'),
(p3_guid, bok_guid, 'Mars 2026',    '2026-03-01', '2026-03-31', 'LUKKET'),
(p4_guid, bok_guid, 'April 2026',   '2026-04-01', '2026-04-30', 'AAPEN'),
(p5_guid, bok_guid, 'Mai 2026',     '2026-05-01', '2026-05-31', 'AAPEN'),
(p6_guid, bok_guid, 'Juni 2026',    '2026-06-01', '2026-06-30', 'AAPEN'),
(p7_guid, bok_guid, 'Juli 2026',    '2026-07-01', '2026-07-31', 'AAPEN'),
(p8_guid, bok_guid, 'August 2026',  '2026-08-01', '2026-08-31', 'AAPEN'),
(p9_guid, bok_guid, 'September 2026', '2026-09-01', '2026-09-30', 'AAPEN'),
(p10_guid, bok_guid, 'Oktober 2026',  '2026-10-01', '2026-10-31', 'AAPEN'),
(p11_guid, bok_guid, 'November 2026', '2026-11-01', '2026-11-30', 'AAPEN'),
(p12_guid, bok_guid, 'Desember 2026', '2026-12-01', '2026-12-31', 'AAPEN');

INSERT INTO transaksjoner(guid, bok_guid, valuta_guid, bilagsnummer, bilagsdato, posteringsdato, registreringsdato, beskrivelse, kilde, periode_guid) VALUES
-- عمليات شهر أبريل (p4_guid)
(transaksjoner1_guid, bok_guid, value_NOK_guid, 'T1', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Innskudd aksjekapital fra eier', 'manuell', p4_guid),
(transaksjoner2_guid, bok_guid, value_NOK_guid, 'T2', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Kjøpe kontorrekvisita på kreditt', 'manuell', p4_guid),
(transaksjoner3_guid, bok_guid, value_NOK_guid, 'T3', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Kjøp varer fra leverandør', 'manuell', p4_guid),
(transaksjoner4_guid, bok_guid, value_NOK_guid, 'T4', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Utbetaling lønn 2026', 'manuell', p4_guid),
(transaksjoner5_guid, bok_guid, value_NOK_guid, 'T5', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Kjøp 10 aksjer', 'manuell', p4_guid),
(transaksjoner6_guid, bok_guid, value_NOK_guid, 'T6', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Salg tjenester til kunde A', 'manuell', p4_guid),
(transaksjoner8_guid, bok_guid, value_NOK_guid, 'T8', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Betaling netto MVA', 'manuell', p4_guid),
(transaksjoner9_guid, bok_guid, value_NOK_guid, 'T9', '2026-04-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Prosjektfakturering', 'manuell', p4_guid),


(transaksjoner7_guid, bok_guid, value_NOK_guid, 'T7', '2026-05-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Betaling fra kunde A', 'manuell', p5_guid),


(transaksjoner10_guid, bok_guid, value_NOK_guid, 'T10', '2026-06-01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Betaling faktura med valutatap', 'manuell', p6_guid);
























--  MVA KODER
INSERT INTO mva_koder(guid, kode, navn, type, sats_teller, sats_nevner, mva_konto_guid, aktiv)
VALUES
(mva1_guid, 'MVA1', 'Utgående MVA, høy sats (25%)', 'UTGAAENDE', 25, 100, kontoer14_guid, 1),
(mva2_guid, 'MVA2', 'Inngående MVA 25%', 'INNGAAENDE', 25, 100, kontoer15_guid, 1),
(mva3_guid, 'MVA3', 'INGEN MVA 0%', 'INGEN', 0, 100, kontoer14_guid, 1);

-- MVA LINJER
INSERT INTO mva_linjer(guid, transaksjon_guid, mva_kode_guid, grunnlag_teller, grunnlag_nevner, mva_belop_teller, mva_belop_nevner)
VALUES
(mva1_linjer, transaksjoner2_guid, mva1_guid, 1000, 100, 250, 100),
(mva2_linjer, transaksjoner3_guid, mva2_guid, 800, 100, 200, 100),
(mva3_linjer, transaksjoner6_guid, mva1_guid, 50000, 100, 12500, 100),
(mva4_linjer, transaksjoner8_guid, mva1_guid, 12500, 100, 12500, 100);

--  LOT
insert into lot(guid,konto_guid,beskrivelse,er_lukket)values
(
lot_guid1,kontoer11_guid,'kjøpe ti aksjer',0
),
(
lot_guid2,kontoer11_guid,'kjøpe aksjer ekstra',1
);



INSERT INTO Budsjetter(guid, bok_guid, navn, beskrivelse, antall_perioder)
VALUES
-- ميزانية 2026
(budsjetter1_guid, bok_guid, 'Årsbudsjett 2026', 'Budsjett for regnskapsåret 2026 + inntekter og utgifter', 12),
-- ميزانية الفواتير
(budsjetter2_guid, bok_guid, 'Fakturering mars 2026', 'Budsjett for fakturering kunder', 12),
-- ميزانية المدفوعات
(budsjetter3_guid, bok_guid, 'Innbetaling kunde mars 2026', 'Budsjett for innbetalinger', 12),
-- ميزانية الرواتب
(budsjetter4_guid, bok_guid, 'Lønn mars 2026', 'Budsjett for lønn og arbeidsgiveravgift', 12),
-- ميزانية الاسهم
(budsjetter6_guid, bok_guid, 'Kjøp aksjer Apple', 'Budsjett for kjøp av 10 Apple-aksjer, flervaluta', 12),
-- ميزانية الضرائب
(budsjetter7_guid, bok_guid, 'MVA 1. termin 2026', 'Budsjett for innbetaling MVA til staten', 12),
-- ميزانية الخسائر
(budsjetter8_guid, bok_guid, 'Fakturering internasjonal prosjekt mars 2026', 'Budsjett for fakturering internasjonal kunde og valutakurstap', 12);

--  BUDSJETTER
-- 📈 INSERT INTO budsjettlinjer




INSERT INTO budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
-- ميزانية 1: العمليات العامة (Årsbudsjett 2026)
(budsjetter1_guid, kontoer9_guid, 3, 20000000, 100),
(budsjetter1_guid, kontoer10_guid, 3, -20000000, 100),
(budsjetter1_guid, kontoer6560_guid, 3, 350000, 100),
(budsjetter1_guid, kontoer15_guid, 3, 87500, 100),
(budsjetter1_guid, kontoer10_guid, 3, 437500, 100),

-- ميزانية 2: فواتير المبيعات (Fakturering mars 2026)
(budsjetter2_guid, kontoer9_guid, 3, 6250000, 100),
(budsjetter2_guid, kontoer3100_guid, 3, -5000000, 100),
(budsjetter2_guid, kontoer14_guid, 3, -1250000, 100),

-- ميزانية 3: تحصيلات العملاء (Innbetaling kunde)
(budsjetter3_guid, kontoer9_guid, 3, 6250000, 100),
(budsjetter3_guid, kontoer10_guid, 3, -6250000, 100),

-- ميزانية 4: الرواتب والأجور (Lønn mars 2026)
(budsjetter4_guid, kontoer5000_guid, 3, 4500000, 100),
(budsjetter4_guid, kontoer9_guid, 3, -3300000, 100),
(budsjetter4_guid, kontoer150_guid, 3, -1200000, 100),
(budsjetter4_guid, kontoer151_guid, 3, -634500, 100),
(budsjetter4_guid, kontoer5400_guid, 3, 634500, 100),

-- ميزانية 6: شراء الأسهم (Kjøp aksjer Apple)
(budsjetter6_guid, kontoer9_guid, 3, -1837500, 100),
(budsjetter6_guid, kontoer11_guid, 3, 1837500, 100),

-- ميزانية 7: تسوية ضريبة القيمة المضافة (MVA 1. termin 2026)
(budsjetter7_guid, kontoer9_guid, 3, -1162500, 100),
(budsjetter7_guid, kontoer15_guid, 3, -87500, 100),
(budsjetter7_guid, kontoer14_guid, 3, 1250000, 100),

-- ميزانية 8: المشاريع الدولية (Fakturering internasjonal)
(budsjetter8_guid, kontoer3100_guid, 3, -5100000, 100),
(budsjetter8_guid, kontoer10_guid, 3, 5100000, 100),
(budsjetter8_guid, kontoer9_guid, 3, 4900000, 100),
(budsjetter8_guid, kontoer10_guid, 3, -5100000, 100),
(budsjetter8_guid, kontoer8160_guid, 3, 200000, 100);




-- PLANLAGTE TRANSAKSJONER
insert into planlagte_transaksjoner(guid,bok_guid,navn,aktiv,startdato,sluttdato,gjentakelse_type,gjentakelse_mult,auto_opprett,sist_opprettet) values
(planlagte_transaksjoner1_guid, bok_guid, 'Innskudd aksjekapital fra eier', 1, '2026-03-01', '2026-12-01', 'AAR', 1, 1, '2026-12-01'),
(planlagte_transaksjoner2_guid, bok_guid, 'Kjøpe kontorrekvisita på kreditt', 1, '2026-03-01', null, 'MAANED', 1, 1, null),
(planlagte_transaksjoner3_guid, bok_guid, 'Kjøp varer fra leverandør', 1, '2026-03-01', null, 'MAANED', 1, 1, null),
(planlagte_transaksjoner4_guid, bok_guid, 'Utbetaling lønn 2026', 1, '2026-03-01', null, 'MAANED', 1, 1, null),
(planlagte_transaksjoner6_guid, bok_guid, 'Salg tjenester til kunde A', 1, '2026-03-01', null, 'MAANED', 1, 1, null),
(planlagte_transaksjoner7_guid, bok_guid, 'Betaling netto MVA', 1, '2026-03-01', null, 'MAANED', 1, 1, null),
(planlagte_transaksjoner8_guid, bok_guid, 'Prosjektfakturering مع delvis betaling og valutatap', 1, '2026-03-01', null, 'MAANED', 1, 1, null),
(planlagte_transaksjoner5_guid, bok_guid, 'Kjøp 10 aksjer', 1, '2026-03-01', null, 'MAANED', 1, 1, null);
--  BETALINGSBETINGELSER
INSERT INTO betalingsbetingelser(guid, navn, type, forfallsdager, kontantrabatt_dager, rabatt_teller, rabatt_nevner)
VALUES
(betalingsbetingelser1_guid, 'Netto 30 dager', 'DAGER', 30, 0, 0, 100),
(betalingsbetingelser2_guid, '14 dager, 2% rabatt', 'DAGER', 14, 14, 2, 100),
(betalingsbetingelser3_guid, 'Proximo 30 dager', 'PROXIMO', 30, 0, 0, 100);

insert into kunder
(
   guid, bok_guid,kundenummer,navn,organisasjonsnr,adresse,
   epost,valuta_guid,betalingsbetingelse_guid,mva_kode_guid,
   aktiv
)values
(
    kunder_guid1,bok_guid,'p01','mais','BYD','OSLO','m@gmail.com',value_NOK_guid,
    betalingsbetingelser1_guid,mva2_guid,1
),
(
    kunder_guid2,bok_guid,'p02','Yassin','BMW','newyork','y@gmail.com',value_USD_guid,
    betalingsbetingelser2_guid,mva2_guid,1
),
(
    kunder_guid3,bok_guid,'p03','Ole','BMW','newyork','o@gmail.com',value_SEK_guid,
    betalingsbetingelser3_guid,mva2_guid,1
);


insert into leverandører(guid,bok_guid,leverandornummer,navn,organisasjonsnr,adresse,
epost,valuta_guid,betalingsbetingelse_guid,aktiv)values
(leverandører1_guid,bok_guid,'wp1','DH','edx','norge','b@gmail.com',value_NOK_guid,
betalingsbetingelser1_guid,1),
(leverandører2_guid,bok_guid,'wp2','DHl','edx','USA','b@gmail.com',value_USD_guid,
betalingsbetingelser2_guid,1),
(leverandører3_guid,bok_guid,'wp4','DHl','edx','USA','b@gmail.com',value_SEK_guid,
betalingsbetingelser3_guid,1);

--  FAKTURAER
insert into fakturaer (
    guid, bok_guid, fakturanummer, type,
    kunde_guid, leverandor_guid, valuta_guid, 
    fakturadato, forfallsdato, posteringsdato, 
    status, betalingsbetingelse_guid, transaksjon_guid
) values
-- الربط مع المعاملة رقم 6 (Salg tjenester)
(
    fakturaer1_guid, bok_guid, 'f1', 'SALG',
    kunder_guid3, leverandører1_guid, value_NOK_guid,
    '2026-02-01', '2026-06-01', now(), 
    'BETALT', betalingsbetingelser3_guid, transaksjoner6_guid -- تأكد من حرف الـ r هنا
),
-- الربط مع المعاملة رقم 5 (Kjøp 10 aksjer)
(
    fakturaer2_guid, bok_guid, 'f2', 'KJOP',
    kunder_guid2, leverandører2_guid, value_USD_guid,
    '2026-02-01', '2026-06-01', now(), 
    'UTKAST', betalingsbetingelser1_guid, transaksjoner5_guid -- تأكد من حرف الـ r هنا
),
-- الربط مع المعاملة رقم 9 (Prosjektfakturering)
(
    fakturaer3_guid, bok_guid, 'f3', 'SALG',
    kunder_guid1, leverandører3_guid, value_USD_guid,
    '2026-02-01', '2026-06-01', now(), 
    'SENDT', betalingsbetingelser2_guid, transaksjoner9_guid -- تأكد من حرف الـ r هنا
);

insert into fakturalinjer(guid,faktura_guid,beskrivelse,antall_teller,
antall_nevner,enhetspris_teller,enhetspris_nevner,inntekt_konto_guid,
kostnad_konto_guid,mva_kode_guid,mva_inkludert,rabatt_teller,rabatt_nevner
)values
(fakturalinjer1_guid,fakturaer1_guid,'Konsulenttjenester mars',1,1,50000,1,kontoer3100_guid,
kontoer6560_guid,mva3_guid,0,0,100
),
(fakturalinjer2_guid,fakturaer2_guid,'Kontorrekvisita',1,1,30000,1,kontoer3100_guid,
kontoer6560_guid,mva3_guid,0,0,100
),
(fakturalinjer3_guid,fakturaer3_guid,'projectkrav',1,1,20000,1,kontoer3100_guid,
kontoer6560_guid,mva3_guid,0,0,100
);

insert into posteringer(guid,transaksjon_guid,konto_guid,tekst,handling
,avstemmingsstatus,avstemmingsdato,belop_teller,belop_nevner,antall_teller,
antall_nevner,lot_guid)values
(posteringer1_guid,transaksjoner1_guid,kontoer9_guid,'Innskudd aksjekapital fra eier','Innskudd','n',null,20000000,100,0,1,null),
(posteringer2_guid,transaksjoner1_guid,kontoer12_guid,' aksjekapital fra eier','Innskudd','n',null,-20000000,100,0,1,null),
--S2
(posteringer3_guid,transaksjoner2_guid,kontoer6560_guid,' Kjøpe kontorrekvisita på kreditt','kjøpe','n',null,350000,100,0,1,null),
(posteringer4_guid,transaksjoner2_guid,kontoer15_guid,' Kjøpe kontorrekvisita på kreditt','kjøpe','n',null,87500,100,0,1,null),
(posteringer5_guid,transaksjoner2_guid,kontoer13_guid,' Kjøpe kontorrekvisita på kreditt','kjøpe','n',null,-437500,100,0,1,null),
--S3
(posteringer6_guid,transaksjoner6_guid,kontoer10_guid,'Salg tjenester til kunde A','salg','n',null,6250000,100,0,1,null),
(posteringer7_guid,transaksjoner6_guid,kontoer3100_guid,'Salg til kunde A','salg','n',null,-5000000 ,100,0,1,null),
(posteringer8_guid,transaksjoner6_guid,kontoer14_guid,'Salg til kunde A','Utgående MVA','n',null,-1250000 ,100,0,1,null),
--S4
(posteringer9_guid,transaksjoner7_guid,kontoer9_guid,'betale til bank A','Innskudd','n',null,6250000 ,100,0,1,null),
(posteringer10_guid,transaksjoner7_guid,kontoer10_guid,'betale av kunde A','Innskudd','n',null,-6250000 ,100,0,1,null),
--S5
--S5 (قيد الرواتب الموزون والصحيح محاسبياً)
(posteringer11_guid, transaksjoner4_guid, kontoer5000_guid, 'Bruttolønn', 'lønn', 'n', null, 4500000, 100, 0, 1, null),
(posteringer12_guid, transaksjoner4_guid, kontoer9_guid, 'utbetaling lønn', 'lønn', 'n', null, -3300000, 100, 0, 1, null),
-- تصحيح: الضريبة المقتطعة تذهب لحساب الالتزام 2600 (المتغير 150)
(posteringer13_guid, transaksjoner4_guid, kontoer150_guid, 'Forskuddstrekk', 'lønn', 'n', null, -1200000, 100, 0, 1, null),
-- تصحيح: تكلفة ضريبة صاحب العمل تذهب لحساب المصروف 5400 (المتغير 5400)
(posteringer14_guid, transaksjoner4_guid, kontoer5400_guid, 'arbeidsgiveravgift', 'lønn', 'n', null, 634500, 100, 0, 1, null),
(posteringer15_guid, transaksjoner4_guid, kontoer151_guid, 'Skyldig arbeidsgiveravgift', 'lønn', 'n', null, -634500, 100, 0, 1, null),
--S6
(posteringer16_guid,transaksjoner5_guid,kontoer60_guid,'Kjøp 10 -aksje','kjope','n',null,1837500 ,100,0,1,null),
(posteringer17_guid,transaksjoner5_guid,kontoer9_guid,'betale for 10 -aksje','kjope','n',null,-1837500 ,100,0,1,null),
--S7
(posteringer18_guid,transaksjoner8_guid,kontoer14_guid,'Utgående MVA, høy sats','mva','n',null,1250000 ,100,0,1,null),
(posteringer19_guid,transaksjoner8_guid,kontoer15_guid,'Inngående MVA','mva','n',null,-87500 ,100,0,1,null),
(posteringer20_guid,transaksjoner8_guid,kontoer152_guid,'Oppgjørskonto','mva','n',null,-1162500 ,100,0,1,null),
(posteringer21_guid, transaksjoner8_guid, kontoer9_guid, 'innskudd bank', 'mva', 'n', null, -1162500, 100, 0, 1, null),
--s8


-- S8 الجزء A: إصدار الفاتورة
(posteringer22_guid, transaksjoner9_guid, kontoer10_guid, 'Kundefordring svensk kunde', 'salg', 'n', null, 5100000, 100, 0, 1, null),
(posteringer23_guid, transaksjoner9_guid, kontoer3100_guid, 'Salgsinntekter prosjekt Sverige', 'salg', 'n', null, -5100000, 100, 0, 1, null),



-- S8 الجزء B: التحصيل + خسارة عملة
(posteringer24_guid, transaksjoner10_guid, kontoer9_guid, 'Innbetaling fra svensk kunde', 'innbetaling', 'n', null, 4900000, 100, 0, 1, null),
(posteringer25_guid, transaksjoner10_guid, kontoer8160_guid, 'Valutatap SEK', 'valuta', 'n', null, 200000, 100, 0, 1, null),
(posteringer26_guid, transaksjoner10_guid, kontoer10_guid, 'Oppgjør kundefordring SEK', 'innbetaling', 'n', null, -5100000, 100, 0, 1, null);

END;
$$;