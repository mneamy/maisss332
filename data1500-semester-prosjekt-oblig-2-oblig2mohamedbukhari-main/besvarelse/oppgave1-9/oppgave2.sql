DO $$
DECLARE
    bok_guid UUID := gen_random_uuid();
    periode_guid UUID := gen_random_uuid();
    tx_guid UUID;
    -- حسابات
    konto_1920 UUID := gen_random_uuid();
    konto_2000 UUID := gen_random_uuid();
    konto_1500 UUID := gen_random_uuid();
    konto_3100 UUID := gen_random_uuid();
    konto_2700 UUID := gen_random_uuid();
    konto_2710 UUID := gen_random_uuid();
    konto_2400 UUID := gen_random_uuid();
    konto_6560 UUID := gen_random_uuid();
    konto_5000 UUID := gen_random_uuid();
    konto_5400 UUID := gen_random_uuid();
    konto_2600 UUID := gen_random_uuid();
    konto_2780 UUID := gen_random_uuid();
    konto_1350 UUID := gen_random_uuid();
    konto_8160 UUID := gen_random_uuid();
BEGIN
    -- إنشاء العملات
    INSERT INTO "Valutaer" (guid, kode, navn) VALUES
    (gen_random_uuid(), 'NOK', 'Norske kroner'),
    (gen_random_uuid(), 'USD', 'US Dollar'),
    (gen_random_uuid(), 'SEK', 'Svenske kroner');

    -- إنشاء الحسابات الفعلية
    INSERT INTO "Kontoer" (guid, bok_guid, kontonummer, kontoklasse, navn, er_placeholder, valuta_guid) VALUES
    (konto_1920, bok_guid, 1920, 1, 'Bankinnskudd', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_2000, bok_guid, 2000, 2, 'Aksjekapital', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_1500, bok_guid, 1500, 1, 'Kundefordringer', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_3100, bok_guid, 3100, 3, 'Salgsinntekt, tjenester', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_2700, bok_guid, 2700, 2, 'Utgående MVA, høy sats', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_2710, bok_guid, 2710, 2, 'Inngående MVA, høy sats', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_2400, bok_guid, 2400, 2, 'Leverandørgjeld', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_6560, bok_guid, 6560, 6, 'Rekvisita', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_5000, bok_guid, 5000, 5, 'Lønn til ansatte', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_5400, bok_guid, 5400, 5, 'Arbeidsgiveravgift', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_2600, bok_guid, 2600, 2, 'Forskuddstrekk', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_2780, bok_guid, 2780, 2, 'Skyldig arbeidsgiveravgift', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_1350, bok_guid, 1350, 1, 'Aksjer i utenlandske selskaper', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK')),
    (konto_8160, bok_guid, 8160, 8, 'Valutatap (disagio)', FALSE, (SELECT guid FROM "Valutaer" WHERE kode='NOK'));

    -- Scenario 1: Stiftelse aksjekapital
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Stiftelse aksjekapital 200 000 kr', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_1920, 20000000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2000, -20000000, 100, 'n');

    -- Scenario 2: Kjøp kontorrekvisita
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Kjøp kontorrekvisita 4 375 kr', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_6560, 350000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2710, 87500, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2400, -437500, 100, 'n');

    -- Scenario 3: Fakturering kunde
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Fakturering TechNord AS 62 500 kr', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_1500, 6250000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_3100, -5000000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2700, -1250000, 100, 'n');

    -- Scenario 4: Innbetaling fra kunde
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Innbetaling fra TechNord AS', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_1920, 6250000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_1500, -6250000, 100, 'n');

    -- Scenario 5: Lønn og arbeidsgiveravgift
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Utbetaling lønn mars 2026', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_5000, 4500000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_1920, -3300000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2600, -1200000, 100, 'n');

    -- Arbeidsgiveravgift
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Arbeidsgiveravgift mars 2026', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_5400, 634500, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2780, -634500, 100, 'n');

    -- Scenario 6: Kjøp aksjer Apple USD
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Kjøp 10 AAPL aksjer USD', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_1350, 1837500, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_1920, -1837500, 100, 'n');

    -- Scenario 7: MVA-avregning
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Innbetaling MVA 1. termin', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_2700, -1250000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_2710, 87500, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_1920, 1162500, 100, 'n');

    -- Scenario 8: Fakturering SEK med valutatap
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Fakturering Göteborg Tech AB 50 000 SEK', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_1500, 5100000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_3100, -5100000, 100, 'n');

    -- Innbetaling med valutatap
    tx_guid := gen_random_uuid();
    INSERT INTO "Transaksjoner" (guid, beskrivelse, bok_guid, periode_guid) VALUES
    (tx_guid, 'Innbetaling Göteborg Tech AB med valutatap', bok_guid, periode_guid);
    INSERT INTO "Posteringer" (guid, transaksjon_guid, konto_guid, belop_teller, belop_nevner, avstemmingsstatus) VALUES
    (gen_random_uuid(), tx_guid, konto_1920, 4900000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_8160, 200000, 100, 'n'),
    (gen_random_uuid(), tx_guid, konto_1500, -5100000, 100, 'n');
END $$;