--اكتب استعلامًا يجلب رقم الحساب، اسم الحساب، وفئة الحساب لكل الحسابات التي لديها رقم حساب. ورتّب النتائج حسب رقم الحساب.
SELECT 
    kontonummer,
    navn,
    kontoklasse
FROM kontoer
WHERE kontonummer IS NOT NULL
ORDER BY kontonummer;

--اكتب استعلامًا يجلب رمز فئة الحساب، اسم الفئة، ونوعها (BALANSE / RESULTAT) لجميع الفئات الثمانية، مع الترتيب حسب رقم الفئة.
SELECT 
    klasse_nr,
    navn,
    type
FROM kontoklasser
ORDER BY klasse_nr;

--اكتب استعلامًا يعرض رقم الحساب، اسم الحساب، واسم فئة الحساب التي ينتمي إليها باستخدام JOIN.
SELECT 
    k.kontonummer,
    k.navn AS kontonavn,
    kk.navn AS kontoklassenavn
FROM kontoer k
JOIN kontoklasser kk 
    ON k.kontoklasse = kk.klasse_nr
ORDER BY k.kontonummer;




--اكتب استعلامًا يعرض رقم المستند (bilagsnummer)، الوصف، وتاريخ المستند لكل عملية، مع عدد القيود (posteringer) التي تحتويها. ورتّب حسب التاريخ.
SELECT 
    t.bilagsnummer,
    t.beskrivelse,
    t.bilagsdato,
    COUNT(p.guid) AS antall_posteringer
FROM transaksjoner t
LEFT JOIN posteringer p 
    ON p.transaksjon_guid = t.guid
GROUP BY 
    t.bilagsnummer,
    t.beskrivelse,
    t.bilagsdato
ORDER BY t.bilagsdato;

--اكتب استعلامًا يحسب ويعرض إجمالي الرصيد لكل حساب يحتوي على قيود.
-- اعرض رقم الحساب، اسم الحساب، والرصيد، ورتّب حسب رقم الحساب.
SELECT 
    k.kontonummer,
    k.navn,
    SUM(p.belop_teller / NULLIF(p.belop_nevner,0)) AS saldo
FROM kontoer k
JOIN posteringer p 
    ON p.konto_guid = k.guid
GROUP BY 
    k.kontonummer,
    k.navn
ORDER BY k.kontonummer;

--اكتب استعلامًا يجد جميع الحسابات التي تكون إما خاضعة لضريبة القيمة المضافة (mva_pliktig = TRUE) أو حسابات وهمية (er_placeholder = TRUE).
SELECT 
    kontonummer,
    navn,
    mva_pliktig,
    er_placeholder
FROM kontoer
WHERE mva_pliktig = 1
   OR er_placeholder = 1;

--    --اكتب استعلامًا يجلب جميع القيود المتعلقة بالرواتب (حيث وصف العملية يحتوي على "lønn").
-- اعرض:

-- وصف العملية
-- التاريخ
-- رقم الحساب
-- اسم الحساب
-- المبلغ
-- عمود يوضح (Debet أو Kredit) حسب الإشارة
SELECT 
    t.beskrivelse,
    t.bilagsdato,
    k.kontonummer,
    k.navn AS kontonavn,
    p.belop_teller / NULLIF(p.belop_nevner,0) AS belop,
    CASE 
        WHEN p.belop_teller > 0 THEN 'Debet'
        ELSE 'Kredit'
    END AS type
FROM posteringer p
JOIN transaksjoner t 
    ON p.transaksjon_guid = t.guid
JOIN kontoer k 
    ON p.konto_guid = k.guid
WHERE t.beskrivelse ILIKE '%lønn%';



-- اعرض عدد الحسابات الفعلية لكل فئة من الفئات الثمانية، وعدد الحسابات الخاضعة للـ MVA.
-- استخدم LEFT JOIN لتضمين الفئات بدون حسابات.


SELECT 
    kk.klasse_nr,
    kk.navn,
    COUNT(k.guid) AS antall_kontoer,
    SUM(CASE WHEN k.mva_pliktig = 1 THEN 1 ELSE 0 END) AS antall_mva_kontoer
FROM kontoklasser kk
LEFT JOIN kontoer k 
    ON k.kontoklasse = kk.klasse_nr
GROUP BY 
    kk.klasse_nr,
    kk.navn
ORDER BY kk.klasse_nr;

--اعرض رصيد جميع حسابات الأصول (الفئة 1)، بما في ذلك الحسابات التي لا تحتوي على معاملات (LEFT JOIN).
SELECT 
    k.kontonummer,
    k.navn,
    COALESCE(SUM(p.belop_teller / NULLIF(p.belop_nevner,0)), 0) AS saldo
FROM kontoer k
LEFT JOIN posteringer p 
    ON p.konto_guid = k.guid
WHERE k.kontoklasse = 1
GROUP BY 
    k.kontonummer,
    k.navn
ORDER BY k.kontonummer;




-- قق من مبدأ القيد المزدوج.
-- أوجد جميع العمليات التي لا يكون مجموع belop_teller فيها = 0.
-- إذا كانت البيانات متوازنة، يجب أن تكون النتيجة فارغة.
SELECT 
    t.guid,
    t.bilagsnummer,
    t.beskrivelse,
    SUM(p.belop_teller) AS total_belop
FROM transaksjoner t
JOIN posteringer p 
    ON p.transaksjon_guid = t.guid
GROUP BY 
    t.guid,
    t.bilagsnummer,
    t.beskrivelse
HAVING SUM(p.belop_teller) <> 0;

-- اكتب استعلامًا يجلب جميع خطوط ضريبة القيمة المضافة (MVA lines) ويربطها مع كود الضريبة والمعاملة.
-- اعرض: كود الضريبة، الأساس الضريبي، مبلغ الضريبة، ووصف المعاملة.

SELECT 
    mk.kode AS mva_kode,
    mk.navn AS mva_navn,
    t.beskrivelse AS transaksjon_beskrivelse,
    ml.grunnlag_teller / NULLIF(ml.grunnlag_nevner,0) AS grunnlag,
    ml.mva_belop_teller / NULLIF(ml.mva_belop_nevner,0) AS mva_belop
FROM mva_linjer ml
JOIN mva_koder mk 
    ON ml.mva_kode_guid = mk.guid
JOIN transaksjoner t 
    ON ml.transaksjon_guid = t.guid;

-- اكتب استعلامًا يعرض جميع أسعار الصرف.
-- اعرض: العملة من، العملة إلى، السعر، والتاريخ. ورتّب حسب الأحدث أولاً.    
SELECT 
    v1.kode AS fra_valuta,
    v2.kode AS til_valuta,
    vk.kurs_teller / vk.kurs_nevner AS kurs,
    vk.dato
FROM valutakurser vk
JOIN valutaer v1 
    ON vk.fra_valuta_guid = v1.guid
JOIN valutaer v2 
    ON vk.til_valuta_guid = v2.guid
ORDER BY vk.dato DESC;

-- اعرض عدد المعاملات لكل فترة محاسبية تحتوي معاملات.
-- اعرض اسم الفترة، التواريخ، الحالة، وعدد المعاملات.
SELECT 
    r.navn AS periode_navn,
    r.fra_dato,
    r.til_dato,
    r.status,
    COUNT(t.guid) AS antall_transaksjoner
FROM regnskapsperioder r
LEFT JOIN transaksjoner t 
    ON t.periode_guid = r.guid
GROUP BY 
    r.navn,
    r.fra_dato,
    r.til_dato,
    r.status
ORDER BY r.fra_dato;


-- احسب إجمالي الرصيد لكل فئة حساب.
-- اعرض: رقم الفئة، الاسم، النوع، وإجمالي الرصيد.
SELECT 
    kk.klasse_nr,
    kk.navn,
    kk.type,
    SUM(p.belop_teller / NULLIF(p.belop_nevner,0)) AS total_saldo
FROM kontoklasser kk
JOIN kontoer k 
    ON k.kontoklasse = kk.klasse_nr
LEFT JOIN posteringer p 
    ON p.konto_guid = k.guid
GROUP BY 
    kk.klasse_nr,
    kk.navn,
    kk.type
ORDER BY kk.klasse_nr;

-- تحليل تفصيلي لحسابات النتيجة (الفئات 3 إلى 8).
-- اعرض:

-- رقم الحساب
-- الاسم
-- عدد القيود
-- صافي الرصيد
-- إجمالي المدين
-- إجمالي الدائن
-- متوسط القيمة المطلقة للمعاملات

-- SQL:

SELECT 
    k.kontonummer,
    k.navn,

    COUNT(p.guid) AS antall_posteringer,

    SUM(p.belop_teller / NULLIF(p.belop_nevner,0)) AS netto_saldo,

    SUM(CASE 
        WHEN p.belop_teller > 0 THEN p.belop_teller / NULLIF(p.belop_nevner,0)
        ELSE 0 
    END) AS total_debet,

    SUM(CASE 
        WHEN p.belop_teller < 0 THEN ABS(p.belop_teller / NULLIF(p.belop_nevner,0))
        ELSE 0 
    END) AS total_kredit,

    AVG(ABS(p.belop_teller / NULLIF(p.belop_nevner,0))) AS gjennomsnitt_belop

FROM kontoer k
LEFT JOIN posteringer p 
    ON p.konto_guid = k.guid
WHERE k.kontoklasse BETWEEN 3 AND 8
GROUP BY 
    k.kontonummer,
    k.navn
ORDER BY k.kontonummer;