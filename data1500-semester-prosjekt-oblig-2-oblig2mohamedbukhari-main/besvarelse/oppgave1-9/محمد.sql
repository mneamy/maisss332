
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
    kontoer150_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer151_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer152_guid char(32) := replace(gen_random_uuid()::text,'-','');



     Transaksjoner1_guid char(32) := replace(gen_random_uuid()::text,'-','');
     Transaksjoner2_guid char(32) := replace(gen_random_uuid()::text,'-','');
     Transaksjoner3_guid char(32) := replace(gen_random_uuid()::text,'-','');
     Transaksjoner4_guid char(32) := replace(gen_random_uuid()::text,'-','');
     Transaksjoner5_guid char(32) := replace(gen_random_uuid()::text,'-','');


    Posteringer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer3_guid char(32) := replace(gen_random_uuid()::       text,'-','');
    Posteringer4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer6_guid char(32) := replace(gen_random_uuid   ()::text,'-','');
    Posteringer7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer8_guid char(32) := replace(gen_random_uuid()::   text,'-','');
    Posteringer9_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer10_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer11_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer12_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer13_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer14_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer15_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer16_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer17_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer18_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer19_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer20_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer21_guid char(32) := replace(gen_random_uuid()::text,'-','');

    Posteringer21_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer22_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer23_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer24_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Posteringer25_guid char(32) := replace(gen_random_uuid()::text,'-','');        



     periode_guid char(32) := replace(gen_random_uuid()::text,'-','');

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
-- ==========================
-- Klasse 1 – Eiendeler (Assets)
-- ==========================
(kontoer1_guid, bok_guid, NULL, value_NOK_guid, 1000, 1, 'ASSET', 'Eiendeler', 'Hovedkonto eiendeler', 1, 0, 0, NULL),
-- نوع الحساب: Asset (أصل)
-- الضريبة: لا ينطبق
-- الوصف: الحساب الرئيسي للأصول (المال والممتلكات)

(kontoer9_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1920, 1, 'BANK', 'Bankinnskudd', 'Bankkonto', 0, 0, 0, NULL),
-- نوع الحساب: Bank (أصل)
-- الضريبة: لا ينطبق
-- الوصف: حساب البنك الفعلي للشركة

(kontoer10_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1500, 1, 'ASSET', 'Kundefordringer', 'Fordringer', 0, 0, 0, NULL),
-- نوع الحساب: Asset (أصل)
-- الضريبة: لا ينطبق
-- الوصف: الذمم المدينة من العملاء

(kontoer11_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1350, 1, 'ASSET', 'Aksjer', 'Investeringer', 0, 0, 0, NULL),
-- نوع الحساب: Asset (أصل)
-- الضريبة: لا ينطبق
-- الوصف: الاستثمارات والأسهم

-- ==========================
-- Klasse 2 – Gjeld/Egenkapital (Liabilities & Equity)
-- ==========================
(kontoer2_guid, bok_guid, NULL, value_NOK_guid, 2000, 2, 'LIABILITY', 'Gjeld og EK', 'Hovedkonto gjeld/egenkapital', 1, 0, 0, NULL),
-- نوع الحساب: Liability (التزامات)
-- الضريبة: لا ينطبق
-- الوصف: الحساب الرئيسي للالتزامات وحقوق الملكية

(kontoer12_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2000, 2, 'EQUITY', 'Aksjekapital', 'Egenkapital', 0, 0, 0, NULL),
-- نوع الحساب: Equity (حقوق الملكية)
-- الضريبة: لا ينطبق
-- الوصف: رأس المال وحقوق المساهمين

(kontoer13_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2400, 2, 'LIABILITY', 'Leverandørgjeld', 'Gjeld leverandører', 0, 0, 0, NULL),
-- نوع الحساب: Liability (التزامات)
-- الضريبة: لا ينطبق
-- الوصف: الديون المستحقة للموردين

(kontoer14_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2700, 2, 'LIABILITY', 'Utgående MVA', 'Skyldig MVA', 0, 0, 1, NULL),
-- نوع الحساب: Liability (التزام)
-- الضريبة: ضريبة القيمة المضافة (MVA) على المبيعات
-- الوصف: الضريبة المستحقة على الحكومة عند إصدار الفواتير للعملاء

(kontoer15_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2710, 2, 'ASSET', 'Inngående MVA', 'Til gode MVA', 0, 0, 1, NULL),
-- نوع الحساب: Asset (أصل)
-- الضريبة: ضريبة القيمة المضافة على المشتريات
-- الوصف: الضريبة المدفوعة على المشتريات من الموردين، يمكن خصمها من Utgående MVA

(kontoer150_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2600, 2, 'LIABILITY', 'Forskuddstrekk', 'Skatt til forskudd', 0, 0, 0, NULL),
-- نوع الحساب: Liability (التزام)
-- الضريبة: ضريبة الدخل (Forskuddstrekk)
-- الوصف: خصم الضرائب مقدمًا على الموظفين

(kontoer151_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2780, 2, 'LIABILITY', 'Skyldig AGA', 'Arbeidsgiveravgift', 0, 0, 0, NULL),
-- نوع الحساب: Liability (التزام)
-- الضريبة: ضريبة تأمينات اجتماعية/مساهمات صاحب العمل
-- الوصف: المبالغ المستحقة لصاحب العمل للحكومة

(kontoer152_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2740, 2, 'LIABILITY', 'Oppgjørskonto MVA', 'MVA-oppgjør', 0, 0, 0, NULL),
-- نوع الحساب: Liability (التزام)
-- الضريبة: ضريبة القيمة المضافة (تسوية)
-- الوصف: الحساب الوسيط لتسوية المدفوعات/المستحقات بين Utgående و Inngående MVA

-- ==========================
-- Klasse 3 – Inntekter (Income)
-- ==========================
(kontoer3_guid, bok_guid, NULL, value_NOK_guid, 3000, 3, 'INCOME', 'Inntekter', 'Hovedkonto inntekter', 1, 0, 0, NULL),
-- نوع الحساب: Income (إيراد)
-- الضريبة: لا ينطبق
-- الوصف: الحساب الرئيسي للإيرادات

(kontoer16_guid, bok_guid, kontoer3_guid, value_NOK_guid, 3100, 3, 'INCOME', 'Salgsinntekt', 'Salg varer', 0, 0, 1, NULL),
-- نوع الحساب: Income (إيراد)
-- الضريبة: ضريبة القيمة المضافة على المبيعات (Utgående MVA)
-- الوصف: إيرادات بيع المنتجات قبل الضريبة

(kontoer17_guid, bok_guid, kontoer3_guid, value_NOK_guid, 3110, 3, 'INCOME', 'Tjenester', 'Salg tjenester', 0, 0, 1, NULL),
-- نوع الحساب: Income (إيراد)
-- الضريبة: ضريبة القيمة المضافة على الخدمات (Utgående MVA)
-- الوصف: إيرادات بيع الخدمات، مثال: خدمة 2000 NOK → ضريبة 25٪ → 500 NOK على Utgående MVA

-- ==========================
-- Klasse 4 – Varekostnad (Cost of Goods Sold)
-- ==========================
(kontoer4_guid, bok_guid, NULL, value_NOK_guid, 4000, 4, 'EXPENSE', 'Varekostnad', 'Hovedkonto varekostnad', 1, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: لا ينطبق
-- الوصف: تكلفة السلع المباعة

-- ==========================
-- Klasse 5 – Lønn (Salary)
-- ==========================
(kontoer5_guid, bok_guid, NULL, value_NOK_guid, 5000, 5, 'EXPENSE', 'Lønn', 'Hovedkonto lønn', 1, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: لا ينطبق
-- الوصف: الحساب الرئيسي للرواتب

(kontoer18_guid, bok_guid, kontoer5_guid, value_NOK_guid, 5000, 5, 'EXPENSE', 'Lønn', 'Ansatte lønn', 0, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: لا ينطبق
-- الوصف: رواتب الموظفين الفعلية

-- ==========================
-- Klasse 6 – Andre kostnader (Other Expenses)
-- ==========================
(kontoer6_guid, bok_guid, NULL, value_NOK_guid, 6000, 6, 'EXPENSE', 'Andre kostnader', 'Hovedkonto kostnader', 1, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: لا ينطبق
-- الوصف: الحساب الرئيسي للمصاريف الأخرى

(kontoer19_guid, bok_guid, kontoer6_guid, value_NOK_guid, 6560, 6, 'EXPENSE', 'Rekvisita', 'Kontorutstyr', 0, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: لا ينطبق
-- الوصف: مصاريف مكتبية وقرطاسية

-- ==========================
-- Klasse 7 – Finans (Financial)
-- ==========================
(kontoer7_guid, bok_guid, NULL, value_NOK_guid, 7000, 7, 'EXPENSE', 'Finans', 'Hovedkonto finans', 1, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: لا ينطبق
-- الوصف: المصاريف المالية، فوائد وغيرها

-- ==========================
-- Klasse 8 – Skatt (Tax)
-- ==========================
(kontoer8_guid, bok_guid, NULL, value_NOK_guid, 8000, 8, 'EXPENSE', 'Skatt', 'Hovedkonto skatt', 1, 0, 0, NULL),
-- نوع الحساب: Expense (مصروف)
-- الضريبة: ضريبة الدخل الفعلي (Skatt)
-- الوصف: الحساب الرئيسي للضرائب

(kontoer20_guid, bok_guid, kontoer8_guid, value_NOK_guid, 8300, 8, 'EXPENSE', 'Skatt', 'Skattekostnad', 0, 0, 0, NULL);
-- نوع الحساب: Expense (مصروف)
-- الضريبة: ضريبة الدخل الفعلي (Skatt)
-- الوصف: مصروف الضريبة المحسوب للسنة
-- nummer	Navn	   MVA-pliktig      	ملاحظات
-- 2700  	Utgående MVA	1	 ضريبة المبيعات (Kredit عند الفواتير)
-- 2710	  Inngående MVA	    1	 ضريبة الشراء (Debet عند الفواتير)
-- 3100  	Salgsinntekt  	1	 إيرادات خاضعة لضريبة المبيعات
-- 3110	   Tjenester	        1	 إيرادات خدمات خاضعة لضريبة المبيعات
-------
UPDATE bøker
SET rot_konto_guid = kontoer1_guid
WHERE guid = bok_guid;


-- الفترات الحسابية
INSERT INTO Regnskapsperioder(
        guid, bok_guid, navn, fra_dato, til_dato, status
    )
    VALUES (
        periode_guid,
        bok_guid, 
        'Januar 2026',
        DATE '2026-03-01',
        DATE '2026-03-31',
        'AAPEN'
    );




-- إدخالات تجريبية لـ Transaksjoner
INSERT INTO Transaksjoner(
    guid, bok_guid, valuta_guid, bilagsnummer, bilagsdato, beskrivelse, periode_guid
)
VALUES
-- معاملة 1: بيع منتجات
(Transaksjoner1_guid, bok_guid, value_NOK_guid, 'B001', DATE '2026-01-10', 'Salg av varer til kunde A', periode_guid),

-- معاملة 2: شراء سلع
(Transaksjoner2_guid, bok_guid, value_NOK_guid, 'B002', DATE '2026-01-12', 'Kjøp av varer fra leverandør', periode_guid),

-- معاملة 3: دفع رواتب
(Transaksjoner3_guid, bok_guid, value_NOK_guid, 'B003', DATE '2026-01-15', 'Lønn til ansatte', periode_guid),

-- معاملة 4: دفع ضرائب
(Transaksjoner4_guid, bok_guid, value_NOK_guid, 'B004', DATE '2026-01-18', 'Betaling av skatt', periode_guid),

-- معاملة 5: بيع خدمات
(Transaksjoner5_guid, bok_guid, value_NOK_guid, 'B005', DATE '2026-01-20', 'Salg av tjenester til kunde B', periode_guid);








-- 1️⃣ سيناريو 1: بيع منتجات → Kundefordringer (مدين) + Salgsinntekt + Utgående MVA (دائن)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer1_guid, Transaksjoner1_guid, kontoer10_guid, 'Salg varer til kunde A', 'Salg', 'n', NULL, 1250, 100, 0, 1, NULL),
(Posteringer2_guid, Transaksjoner1_guid, kontoer16_guid, 'Salg varer til kunde A', 'Salg', 'n', NULL, -1000, 100, 0, 1, NULL),
(Posteringer3_guid, Transaksjoner1_guid, kontoer14_guid, 'Salg varer til kunde A', 'Salg', 'n', NULL, -250, 100, 0, 1, NULL);


-- 2️⃣ سيناريو 2: شراء البضائع → Leverandørgjeld (دائن) + Varekostnad + Inngående MVA (مدين)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer4_guid, Transaksjoner2_guid, kontoer13_guid, 'Kjøp varer fra leverandør', 'Kjøp', 'n', NULL, -1000, 100, 0, 1, NULL),
(Posteringer5_guid, Transaksjoner2_guid, kontoer4_guid, 'Kjøp varer fra leverandør', 'Kjøp', 'n', NULL, 800, 100, 0, 1, NULL),
(Posteringer6_guid, Transaksjoner2_guid, kontoer15_guid, 'Kjøp varer fra leverandør', 'Kjøp', 'n', NULL, 200, 100, 0, 1, NULL);


-- 3️⃣ سيناريو 5: دفع الرواتب → Lønn (مدين) + Skattetrekk + Arbeidsgiveravgift (دائن)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer7_guid, Transaksjoner3_guid, kontoer18_guid, 'Utbetaling lønn', 'Lønn', 'n', NULL, 5000, 100, 0, 1, NULL),
(Posteringer8_guid, Transaksjoner3_guid, kontoer150_guid, 'Skattetrekk', 'Lønn', 'n', NULL, -1000, 100, 0, 1, NULL),
(Posteringer9_guid, Transaksjoner3_guid, kontoer151_guid, 'Arbeidsgiveravgift', 'Lønn', 'n', NULL, -500, 100, 0, 1, NULL);


-- 4️⃣ سيناريو 4: دفع الضرائب → Skattekostnad (مدين) + Bank (دائن)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer10_guid, Transaksjoner4_guid, kontoer20_guid, 'Betaling av skatt', 'Skatt', 'n', NULL, 2000, 100, 0, 1, NULL),
(Posteringer11_guid, Transaksjoner4_guid, kontoer9_guid, 'Betaling av skatt', 'Skatt', 'n', NULL, -2000, 100, 0, 1, NULL);


-- 5️⃣ سيناريو 3: بيع الخدمات → Kundefordringer (مدين) + Tjenester + Utgående MVA (دائن)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer12_guid, Transaksjoner5_guid, kontoer10_guid, 'Salg tjenester til kunde B', 'Salg', 'n', NULL, 1250, 100, 0, 1, NULL),
(Posteringer13_guid, Transaksjoner5_guid, kontoer17_guid, 'Salg tjenester til kunde B', 'Salg', 'n', NULL, -1000, 100, 0, 1, NULL),
(Posteringer14_guid, Transaksjoner5_guid, kontoer14_guid, 'Salg tjenester til kunde B', 'Salg', 'n', NULL, -250, 100, 0, 1, NULL);


-- 6️⃣ سيناريو 6: شراء أوراق مالية خارجية (فلورفالتا) → Aksjer (مدين) + Bank (دائن)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer15_guid, Transaksjoner6_guid, kontoer1350_guid, 'Kjøp 10 AAPL-aksjer', 'Investering', 'n', NULL, 18375, 100, 10, 1, LotAAPL_guid), -- Aksjer (debet)
(Posteringer16_guid, Transaksjoner6_guid, kontoer1920_guid, 'Kjøp 10 AAPL-aksjer', 'Investering', 'n', NULL, -18375, 100, 0, 1, NULL); -- Bank (kredit)


-- 7️⃣ سيناريو 7: دفع MVA إلى الدولة → Utgående MVA + Inngående MVA (مدين) + Bank (دائن)
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
(Posteringer17_guid, Transaksjoner7_guid, kontoer2700_guid, 'Betaling netto MVA', 'MVA', 'n', NULL, 12500, 100, 0, 1, NULL), -- Utgående MVA (debet)
(Posteringer18_guid, Transaksjoner7_guid, kontoer2710_guid, 'Betaling netto MVA', 'MVA', 'n', NULL, -875, 100, 0, 1, NULL), -- Inngående MVA (kredit)
(Posteringer19_guid, Transaksjoner7_guid, kontoer2740_guid, 'Betaling netto MVA', 'MVA', 'n', NULL, -11625, 100, 0, 1, NULL),
(Posteringer20_guid, Transaksjoner7_guid, kontoer1920_guid, 'Betaling netto MVA', 'MVA', 'n', NULL, -11625, 100, 0, 1, NULL); -- Bank (kredit)


-- 8️⃣ سيناريو 8: مشروع فواتير مع دفع جزئي وخسارة عملة → Kundefordringer + Bank + Valutatap
INSERT INTO Posteringer(
    guid, transaksjon_guid, konto_guid, tekst, handling,
    avstemmingsstatus, avstemmingsdato, belop_teller, belop_nevner,
    antall_teller, antall_nevner, lot_guid
)
VALUES
-- Fakturering: 50 000 SEK → 51 000 NOK
(Posteringer21_guid, Transaksjoner8_guid, kontoer1500_guid, 'Fakturering Göteborg Tech AB', 'Salg', 'n', NULL, 51000, 100, 0, 1, NULL),
(Posteringer22_guid, Transaksjoner8_guid, kontoer3100_guid, 'Fakturering Göteborg Tech AB', 'Salg', 'n', NULL, -51000, 100, 0, 1, NULL),

-- Innbetaling med kursfall: 49 000 NOK → Valutatap 2 000 NOK
(Posteringer23_guid, Transaksjoner8_guid, kontoer1920_guid, 'Innbetaling Göteborg Tech AB', 'Salg', 'n', NULL, 49000, 100, 0, 1, NULL), -- Bank (debet)
(Posteringer24_guid, Transaksjoner8_guid, kontoer8160_guid, 'Valutatap Göteborg Tech AB', 'Salg', 'n', NULL, 2000, 100, 0, 1, NULL), -- Valutatap (debet)
(Posteringer25_guid, Transaksjoner8_guid, kontoer1500_guid, 'Innbetaling Göteborg Tech AB', 'Salg', 'n', NULL, -51000, 100, 0, 1, NULL); -- Kundefordringer (kredit)




END;
$$;
.









--------------
--------------
محمد جديد
--------------
--------------

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    -- 📘 الكتب والعملات والفترات
    bok_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_NOK_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_USD_guid char(32) := replace(gen_random_uuid()::text,'-','');
    valutakurser_guid char(32) := replace(gen_random_uuid()::text,'-','');
    regnskapsperioder_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 🏦 الحسابات الرئيسية
    kontoer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 🏦 الحسابات الفرعية (تأكد من شمول كافة الأرقام المستخدمة)
    kontoer9_guid char(32) := replace(gen_random_uuid()::text,'-','');  -- 1920
    kontoer10_guid char(32) := replace(gen_random_uuid()::text,'-',''); -- 1500
    kontoer11_guid char(32) := replace(gen_random_uuid()::text,'-',''); -- 1350
    kontoer12_guid char(32) := replace(gen_random_uuid()::text,'-',''); -- 2000
    kontoer13_guid char(32) := replace(gen_random_uuid()::text,'-',''); -- 2400
    kontoer14_guid char(32) := replace(gen_random_uuid()::text,'-',''); -- 2700
    kontoer15_guid char(32) := replace(gen_random_uuid()::text,'-',''); -- 2710
    kontoer150_guid char(32) := replace(gen_random_uuid()::text,'-','');-- 2600
    kontoer151_guid char(32) := replace(gen_random_uuid()::text,'-','');-- 2780
    kontoer5000_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5400_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3100_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6560_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6570_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8160_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer60_guid char(32) := replace(gen_random_uuid()::text,'-','');
    -- 💳 المعاملات (Transactions)
    transaksjoner1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner9_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 📄 MVA
    mva1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva1_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva4_linjer char(32) := replace(gen_random_uuid()::text,'-','');

    -- 💰 الميزانية والخطط
    budsjetter1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner1 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner2 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner3 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner4 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner5 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner6 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner7 char(32) := replace(gen_random_uuid()::text,'-','');
    Planlagte_Transaksjoner8 char(32) := replace(gen_random_uuid()::text,'-','');

    -- 👤 العملاء والموردين وشروط الدفع
    kunder1 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder2 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder3 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder4 char(32) := replace(gen_random_uuid()::text,'-','');
    leverandor1 char(32) := replace(gen_random_uuid()::text,'-','');
    leverandor2 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser1 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser2 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser3 char(32) := replace(gen_random_uuid()::text,'-','');
    Betalingsbetingelser4 char(32) := replace(gen_random_uuid()::text,'-','');

    -- 📑 الفواتير والقيود (Posteringer)
    fakturaer1 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturaer2 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturaer3 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinje1 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinje2 char(32) := replace(gen_random_uuid()::text,'-','');
    fakturalinje3 char(32) := replace(gen_random_uuid()::text,'-','');
    lot1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    lot2_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 🔑 تعريف متغيرات القيود P1, P2... لضمان عمل جمل الـ INSERT
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

-- 📘 Bøker
INSERT INTO bøker(guid, navn, organisasjonsnr, adresse, regnskapsaar)
VALUES
(bok_guid, 'DATA1500 Konsult AS', '123456789', 'Oslo', DATE '2026-01-01');

-- 💱 Valutaer
INSERT INTO valutaer(guid, kode, navn, desimaler, hent_kurs_flag, kurs_kilde)
VALUES
(value_NOK_guid, 'NOK', 'krone', 2, 1, 'BANK'),
(value_USD_guid, 'USD', 'Dollar', 2, 0, 'GLOBAL_BANK');

-- 📊 Valutakurser
INSERT INTO valutakurser(
    guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner
)
VALUES
(valutakurser_guid, value_USD_guid, value_NOK_guid, CURRENT_TIMESTAMP, 'norges-bank', 'last', 1000, 100);

-- 📊 Kontoklasser
INSERT INTO kontoklasser(klasse_nr, navn, type, normal_saldo, beskrivelse)
VALUES
(1, 'Eiendeler', 'BALANSE', 'DEBET', 'selskapets penger og eiendom.'),
(2, 'Gjeld og Egenkapital', 'BALANSE', 'KREDIT', 'Gjeld og Egenkapital'),
(3, 'Inntekter', 'RESULTAT', 'KREDIT', 'inntekter'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET', 'Varekostnad'),
(5, 'Lønn', 'RESULTAT', 'DEBET', 'utgift og lønn'),
(6, 'Andre kostnader', 'RESULTAT', 'DEBET', 'Andre kostnader'),
(7, 'Finans', 'RESULTAT', 'DEBET', 'Finans'),
(8, 'Skatt', 'RESULTAT', 'DEBET', 'Skatt til inntekter');

-- 🏦 Kontoer (تم تصحيح جميع الروابط)
INSERT INTO kontoer(guid, bok_guid, overordnet_guid, valuta_guid, kontonummer, kontoklasse, gnucash_type, navn, beskrivelse, er_placeholder, er_skjult, mva_pliktig, mva_kode_guid)
VALUES
-- Eiendeler
(kontoer1_guid, bok_guid, NULL, value_NOK_guid, 1000, 1, 'ASSET', 'Eiendeler', 'Hovedkonto eiendeler', 1, 0, 0, NULL),
(kontoer9_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1920, 1, 'BANK', 'Bankinnskudd', 'Bankkonto', 0, 0, 0, NULL),--إيداع بنكي
(kontoer10_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1500, 1, 'ASSET', 'Kundefordringer', 'Fordringer', 0, 0, 0, NULL),--الأصول، حسابات القبض، المستحقاذت  - الذمم المالية
(kontoer11_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1350, 1, 'ASSET', 'Aksjer', 'Investeringer', 0, 0, 0, NULL),--الأصول، الأسهم، الاستثمارات
-- Gjeld/Egenkapital
(kontoer2_guid, bok_guid, NULL, value_NOK_guid, 2000, 2, 'LIABILITY', 'Gjeld og EK', 'Hovedkonto gjeld/egenkapital', 1, 0, 0, NULL),
(kontoer12_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2080, 2, 'EQUITY', 'Aksjekapital', 'Egenkapital', 0, 0, 0, NULL),--Aksjekapital (حقوق الملكية)
(kontoer13_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2400, 2, 'LIABILITY', 'Leverandørgjeld', 'Gjeld leverandører', 0, 0, 0, NULL),--الديون المستحقة للموردين (كريديت عند الفواتير)
(kontoer14_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2700, 2, 'LIABILITY', 'Utgående MVA', 'Skyldig MVA', 0, 0, 1, NULL),--ضريبة  مخرجات دائن 
(kontoer15_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2710, 2, 'ASSET', 'Inngående MVA', 'Til gode MVA', 0, 0, 1, NULL),--ضريبة الشراء (مدين)
(kontoer150_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2600, 2, 'LIABILITY', 'Forskuddstrekk', 'Skatt til forskudd', 0, 0, 0, NULL),--ضريبة الاستقطاع، ضريبة الاستقطاع
(kontoer151_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2780, 2, 'LIABILITY', 'Skyldig AGA', 'Arbeidsgiveravgift', 0, 0, 0, NULL),--ضريبة تأمينات اجتماعية/مساهمات صاحب العمل
(kontoer152_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2740, 2, 'LIABILITY', 'Oppgjørskonto MVA', 'MVA-oppgjør', 0, 0, 0, NULL),
(kontoer5000_guid, bok_guid,NULL, value_NOK_guid,5000, 5, 'EXPENSE','Lønn til ansatte',  'Kostnader til lønn',  0,  0, 0,   NULL  ),--حساب Lønn / الرواتب

(kontoer5400_guid, bok_guid, NULL, value_NOK_guid, 5400, 5, 'EXPENSE', 'Arbeidsgiveravgift', 'Kostnad arbeidsgiveravgift', 0, 0, 0, NULL);-- إنشاء حساب المصروف للعملية

(kontoer3100_guid, bok_guid, NULL, value_NOK_guid, 3100, 3, 'INCOME', 'Salgsinntekt', 'Inntekt fra tjenester', 0, 0, 0, NULL);--مبيعات
(kontoer6560_guid, bok_guid, NULL, value_NOK_guid, 6560, 6, 'EXPENSE', 'Rekvisita', 'Kontorrekvisita', 0, 0, 0, NULL)--'لوازم مكتبية'،
(kontoer8160_guid, bok_guid, kontoer8_guid, value_NOK_guid, 8160, 8, 'EXPENSE', 'Valutatap', 'Tap ved valutakursendring', 0, 0, 0, NULL);--"خسارة صرف العملات الأجنبية"
 (kontoer60_guid, bok_guid, kontoer11_guid, value_NOK_guid, 1520, 5, 'EXPENSE', 'Kjøp aksjer', 'Kostnad ved kjøp av aksjer', 0, 0, 0, NULL);--تكاليف شراء الاسهم

-- 📅 Regnskapsperioder
INSERT INTO regnskapsperioder(guid,bok_guid,navn,fra_dato,til_dato,status)
VALUES(regnskapsperioder_guid, bok_guid, 'Mars 1', DATE '2026-03-01', DATE '2026-03-31','AAPEN');

-- 💳 Transaksjoner
INSERT INTO transaksjoner(guid,bok_guid,valuta_guid,bilagsnummer,bilagsdato,posteringsdato,registreringsdato,beskrivelse,kilde,periode_guid)
VALUES
(transaksjoner1_guid, bok_guid, value_NOK_guid, 'T1', DATE '2026-04-01', current_timestamp, current_timestamp, 'Innskudd aksjekapital fra eier','manuell', regnskapsperioder_guid),--إيداع رأس المال من المالك
(transaksjoner2_guid, bok_guid, value_NOK_guid, 'T2', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøpe kontorrekvisita på kreditt','manuell', regnskapsperioder_guid),--شراء اللوازم المكتبية بالتقسيط
(transaksjoner3_guid, bok_guid, value_NOK_guid, 'T3', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøp varer fra leverandør','manuell', regnskapsperioder_guid),--، "اشترِ البضائع من المورد"
(transaksjoner4_guid, bok_guid, value_NOK_guid, 'T4', DATE '2026-04-01', current_timestamp, current_timestamp, 'Utbetaling lønn 2026','manuell', regnskapsperioder_guid),--دفع الرواتب
(transaksjoner5_guid, bok_guid, value_NOK_guid, 'T5', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøp 10 aksjer','manuell', regnskapsperioder_guid),
(transaksjoner6_guid, bok_guid, value_NOK_guid, 'T6', DATE '2026-04-01', current_timestamp, current_timestamp, 'Salg tjenester til kunde A','manuell', regnskapsperioder_guid),--"بيع الخدمات للعميل أ"
(transaksjoner7_guid, bok_guid, value_NOK_guid, 'T7', DATE '2026-04-01', current_timestamp, current_timestamp, 'Salg tjenester til kunde B','manuell', regnskapsperioder_guid),--"بيع الخدمات للعميل أ"
(transaksjoner8_guid, bok_guid, value_NOK_guid, 'T8', DATE '2026-04-01', current_timestamp, current_timestamp, 'Betaling netto MVA','manuell', regnskapsperioder_guid),--السعر بعد خصم ضريبة القيمة المضافة
(transaksjoner9_guid, bok_guid, value_NOK_guid, 'T9', DATE '2026-04-01', current_timestamp, current_timestamp, 'Prosjektfakturering med delvis betaling og valutatap','manuell', regnskapsperioder_guid);--"إصدار فواتير المشاريع مع دفع جزئي وخسارة في العملة"

-- 📄 MVA_koder (تم تصحيح الـ Type ليتوافق مع قيود الجدول)
-- 📄 MVA_koder (التصحيح النهائي بناءً على هيكل الجدول الخاص بك)
INSERT INTO mva_koder(guid, kode, navn, type, sats_teller, sats_nevner, mva_konto_guid, aktiv)
VALUES
(mva1_guid, 'mva1', 'Utgående MVA, høy sats (25%)', 'UTGAAENDE', 25, 100, kontoer14_guid, 1),
(mva2_guid, 'mva2', 'Inngående MVA 25%', 'INNGAAENDE', 25, 100, kontoer15_guid, 1),
-- ملاحظة: يجب ربط حساب حتى لو كانت القيمة INGEN لأن العمود mva_konto_guid لا يقبل NULL في تعريفك
(mva3_guid, 'mva3', 'INGEN MVA 0%', 'INGEN', 0, 100, kontoer15_guid, 1);
-- 📄 MVA_linjer
INSERT INTO mva_linjer(guid,transaksjon_guid,mva_kode_guid,grunnlag_teller,grunnlag_nevner,mva_belop_teller,mva_belop_nevner)
VALUES
(mva1_linjer, transaksjoner6_guid, mva1_guid, 50000,100,12500,100),
(mva2_linjer, transaksjoner3_guid, mva2_guid, 800,100,200,100),
(mva3_linjer, transaksjoner2_guid, mva1_guid, 1000,100,250,100),
(mva4_linjer, transaksjoner8_guid, mva1_guid, 12500,100,12500,100);


--Lot جدول Lot مخصص لإدارة عمليات شراء وبيع الأوراق المالية (مثل الأسهم والسندات)،
INSERT INTO Lot(guid, konto_guid, beskrivelse, er_lukket)
VALUES
-- لوت مرتبط بحساب الأسهم (Aksjer)
(lot1_guid, kontoer11_guid, 'Kjøp 10 aksjer for investering', 0),--اشترِ 10 أسهم للاستثمار
-- لوت ثاني افتراضي إذا أردت إدخال عمليات أخرى
(lot2_guid, kontoer11_guid, 'Kjøp ekstra aksjer for portefølje', 0);--افتراضي




-- 📊 Budsjetter ميزانية
INSERT INTO Budsjetter(guid, bok_guid, navn, beskrivelse, antall_perioder)
VALUES
(budsjetter1_guid, bok_guid, 'Årsbudsjett 2026',"Budsjett for regnskapsåret 2026 + inntekter og utgifter", 12);--'Årsbudsjett 2026'
 (budsjetter2_guid, bok_guid, 'Fakturering mars 2026', 'Budsjett for fakturering kunder', 12);--فواتير مارس 2026

 (budsjetter3_guid,  bok_guid, 'Innbetaling kunde mars 2026', 
    'Budsjett for innbetalinger',    12  )-- مدفوعات
    , (budsjetter4_guid, bok_guid, 'Lønn mars 2026', 'Budsjett for lønn og arbeidsgiveravgift', 12);--ميزانية الرواتب ومساهمات صاحب العمل
-- إنشاء ميزانية للشراء بالأسهم الأجنبية

(budsjetter6_guid, bok_guid, 'Kjøp aksjer Apple', 'Budsjett for kjøp av 10 Apple-aksjer, flervaluta', 12)
(budsjetter7_guid, bok_guid, 'MVA 1. termin 2026', 'Budsjett for innbetaling MVA til staten', 12);
-- إنشاء ميزانية لفوترة مشروع دولي مع خسارة فرق عملة

(budsjetter8_guid, bok_guid, 'Fakturering internasjonal prosjekt mars 2026', 'Budsjett for fakturering internasjonal kunde og valutakurstap', 12);    
    ;





--جدول التفاصيل (lines) لكل ميزانية.
--كل سطر فيه يمثل مبلغ متوقع لحساب محدد لشهر/فترة معينة.
-- Scenario 1: -- السيناريو 1: مساهمة رأس المال (مارس 2026)
INSERT INTO Budsjetter(guid, bok_guid, navn, beskrivelse, antall_perioder)
VALUES ('BUDGET001', bok_guid, 'Årsbudsjett 2026', 'Budsjett for oppstart av selskapet', 12);

INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter1_guid, kontoer9_guid, 3, 20000000, 100),  -- Bankinnskudd
(budsjetter1_guid, kontoer12_guid, 3, -20000000, 100); -- Aksjekapital


--السيناريو الثاني: شراء لوازم مكتبية بالدين (4375 دولارًا)
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter1_guid, kontoer6560_guid, 3, 350000, 100),  -- 'لوازم مكتبية'،
(budsjetter1_guid, kontoer15_guid, 3, 87500, 100),     -- Inngående MVA
(budsjetter1_guid, kontoer13_guid, 3, -437500, 100);   -- Leverandørgjeldالحسابات الدائنة

--سيناريو 3: Fakturering av kunde (62,500 kr)

INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter2_guid, kontoer10_guid, 3, 6250000, 100),   -- Kundefordringerذمم مدينة (من العميل)
(budsjetter2_guid, kontoer3100_guid, 3, -5000000, 100), -- Salgsinntekt (أضف GUID مطابق)إيرادات مبيعات
(budsjetter2_guid, kontoer14_guid, 3, -1250000, 100);  -- Utgående MVAضريبة مخرجات (خارجة)


-- السيناريو الرابع: الدفع من العميل (62,500 كرونة سويدية)السيناريو 4: استلام الدفعة من العميل

INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter3_guid, kontoer9_guid, 3, 6250000, 100),    -- Bankinnskuddإيداعات بنكية
(budsjetter3_guid, kontoer10_guid, 3, -6250000, 100);  -- Kundefordringer-ذمم مدينة



--السيناريو 5: دفع الرواتب (مع الضرائب والرسوم)
-- Budsjettlinjer for Scenario 5
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter4_guid, kontoer5000_guid, 3, 4500000, 100),  -- Lønnحساب Lønn / الرواتب
(budsjetter4_guid, kontoer9_guid, 3, -3300000, 100),    -- Bankinnskudd ايداع بنكي
(budsjetter4_guid, kontoer150_guid, 3, -1200000, 100), -- Forskuddstrekk (أضف GUID مطابق)الضرائب المستقطعة من الرواتب
(budsjetter4_guid, kontoer5400_guid, 3, 634500, 100),    -- Arbeidsgiveravgift ضريبة صاحب العمل
(budsjetter4_guid, kontoer151_guid, 3, -63450０, 1００);  -- Skyldig AGA ضرائب الدولة

-- تسجيل حركة الشراء في الميزانيةسيناريو 6:
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter6_guid, kontoer11_guid, 3, 1837500, 100),  -- Aksjer (10*175 USD * 10.50 NOK/USD = 18,375 NOK)أسهم في شركات أجنبية
(budsjetter6_guid, kontoer9_guid, 3, -1837500, 100);  -- Bankinnskudd (خروج النقود)إيداعات بنكية



سيناريو 7:السيناريو 7: تسوية ضريبة القيمة المضافة (MVA) مع الدولة

-- تسجيل الحركات في ميزانية MVA
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter7_guid, kontoer14_guid, 3, 1250000, 100),   -- Utgående MVA (ضريبة المخرجات، مدين)
(budsjetter7_guid, kontoer15_guid, 3, -87500, 100),     -- Inngående MVA (ضريبة المدخلات، دائن)
(budsjetter7_guid, kontoer9_guid, 3, -1162500, 100);    -- Bankinnskudd (دفع من البنك)


-- تسجيل الحركات في ميزانية المشروع الدولي8:السيناريو 
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
-- أ. الفوترة
(budsjetter8_guid, kontoer10_guid, 3, 5100000, 100),  -- Kundefordringer (ذمم مدينة، مدين)
(budsjetter8_guid, kontoer3100_guid, 3, -5100000, 100), -- Salgsinntekt (مبيعات، دائن)

-- ب. التحصيل مع خسارة فرق العملة
(budsjetter8_guid, kontoer9_guid, 3, 4900000, 100),    -- Bankinnskudd (إيداعات بنكية، مدين)
(budsjetter8_guid, kontoer8160_guid, 3, 200000, 100),  -- Valutatap (خسارة فرق عملة، مدين)
(budsjetter8_guid, kontoer10_guid, 3, -5100000, 100);  -- Kundefordringer (ذمم مدينة، دائن)






----Planlagte_Transaksjoner تفاصيل المعاملات
-- 💼 إدخالات Planlagte_Transaksjoner للسيناريوهات 8
INSERT INTO Planlagte_Transaksjoner
(guid, bok_guid, navn, aktiv, startdato, sluttdato, gjentakelse_type, gjentakelse_mult, auto_opprett, sist_opprettet)
VALUES
-- 1. Innskudd aksjekapital fra eier1- مساهمة رأس المال من المالك
(Planlagte_Transaksjoner1, bok_guid, 'Innskudd aksjekapital fra eier', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 2. Kjøpe kontorrekvisita på kreditt2- شراء اللوازم المكتبية بالتقسيط
(Planlagte_Transaksjoner2, bok_guid, 'Kjøpe kontorrekvisita på kreditt', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 3. Kjøp varer fra leverandør3- شراء البضائع من المورد
(Planlagte_Transaksjoner3, bok_guid, 'Kjøp varer fra leverandør', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 4. Utbetaling lønn 2026-دفع الراتب 2026
(Planlagte_Transaksjoner4, bok_guid, 'Utbetaling lønn 2026', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 5. Kjøp 10 aksjer5. Kjøp 10 aksjer- شراء 10 أسهم
(Planlagte_Transaksjoner5, bok_guid, 'Kjøp 10 aksjer', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 6. Salg tjenester til kunde A      خدمات المبيعات للعميل أ  
(Planlagte_Transaksjoner6, bok_guid, 'Salg tjenester til kunde A', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 7. Betaling netto MVA-المبلغ المدفوع بعد خصم ضريبة القيمة المضافة
(Planlagte_Transaksjoner7, bok_guid, 'Betaling netto MVA', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL),

-- 8. Prosjektfakturering med delvis betaling og valutatap-إصدار فواتير المشاريع مع الدفع الجزئي وفقدان العملة
(Planlagte_Transaksjoner8, bok_guid, 'Prosjektfakturering med delvis betaling og valutatap', 1, DATE '2026-04-01', NULL, 'MAANED', 1, 1, NULL);



-- إدخالات العملاء التجريبية
INSERT INTO kunder(guid, bok_guid, kundenummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, mva_kode_guid, aktiv)
VALUES
(kunder1, bok_guid, 'K001', 'Kunde A', '987654321', 'Oslo', 'kundeA@example.com', value_NOK_guid, gen_random_uuid()::text,'-',''), mva1_guid, 1),
(kunder2, bok_guid, 'K002', 'Kunde B', '876543210', 'Bergen', 'kundeB@example.com', value_NOK_guid, gen_random_uuid()::text,'-',''), mva1_guid, 1),
(kunder3, bok_guid, 'K003', 'Kunde C', '765432109', 'Trondheim', 'kundeC@example.com', value_NOK_guid, gen_random_uuid()::text,'-',''), mva2_guid, 1),
(kunder4, bok_guid, 'K004', 'Kunde D', '654321098', 'Stavanger', 'kundeD@example.com', value_NOK_guid, replace(gen_random_uuid()::text,'-',''), mva1_guid, 1);


--جدول Betalingsbetingelser مصمم لتحديد شروط الدفع القابلة لإعادة الاستخدام عبر العملاء، الموردين، والفواتير.
-- =============================================
-- إدخالات جدول Betalingsbetingelser
-- =============================================
INSERT INTO Betalingsbetingelser(  guid,  navn,  type,  forfallsdager,  kontantrabatt_dager,  rabatt_teller,  rabatt_nevner)
VALUES
-- مثال 1: الدفع خلال 30 يوم بدون خصم
(Betalingsbetingelser1, '30 dager netto', 'DAGER', 30, 0, 0, 100),

-- مثال 2: الدفع خلال 14 يوم مع خصم 2%
(Betalingsbetingelser2, '14 dager med 2% rabatt', 'DAGER', 14, 14, 2, 100),

-- مثال 3: الدفع في نهاية الشهر (proximo)
(Betalingsbetingelser3, 'Proximo slutten av måneden', 'PROXIMO', 30, 0, 0, 100),

-- مثال 4: الدفع خلال 10 أيام مع خصم 5%
(Betalingsbetingelser4, '10 dager med 5% rabatt', 'DAGER', 10, 10, 5, 100);




-- =============================================
-- العملاء (kunder)
-- =============================================
INSERT INTO kunder (
    guid, bok_guid, kundenummer, navn, organisasjonsnr, adresse, epost,
    valuta_guid, betalingsbetingelse_guid, mva_kode_guid, aktiv
)
VALUES
(kunder1, bok_guid, 'K001', 'Kunde AS', '987654321', 'Oslo, Norge', 'kontakt@kunde.no', value_NOK_guid, Betalingsbetingelser1, mva2_guid, 1),
(kunder2, bok_guid, 'K002', 'Global AB', '55667788', 'Stockholm, Sweden', 'info@global.se', value_USD_guid, Betalingsbetingelser1, mva3_guid, 1),
(kunder3, bok_guid, 'K003', 'Svensk Kunde AB', '11223344', 'Göteborg, Sweden', 'faktura@svensk.se', value_USD_guid, Betalingsbetingelser2, mva3_guid, 1);

-- =============================================
-- الفواتير (fakturaer) المرتبطة بالعملاء
-- =============================================
INSERT INTO fakturaer (
    guid, bok_guid, kunden_guid, betalingsbetingelse_guid, valuta_guid, mva_kode_guid,
    fakturanummer, fakturadato, forfallsdato, beskrivelse, total_belop, aktiv
)
VALUES
(fakturaer1, bok_guid, 'kunder1', Betalingsbetingelser1, value_NOK_guid, mva2_guid,
 'F003', '2026-03-15', '2026-04-14', 'Fakturering mars 2026', 62500, 1),
(fakturaer2, bok_guid, 'kunder2', Betalingsbetingelser1, value_USD_guid, mva3_guid,
 'F006', '2026-03-20', '2026-04-19', 'Kjøp 10 Apple-aksjer', 18375, 1),
(fakturaer3, bok_guid, 'kunder3', Betalingsbetingelser2, value_USD_guid, mva3_guid,
 'F008', '2026-03-25', '2026-04-24', 'Prosjektfakturering mars 2026', 51000, 1);




-- =============================================
-- خطوط الفاتورة (fakturalinjer) المصححة
-- =============================================
INSERT INTO fakturalinjer (
    guid, faktura_guid, beskrivelse, antall_teller, antall_nevner,
    enhetspris_teller, enhetspris_nevner, inntekt_konto_guid, kostnad_konto_guid,
    mva_kode_guid, mva_inkludert, rabatt_teller, rabatt_nevner
)
VALUES
-- Fakturaer1: Kunde AS (خدمات استشارية)
(fakturalinje1, fakturaer1, 'Konsulenttjenester mars', 1, 1, 50000, 1, kontoer3100_guid, kontoer6560_guid, mva2_guid, 0, 0, 100),

-- Fakturaer2: Global AB (شراء 10 أسهم - استثمار)
(fakturalinje2, fakturaer2, 'Kjøp 10 Apple-aksjer', 10, 1, 1837, 1, kontoer11_guid, kontoer60_guid, mva3_guid, 0, 0, 100),

-- Fakturaer3: Svensk Kunde AB (مشروع / رواتب)
(fakturalinje3, fakturaer3, 'Prosjektarbeid mars', 1, 1, 51000, 1, kontoer3100_guid, kontoer5000_guid, mva3_guid, 0, 0, 100);

--enhetspris_teller/neven	50000/1	سعر الوحدة: 50,000 كرونة نرويجية
---inntekt_konto_guid-->kontoer3100_guid /// حساب الإيرادات (Salgsinntekt) → يمثل دخل الشركة
--kostnad_konto_guid-->kontoer6560_guid////حساب التكلفة/المصروف المرتبط (Kontorrekvisita) → عادة ليس مرتبط هنا لكن تركناه كمثال
--mva_kode_guid	mva2_guid	ضريبة القيمة المضافة للفاتورة (Inngående 25%)
--mva_inkludert	0	السعر لا يشمل MVA، يتم إضافتها فوق السعر
--rabatt_teller/neven	0/100	لا يوجد خصم




--مورد لشراء اللوازم المكتبية
INSERT INTO Leverandører (
    guid, bok_guid, leverandornummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, aktiv
)
VALUES (
    leverandor1, bok_guid, 'L001', 'Office Supplies AS', '12345678', 'Oslo, Norway', 'kontakt@office.no', value_NOK_guid, Betalingsbetingelser1, 1
);

--مورد لشراء البضائع/السلع
INSERT INTO Leverandører (
    guid, bok_guid, leverandornummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, aktiv
)
VALUES (
    leverandor2, bok_guid, 'L002', 'Grossist Varer AS', '87654321', 'Bergen, Norway', 'faktura@grossist.no', value_NOK_guid, Betalingsbetingelser2, 1
);

--مورد لشراء الأسهم/استثمار دولي
INSERT INTO Leverandører (
    guid, bok_guid, leverandornummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, aktiv
)
VALUES (
    'leverandor3', bok_guid, 'L003', 'Apple Inc.', '00000000', '1 Apple Park Way, Cupertino, CA, USA', 'invest@apple.com', value_USD_guid, Betalingsbetingelser1, 1
);
--4️⃣ مورد خدمات أجنبية (مثل استشارات أو دعم مشاريع دولية)
INSERT INTO Leverandører (
    guid, bok_guid, leverandornummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, aktiv
)
VALUES (
    'leverandor4', bok_guid, 'L004', 'Global Consulting AB', '55667788', 'Stockholm, Sweden', 'kontakt@globalconsulting.se', value_USD_guid, Betalingsbetingelser2, 1
);

--==============================--
---Posteringer-------------------
--==============================--


-- السيناريو 1: إيداع رأس المال
-- Bankinnskudd (مدين)
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, tekst)
VALUES (P1, transaksjoner1_guid, kontoer9_guid, 20000000, 100, 'Innskudd aksjekapital fra eier');

-- Aksjekapital (دائن)
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, tekst)
VALUES (P2, transaksjoner1_guid, kontoer12_guid, -20000000, 100, 'Aksjekapital fra eier');
--==============================--


-- ✅ السيناريو 2: شراء لوازم مكتبية بالدين
-- Lønn/مصروف لوازم مكتبية (مدين)
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner)
VALUES (P3, transaksjoner2_guid, kontoer6560_guid, 350000, 100);

-- Inngående MVA (مدين)
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner)
VALUES (P4, transaksjoner2_guid, kontoer15_guid, 87500, 100);

-- Leverandørgjeld (دائن)
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner)
VALUES (P5, transaksjoner2_guid, kontoer13_guid, -437500, 100);
--==============================--




-- دفع رواتب (Lønn)
-- Transaksjon 3: Lønn til ansatte
INSERT INTO Posteringer VALUES
(P6, transaksjoner3_guid, kontoer5000_guid, 5100000, 100, 'Lønn mars', 'Lønn'),  -- Debet Lønnskostnad
(P7, transaksjoner3_guid, kontoer1920_guid, -5100000, 100, 'Utbetaling lønn', 'Lønn'); -- Kredit Bank
--==============================--

--==============================--
-- 4️⃣ شراء أسهم (Investering)
-- Transaksjon 4: Kjøp aksjer
INSERT INTO Posteringer VALUES
(P8, transaksjoner4_guid, kontoer11_guid, 18370, 1, 'Kjøp 10 Apple-aksjer', 'Kjøp'),  -- Debet Aksjer (lot_guid nødvendig)
(P9, transaksjoner4_guid, kontoer13_guid, -18370, 1, 'Betaling til leverandør', 'Kjøp'); -- Kredit Bank/Leverandør





-- -- Transaksjon 5: Leverandørfaktura
INSERT INTO Posteringer VALUES
(P10, transaksjoner5_guid, kontoer6560_guid, 100000, 100, 'Kjøp tjenester leverandør', 'Kjøp'), -- Debet Kostnad
(P11, transaksjoner5_guid, kontoer14_guid, 25000, 100, 'MVA', 'Kjøp'),                           -- Debet MVA
(P12, transaksjoner5_guid, kontoer13_guid, -125000, 100, 'Leverandørgjeld', 'Kjøp');              -- Kredit Leverandør




-- 6️⃣ بيع خدمات للعميل (Salg faktura)

-- -- Kundefordringer (مدين)
-- Transaksjon 6: Salg faktura til kunde
INSERT INTO Posteringer VALUES
(P13, transaksjoner6_guid, kontoer10_guid, 6250000, 100, 'Fakturert Kunde AB', 'Salg'),       -- Debet Kundefordringer
(P14, transaksjoner6_guid, kontoer3100_guid, -5000000, 100, 'Salgskonto', 'Salg'),            -- Kredit Salgsinntekt
(P15, transaksjoner6_guid, kontoer14_guid, -1250000, 100, 'Utgående MVA', 'Salg');           -- Kredit MVA


-- 7️⃣ استلام الدفعات من العملاء (Innbetaling fra kunde)
-- Transaksjon 7: Innbetaling fra kunde
INSERT INTO Posteringer VALUES
( P16  , transaksjoner7_guid, kontoer1920_guid, 6250000, 100, 'Bankinnbetaling Kunde AB', 'Innbetaling'), -- Debet Bank
(P17, transaksjoner7_guid, kontoer10_guid, -6250000, 100, 'Reduksjon kundefordringer', 'Innbetaling'); -- Kredit Kundefo

-- 8️⃣ دفع فواتير الموردين (Betaling til leverandør)
-- Transaksjon 8: Betaling til leverandør
INSERT INTO Posteringer VALUES
(P18, transaksjoner8_guid, kontoer13_guid, 125000, 100, 'Betaling leverandør', 'Betaling'), -- Debet Leverandørgjeld
(P19, transaksjoner8_guid, kontoer1920_guid, -125000, 100, 'Bankutbetaling', 'Betaling');   -- Kredit Bank


-- تسجيل مصاريف تشغيل أخرى (Andre driftskostnader)
-- Transaksjon 9: Diverse driftskostnader
INSERT INTO Posteringer VALUES
(   P20, transaksjoner9_guid, kontoer6570_guid, 200000, 100, 'Strøm og telefon', 'Kostnad'), -- Debet Kostnad
(P21, transaksjoner9_guid, kontoer1920_guid, -200000, 100, 'Bankbetaling', 'Kostnad');      -- Kredit Ban


END;
$$;















---------------------------------------------
---------------------------------------------
مصحححححححححححح
---------------------------------------------
---------------------------------------------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
    -- 📘 GUIDs الكتب والعملات
    bok_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_NOK_guid char(32) := replace(gen_random_uuid()::text,'-','');
    value_USD_guid char(32) := replace(gen_random_uuid()::text,'-','');
    valutakurser_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 🏦 GUIDs الحسابات الرئيسية
    kontoer1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    kontoer8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 🏦 GUIDs الحسابات الفرعية
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

    -- 💳 GUIDs المعاملات
    transaksjoner1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner5_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner8_guid char(32) := replace(gen_random_uuid()::text,'-','');
    transaksjoner9_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 📄 GUIDs MVA
    mva1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    mva1_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva2_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva3_linjer char(32) := replace(gen_random_uuid()::text,'-','');
    mva4_linjer char(32) := replace(gen_random_uuid()::text,'-','');

    -- 📅 فترة محاسبية
    regnskapsperioder_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 💰 GUIDs Budsjetter
    budsjetter1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter2_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter3_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter4_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter6_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter7_guid char(32) := replace(gen_random_uuid()::text,'-','');
    budsjetter8_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 💼 GUIDs Lot
    lot1_guid char(32) := replace(gen_random_uuid()::text,'-','');
    lot2_guid char(32) := replace(gen_random_uuid()::text,'-','');

    -- 👤 GUIDs kunder
    kunder1 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder2 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder3 char(32) := replace(gen_random_uuid()::text,'-','');
    kunder4 char(32) := replace(gen_random_uuid()::text,'-','');

    -- 👥 GUIDs fakturaer
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

-- 📘 Bøker
INSERT INTO bøker(guid, navn, organisasjonsnr, adresse, regnskapsaar)
VALUES (bok_guid, 'DATA1500 Konsult AS', '123456789', 'Oslo', DATE '2026-01-01');

-- 💱 Valutaer
INSERT INTO valutaer(guid, kode, navn, desimaler, hent_kurs_flag, kurs_kilde)
VALUES
(value_NOK_guid, 'NOK', 'krone', 2, 1, 'BANK'),
(value_USD_guid, 'USD', 'Dollar', 2, 0, 'GLOBAL_BANK');

-- 📊 Valutakurser
INSERT INTO valutakurser(guid, fra_valuta_guid, til_valuta_guid, dato, kilde, type, kurs_teller, kurs_nevner)
VALUES (valutakurser_guid, value_USD_guid, value_NOK_guid, CURRENT_TIMESTAMP, 'norges-bank', 'last', 1000, 100);

-- 📊 Kontoklasser
INSERT INTO kontoklasser(klasse_nr, navn, type, normal_saldo, beskrivelse)
VALUES
(1, 'Eiendeler', 'BALANSE', 'DEBET', 'selskapets penger og eiendom.'),
(2, 'Gjeld og Egenkapital', 'BALANSE', 'KREDIT', 'Gjeld og Egenkapital'),
(3, 'Inntekter', 'RESULTAT', 'KREDIT', 'inntekter'),
(4, 'Varekostnad', 'RESULTAT', 'DEBET', 'Varekostnad'),
(5, 'Lønn', 'RESULTAT', 'DEBET', 'utgift og lønn'),
(6, 'Andre kostnader', 'RESULTAT', 'DEBET', 'Andre kostnader'),
(7, 'Finans', 'RESULTAT', 'DEBET', 'Finans'),
(8, 'Skatt', 'RESULTAT', 'DEBET', 'Skatt til inntekter');

-- 🏦 Kontoer
-- 🏦 إدخال الحسابات (Kontoer) - نسخة مصححة بالكامل
INSERT INTO kontoer(guid, bok_guid, overordnet_guid, valuta_guid, kontonummer, kontoklasse, gnucash_type, navn, beskrivelse, er_placeholder, er_skjult, mva_pliktig, mva_kode_guid)
VALUES
-- 1. الأصول (Eiendeler)
(kontoer1_guid, bok_guid, NULL, value_NOK_guid, 1000, 1, 'ASSET', 'Eiendeler', 'Hovedkonto eiendeler', 1, 0, 0, NULL),
(kontoer9_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1920, 1, 'BANK', 'Bankinnskudd', 'Bankkonto', 0, 0, 0, NULL),
(kontoer10_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1500, 1, 'ASSET', 'Kundefordringer', 'Fordringer', 0, 0, 0, NULL),
(kontoer11_guid, bok_guid, kontoer1_guid, value_NOK_guid, 1350, 1, 'ASSET', 'Aksjer', 'Investeringer', 0, 0, 0, NULL),

-- 2. الخصوم وحقوق الملكية (Gjeld og EK)
(kontoer2_guid, bok_guid, NULL, value_NOK_guid, 2000, 2, 'LIABILITY', 'Gjeld og EK', 'Hovedkonto gjeld/egenkapital', 1, 0, 0, NULL),
(kontoer12_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2010, 2, 'EQUITY', 'Aksjekapital', 'Egenkapital', 0, 0, 0, NULL), -- تم تغيير الرقم لـ 2010 لتجنب التكرار
(kontoer13_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2400, 2, 'LIABILITY', 'Leverandørgjeld', 'Gjeld leverandører', 0, 0, 0, NULL),
(kontoer14_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2700, 2, 'LIABILITY', 'Utgående MVA', 'Skyldig MVA', 0, 0, 1, NULL),
(kontoer15_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2710, 2, 'ASSET', 'Inngående MVA', 'Til gode MVA', 0, 0, 1, NULL),
(kontoer150_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2600, 2, 'LIABILITY', 'Forskuddstrekk', 'Skatt til forskudd', 0, 0, 0, NULL),
(kontoer151_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2780, 2, 'LIABILITY', 'Skyldig AGA', 'Arbeidsgiveravgift', 0, 0, 0, NULL),
(kontoer152_guid, bok_guid, kontoer2_guid, value_NOK_guid, 2740, 2, 'LIABILITY', 'Oppgjørskonto MVA', 'MVA-oppgjør', 0, 0, 0, NULL),

-- 3. الإيرادات (Inntekter)
(kontoer3100_guid, bok_guid, NULL, value_NOK_guid, 3100, 3, 'INCOME', 'Salgsinntekt', 'Inntekt fra tjenester', 0, 0, 0, NULL),

-- 4. المصاريف (Kostnader)
(kontoer5000_guid, bok_guid, NULL, value_NOK_guid, 5000, 5, 'EXPENSE', 'Lønn til ansatte', 'Kostnader til lønn', 0, 0, 0, NULL),
(kontoer5400_guid, bok_guid, NULL, value_NOK_guid, 5400, 5, 'EXPENSE', 'Arbeidsgiveravgift', 'Kostnad arbeidsgiveravgift', 0, 0, 0, NULL),
(kontoer6560_guid, bok_guid, NULL, value_NOK_guid, 6560, 6, 'EXPENSE', 'Rekvisita', 'Kontورrekvisita', 0, 0, 0, NULL),
(kontoer8160_guid, bok_guid, NULL, value_NOK_guid, 8160, 8, 'EXPENSE', 'Valutatap', 'Tap ved valutakursendring', 0, 0, 0, NULL); -- تم جعل الأب NULL لتجنب خطأ الربط
-- 📅 Regnskapsperioder
INSERT INTO regnskapsperioder(guid, bok_guid, navn, fra_dato, til_dato, status)
VALUES (regnskapsperioder_guid, bok_guid, 'Mars 1', DATE '2026-03-01', DATE '2026-03-31', 'AAPEN');

-- 💳 Transaksjoner
INSERT INTO transaksjoner(guid, bok_guid, valuta_guid, bilagsnummer, bilagsdato, posteringsdato, registreringsdato, beskrivelse, kilde, periode_guid)
VALUES
(transaksjoner1_guid, bok_guid, value_NOK_guid, 'T1', DATE '2026-04-01', current_timestamp, current_timestamp, 'Innskudd aksjekapital fra eier', 'manuell', regnskapsperioder_guid),
(transaksjoner2_guid, bok_guid, value_NOK_guid, 'T2', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøpe kontorrekvisita på kreditt', 'manuell', regnskapsperioder_guid),
(transaksjoner3_guid, bok_guid, value_NOK_guid, 'T3', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøp varer fra leverandør', 'manuell', regnskapsperioder_guid),
(transaksjoner4_guid, bok_guid, value_NOK_guid, 'T4', DATE '2026-04-01', current_timestamp, current_timestamp, 'Utbetaling lønn 2026', 'manuell', regnskapsperioder_guid),
(transaksjoner5_guid, bok_guid, value_NOK_guid, 'T5', DATE '2026-04-01', current_timestamp, current_timestamp, 'Kjøp 10 aksjer', 'manuell', regnskapsperioder_guid),
(transaksjoner6_guid, bok_guid, value_NOK_guid, 'T6', DATE '2026-04-01', current_timestamp, current_timestamp, 'Salg tjenester til kunde A', 'manuell', regnskapsperioder_guid),
(transaksjoner7_guid, bok_guid, value_NOK_guid, 'T7', DATE '2026-04-01', current_timestamp, current_timestamp, 'Salg tjenester til kunde B', 'manuell', regnskapsperioder_guid),
(transaksjoner8_guid, bok_guid, value_NOK_guid, 'T8', DATE '2026-04-01', current_timestamp, current_timestamp, 'Betaling netto MVA', 'manuell', regnskapsperioder_guid),
(transaksjoner9_guid, bok_guid, value_NOK_guid, 'T9', DATE '2026-04-01', current_timestamp, current_timestamp, 'Prosjektfakturering med delvis betaling og valutatap', 'manuell', regnskapsperioder_guid);

-- 📄 MVA_koder
-- 📄 MVA_koder (التصحيح النهائي بناءً على هيكل الجدول الخاص بك)
INSERT INTO mva_koder(guid, kode, navn, type, sats_teller, sats_nevner, mva_konto_guid, aktiv)
VALUES
(mva1_guid, 'mva1', 'Utgående MVA, høy sats (25%)', 'UTGAAENDE', 25, 100, kontoer14_guid, 1),
(mva2_guid, 'mva2', 'Inngående MVA 25%', 'INNGAAENDE', 25, 100, kontoer15_guid, 1),
-- ملاحظة: يجب ربط حساب حتى لو كانت القيمة INGEN لأن العمود mva_konto_guid لا يقبل NULL في تعريفك
(mva3_guid, 'mva3', 'INGEN MVA 0%', 'INGEN', 0, 100, kontoer15_guid, 1);
-- 📄 MVA_linjer
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

-- 📊 Budsjetter
INSERT INTO Budsjetter(guid, bok_guid, navn, beskrivelse, antall_perioder)
VALUES
(budsjetter1_guid, bok_guid, 'Årsbudsjett 2026', 'Budsjett for regnskapsåret 2026 + inntekter og utgifter', 12),
(budsjetter2_guid, bok_guid, 'Fakturering mars 2026', 'Budsjett for fakturering kunder', 12),
(budsjetter3_guid, bok_guid, 'Innbetaling kunde mars 2026', 'Budsjett for innbetalinger', 12),
(budsjetter4_guid, bok_guid, 'Lønn mars 2026', 'Budsjett for lønn og arbeidsgiveravgift', 12),
(budsjetter6_guid, bok_guid, 'Kjøp aksjer Apple', 'Budsjett for kjøp av 10 Apple-aksjer, flervaluta', 12),
(budsjetter7_guid, bok_guid, 'MVA 1. termin 2026', 'Budsjett for innbetaling MVA til staten', 12),
(budsjetter8_guid, bok_guid, 'Fakturering internasjonal prosjekt mars 2026', 'Budsjett for fakturering internasjonal kunde og valutakurstap', 12),
('BUDGET001', bok_guid, 'Årsbudsjett 2026', 'Budsjett for oppstart av selskapet', 12);

-- Budsjettlinjer
INSERT INTO Budsjettlinjer(budsjett_guid, konto_guid, periode_nr, belop_teller, belop_nevner)
VALUES
(budsjetter1_guid, kontoer9_guid, 3, 20000000, 100),
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

-- Fakturaer
INSERT INTO fakturaer(guid, bok_guid, kunden_guid, betalingsbetingelse_guid, valuta_guid, mva_kode_guid, fakturanummer, fakturadato, forfallsdato, beskrivelse, total_belop, aktiv)
VALUES
(fakturaer1, bok_guid, kunder1, Betalingsbetingelser1, value_NOK_guid, mva2_guid, 'F003', '2026-03-15', '2026-04-14', 'Fakturering mars 2026', 62500, 1),
(fakturaer2, bok_guid, kunder2, Betalingsbetingelser1, value_USD_guid, mva3_guid, 'F006', '2026-03-20', '2026-04-19', 'Kjøp 10 Apple-aksjer', 18375, 1),
(fakturaer3, bok_guid, kunder3, Betalingsbetingelser2, value_USD_guid, mva3_guid, 'F008', '2026-03-25', '2026-04-24', 'Prosjektfakturering mars 2026', 51000, 1);

-- Fakturalinjer
INSERT INTO fakturalinjer(guid, faktura_guid, beskrivelse, antall_teller, antall_nevner, enhetspris_teller, enhetspris_nevner, inntekt_konto_guid, kostnad_konto_guid, mva_kode_guid, mva_inkludert, rabatt_teller, rabatt_nevner)
VALUES
(fakturalinje1, fakturaer1, 'Konsulenttjenester mars', 1, 1, 50000, 1, kontoer3100_guid, kontoer6560_guid, mva2_guid, 0, 0, 100),
(fakturalinje2, fakturaer2, 'Kjøp 10 Apple-aksjer', 10, 1, 1837, 1, kontoer11_guid, NULL, mva3_guid, 0, 0, 100),
(fakturalinje3, fakturaer3, 'Prosjektarbeid mars', 1, 1, 51000, 1, kontoer3100_guid, kontoer5000_guid, mva3_guid, 0, 0, 100);

-- Leverandører
INSERT INTO Leverandører(guid, bok_guid, leverandornummer, navn, organisasjonsnr, adresse, epost, valuta_guid, betalingsbetingelse_guid, aktiv)
VALUES
(leverandor1, bok_guid, 'L001', 'Office Supplies AS', '12345678', 'Oslo, Norway', 'kontakt@office.no', value_NOK_guid, Betalingsbetingelser1, 1),
(leverandor2, bok_guid, 'L002', 'Grossist Varer AS', '87654321', 'Bergen, Norway', 'faktura@grossist.no', value_NOK_guid, Betalingsbetingelser2, 1),
('leverandor3', bok_guid, 'L003', 'Apple Inc.', '00000000', '1 Apple Park Way, Cupertino, CA, USA', 'invest@apple.com', value_USD_guid, Betalingsbetingelser1, 1),
('leverandor4', bok_guid, 'L004', 'Global Consulting AB', '55667788', 'Stockholm, Sweden', 'kontakt@globalconsulting.se', value_USD_guid, Betalingsbetingelser2, 1);

-- Posteringer
INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, tekst)
VALUES 
(P1, transaksjoner1_guid, kontoer9_guid, 20000000, 100, 'Innskudd aksjekapital fra eier'),
(P2, transaksjoner1_guid, kontoer12_guid, -20000000, 100, 'Aksjekapital fra eier'),
(P3, transaksjoner2_guid, kontoer6560_guid, 350000, 100, 'Rekvisita'),
(P4, transaksjoner2_guid, kontoer15_guid, 87500, 100, 'MVA'),
(P5, transaksjoner2_guid, kontoer13_guid, -437500, 100, 'Gjeld');

INSERT INTO Posteringer(guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, tekst, kilde)
VALUES
(P6, transaksjoner3_guid, kontoer5000_guid, 5100000, 100, 'Lønn mars', 'Lønn'),
(P7, transaksjoner3_guid, kontoer9_guid, -5100000, 100, 'Utbetaling lønn', 'Lønn'),
(P8, transaksjoner4_guid, kontoer11_guid, 18370, 1, 'Kjøp 10 Apple-aksjer', 'Kjøp'),
(P9, transaksjoner4_guid, kontoer13_guid, -18370, 1, 'Betaling til leverandør', 'Kjøp'),
(P10, transaksjoner5_guid, kontoer6560_guid, 100000, 100, 'Kjøp tjenester leverandør', 'Kjøp'),
(P11, transaksjoner5_guid, kontoer14_guid, 25000, 100, 'MVA', 'Kjøp'),
(P12, transaksjoner5_guid, kontoer13_guid, -125000, 100, 'Leverandørgjeld', 'Kjøp'),
(P13, transaksjoner6_guid, kontoer10_guid, 6250000, 100, 'Fakturert Kunde AB', 'Salg'),
(P14, transaksjoner6_guid, kontoer3100_guid, -5000000, 100, 'Salgskonto', 'Salg'),
(P15, transaksjoner6_guid, kontoer14_guid, -1250000, 100, 'Utgående MVA', 'Salg'),
(P16, transaksjoner7_guid, kontoer9_guid, 6250000, 100, 'Bankinnbetaling Kunde AB', 'Innbetaling'),
(P17, transaksjoner7_guid, kontoer10_guid, -6250000, 100, 'Reduksjon kundefordringer', 'Innbetaling'),
(P18, transaksjoner8_guid, kontoer13_guid, 125000, 100, 'Betaling leverandør', 'Betaling'),
(P19, transaksjoner8_guid, kontoer9_guid, -125000, 100, 'Bankutbetaling', 'Betaling'),
(P20, transaksjoner9_guid, kontoer6560_guid, 200000, 100, 'Strøm og telefon', 'Kostnad'),
(P21, transaksjoner9_guid, kontoer9_guid, -200000, 100, 'Bankbetaling', 'Kostnad');

END;
$$;