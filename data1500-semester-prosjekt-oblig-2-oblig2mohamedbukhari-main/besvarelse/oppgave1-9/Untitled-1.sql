WITH RECURSIVE saldo_per_konto AS (
    -- 
    SELECT 
        k.guid,
        k.overordnet_guid,
        k.kontonummer,
        k.navn,
        k.kontoklasse,
        COALESCE(SUM(p.belop_teller / p.belop_nevner), 0) AS saldo
    FROM kontoer k
    LEFT JOIN posteringer p 
        ON p.konto_guid = k.guid
    GROUP BY 
        k.guid, k.overordnet_guid, k.kontonummer, k.navn, k.kontoklasse
),

hierarki AS (
    --
    SELECT 
        s.guid,
        s.overordnet_guid,
        s.kontonummer,
        s.navn,
        s.kontoklasse,
        s.saldo,
        s.guid AS root_guid
    FROM saldo_per_konto s

    UNION ALL

    -- 
    SELECT 
        parent.guid,
        parent.overordnet_guid,
        parent.kontonummer,
        parent.navn,
        parent.kontoklasse,
        child.saldo,
        child.root_guid
    FROM saldo_per_konto parent
    JOIN hierarki child
        ON child.overordnet_guid = parent.guid
)

--
SELECT 
    kontonummer,
    navn,
    SUM(saldo) AS total_saldo
FROM hierarki
WHERE kontoklasse IN (1, 2)
GROUP BY kontonummer, navn
ORDER BY kontonummer;