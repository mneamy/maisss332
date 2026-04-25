create table Bøker(
    guid char(32) primary key,
    navn text not null,
    organisasjonsnr TEXT CHECK (char_length(organisasjonsnr) = 9),
    adresse text,
    rot_konto_guid char(32),
    regnskapsaar date

);
COMMENT ON TABLE "bøker" is 'En bok fungerer som hovedenheten i systemet og samler alle andre entiteter. Den tilsvarer et komplett regnskap for én virksomhet.'
comment on column "bøker" .guid is 'for boken and Primærnøkkel';
COMMENT ON COLUMN "bøker".organisasjonsnr 
IS 'Virksomhetens 9-sifrede organisasjonsnummer';
COMMENT ON COLUMN "bøker".rot_konto_guid is 'Peker til rotkontoen i kontohierarkiet';
COMMENT ON COLUMN "bøker".regnskapsaar is 'Startdatoen for gjeldende regnskapsår';


CREATE TABLE VALUTAER(
guid char(32) primary key,
kode text UNIQUE not null,
navn text not null,
desimaler integer not null check (desimaler>0),
hent_kurs_flag integer not null check(hent_kurs_flag in (0,1))
default 0,
kurs_kilde text
);
COMMENT ON TABLE "valutaer" is 'Inneholder alle typer omsettelige valutaer som brukes i regnskapet, primært basert på ISO 4217-standarden';
comment on column "valutaer" .guid is 'for boken and Primærnøkkel';
comment on column "valutaer" .kode is 'ISO 4217-koden, f.eks. `NOK`, `USD`, `EUR`. Ikke NULL og unik.';
comment on column "valutaer" .navn is 'Fullt navn, f.eks. `Norske kroner`. Ikke NULL';
comment on column "valutaer" .desimaler is 'Antall desimaler valutaen opererer med (f.eks. 2 for NOK). Ikke NULL. Standardverdi 100. Sjekk at verdien er over 0';
comment on column "valutaer" .hent_kurs_flag is 'Boolsk flagg (1/0): om systemet skal forsøke å hente kurser automatisk. Ikke NULL. Standardverdi 0. Sjekk at verdien er enten 0 eller 1.';
comment on column "valutaer" .kurs_kilde is ' Standard kilde for automatisk kurshenting, f.eks. `norges-bank`, `ecb`';



CREATE TABLE Valutakurser (
    guid CHAR(32) PRIMARY KEY,
    fra_valuta_guid CHAR(32) NOT NULL,
    til_valuta_guid CHAR(32) NOT NULL,
    dato TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kilde TEXT,
    type TEXT CHECK (type IN ('last', 'bid', 'ask', 'nav')),
    kurs_teller BIGINT NOT NULL,
    kurs_nevner BIGINT NOT NULL DEFAULT 100 CHECK (kurs_nevner > 0),
    CHECK (fra_valuta_guid <> til_valuta_guid),
    FOREIGN KEY (fra_valuta_guid) REFERENCES Valutaer(guid) ON DELETE RESTRICT,
    FOREIGN KEY (til_valuta_guid) REFERENCES Valutaer(guid) ON DELETE RESTRICT
);
COMMENT ON TABLE "valutakurser" is 'Lagrer historiske vekslingskurser mellom to valutaer på et gitt tidspunkt.';
comment on column "valutakurser" .guid is 'for boken and Primærnøkkel';
comment on column "valutakurser" .fra_valuta_guid is 'Fremmednøkkel til `Valutaer`: valutaen som prises. Ikke NULL';
comment on column "valutakurser" .til_valuta_guid is ' Fremmednøkkel til `Valutaer`: valutaen prisen er uttrykt i (basisvaluta, typisk NOK). Ikke NULL';
comment on column "valutakurser" .kilde is 'Kilden til kursen, f.eks. `norges-bank`, `manuell`.';
COMMENT ON COLUMN "valutakurser".type 
IS 'Type kurs: ''last'' (siste), ''bid'' (kjøp), ''ask'' (salg), ''nav'' (for fond). Sjekk at verdiene er en av disse: ''last'', ''bid'', ''ask'', ''nav''.';
comment on column "valutakurser" .kurs_teller is ' Teller for kursverdien (brøkrepresentasjon). Ikke NULL.';
comment on column "valutakurser" .kurs_teller 
is ' Nevner for kursverdien. Kurs = `kurs_teller / kurs_nevner`. Ikke NULL. Standardverdien er 100. Sjekke at verdien er større enn 0, for å unngå divisjon med 0';








create table Kontoklasser(
    klasse_nr integer primary key,
    navn text not null unique,
    type text check(type in('RESULTAT','BALANSE')) not null,
    normal_saldo text check(normal_saldo in('DEBET','KREDIT')) not null,
    beskrivelse text 
);
COMMENT ON TABLE "kontoklasser" is 'En oppslagstabell som definerer de åtte hovedklassene i Norsk Standard Kontoplan (NS 4102).';
comment on column "kontoklasser" .klasse_nr is 'Primærnøkkel';
COMMENT ON COLUMN "kontoklasser".type 
IS '`BALANSE` eller `RESULTAT`. Ikke NULL. Sjekk at verdien er enten ''BALANSE'' eller ''RESULTAT''.';
COMMENT ON COLUMN "kontoklasser".normal_saldo 
IS '`DEBET` eller `KREDIT`. Angir hvilken side som øker saldoen. Ikke NULL. Sjekk at verdien er enten ''DEBET'' eller ''KREDIT''.';




create table Kontoer(
    guid char(32) primary key,
    bok_guid char(32) not null,
    overordnet_guid char(32),
    valuta_guid char(32) not null,
    kontonummer integer unique check(kontonummer between 1000 and 9999),
    kontoklasse integer not null,
    gnucash_type text,
    navn text not null,
    beskrivelse text not null,
    er_placeholder integer not null check(er_placeholder in(0,1)) default 0,
    er_skjult integer not null check(er_skjult in(0,1)) default 0,
    mva_pliktig integer not null check(mva_pliktig in(0,1)) default 0,
    mva_kode_guid char(32),
    foreign key (bok_guid) REFERENCES Bøker(guid) ON DELETE RESTRICT,
    foreign key (overordnet_guid) REFERENCES kontoer(guid) ON DELETE RESTRICT,
    foreign key (valuta_guid) REFERENCES VALUTAER (guid) ON DELETE RESTRICT,
    FOREIGN key (kontoklasse) REFERENCES Kontoklasser(klasse_nr) ON DELETE RESTRICT 
);
COMMENT ON TABLE "kontoer" is 'Implementerer den fullstendige, hierarkiske kontoplanen for virksomheten, tilpasset NS 4102.
';
comment on column "kontoklasser" .klasse_nr is '1–8. Primærnøkkel';
comment on column "kontoklasser" .type is ' `BALANSE` eller `RESULTAT`. Ikke NULL. Sjekk at verdien er enten BALANSE eller RESULTAT. |'
;
comment on column "kontoklasser" .normal_saldo is ' DEBET eller KREDIT. Angir hvilken side som øker saldoen. Ikke NULL. Sjekk at verdien er enten DEBET eller KREDIT.|';









ALTER TABLE "bøker" 
ADD CONSTRAINT fk_rot_konto 
FOREIGN KEY (rot_konto_guid)
REFERENCES "kontoer"(guid)
ON DELETE RESTRICT;



create table Transaksjoner(
    guid char(32) primary key,
    bok_guid char(32)not null,
    valuta_guid char(32)not null,
    bilagsnummer text not null,
    bilagsdato date,
    posteringsdato TIMESTAMP not null default current_TIMESTAMP,
    registreringsdato TIMESTAMP not null default current_TIMESTAMP,
    beskrivelse text not null,
    kilde text check(kilde in ('manuell','import','planlagt')) default 'manuell',
    periode_guid char(32) not null,
    foreign key (bok_guid) REFERENCES Bøker(guid) on delete restrict,
    foreign key (valuta_guid) references Valutaer(guid) on delete restrict
);
COMMENT ON TABLE "transaksjoner" is 'Representerer én finansiell hendelse (et bilag). Den er en overskrift som samler alle tilhørende posteringer.';
comment on column "transaksjoner" .guid is 'Primærnøkkel';
comment on column "transaksjoner" .bok_guid is 'Fremmednøkkel til `Bøker`. Ikke NULL';
comment on column "transaksjoner" .valuta_guid is ' Fremmednøkkel til `Valutaer`: transaksjonens hovedvaluta. Ikke NULL';
comment on column "transaksjoner" .bilagsnummer is 'Bilagsnummer fra eksternt dokument (faktura, kvittering). Ikke NULL';
comment on column "transaksjoner" .bilagsdato is ' Datoen på det eksterne dokumentet';
comment on column "transaksjoner" .posteringsdato is ' Datoen transaksjonen skal regnskapsføres på. Ikke NULL. Standardverdien skal være tidspunktet for innsetting/oppdatering av raden';
comment on column "transaksjoner" .registreringsdato 
is 'Tidspunktet transaksjonen ble registrert i systemet. Ikke NULL. Standardverdien skal være tidspunktet for innsetting/oppdatering av raden';
COMMENT ON COLUMN "transaksjoner".kilde 
IS 'Hvordan transaksjonen ble opprettet: `manuell`, `import`, `planlagt`. Standardverdien skal være ''manuell''. Sjekk at verdien er en av ''manuell'', ''import'', ''planlagt''.';
comment on column "transaksjoner" .periode_guid is ' Fremmednøkkel til `Regnskapsperioder`. Ikke NULL.';





CREATE TABLE Posteringer (
    guid char(32) PRIMARY KEY,
    transaksjon_guid char(32) NOT NULL,
    konto_guid char(32) NOT NULL,
    tekst text,
    handling text,
    avstemmingsstatus TEXT NOT NULL CHECK(avstemmingsstatus IN('n','c','y')) DEFAULT 'n',
    avstemmingsdato date,
    belop_teller BIGINT NOT NULL,
    belop_nevner BIGINT NOT NULL DEFAULT 100 CHECK(belop_nevner>0),
    antall_teller BIGINT NOT NULL DEFAULT 0,
    antall_nevner BIGINT NOT NULL DEFAULT 1 CHECK(antall_nevner>0),
    lot_guid char(32),
    FOREIGN KEY (transaksjon_guid) REFERENCES Transaksjoner(guid) ON DELETE CASCADE,
    FOREIGN KEY (konto_guid) REFERENCES Kontoer(guid) ON DELETE RESTRICT
);
COMMENT ON TABLE "posteringer" is 'Hjertet i dobbelt bokholderi. Hver postering representerer én linje på én konto i en transaksjon.
'; 
comment on column "posteringer" .guid is ' Unik identifikator. Primærnøkkel';
comment on column "posteringer" .transaksjon_guid is 'Fremmednøkkel til `Transaksjoner`. Ikke NULL.|';
comment on column "posteringer" .konto_guid is 'Fremmednøkkel til `Kontoer`. Ikke NULL.';
comment on column "posteringer" .tekst is ' Notat spesifikt for denne posteringslinjen';
comment on column "posteringer" .handling is 'Handlingstype, f.eks. `Kjøp`, `Salg`, `Lønn`. ';
COMMENT ON COLUMN "posteringer".avstemmingsstatus 
IS 'n (ikke avstemt), `c` (klarert), `y` (avstemt mot bank). Ikke NULL. Standardverdien skal være ''n''. Sjekk at verdien er en av ''n'', ''c'', ''y''.';
comment on column "posteringer" .avstemmingsdato is 'Dato for bankavstemming.',
comment on column "posteringer" .belop_teller is 'Beløp i transaksjonens valuta (teller). Positivt = debet, negativt = kredit. Ikke NULL.|';
comment on column "posteringer" .belop_nevner is ' Nevner for beløpet. Ikke NULL. Standardverdi 100. Sjekk at verdien er større enn 0.';
comment on column "posteringer" .antall_teller is 'Antall enheter (for aksjer/varer). Ikke NULL. Standardverdien skal være 0.|';
comment on column "posteringer" .antall_nevner is ' Nevner for antall. Ikke NULL. Standardverdien skal være 1. Sjekk at verdrien er større enn 0';
comment on column "posteringer" .lot_guid is 'Fremmednøkkel til `Lot` (for verdipapirer)';








create table Regnskapsperioder(
    guid char(32) primary key,
    bok_guid char(32) not null,
    navn text not null,
    fra_dato date not null,
    til_dato date not null,
    status text check(status in ('AAPEN','LUKKET','LAAST')) default 'AAPEN',
    foreign key (bok_guid) references Bøker(guid) on delete restrict
);
COMMENT ON TABLE "regnskapsperioder" is 'Definerer regnskapsperioder (typisk måneder) og deres status.';
comment on column "regnskapsperioder".guid is ' Unik identifikator. Primærnøkkel';
comment on column "regnskapsperioder".bok_guid is ' Fremmednøkkel til `Bøker`. Ikke NULL.';
comment on column "regnskapsperioder".navn is ' Navn på perioden, f.eks. `Januar 2026`. Ikke NULL.';
comment on column "regnskapsperioder".fra_dato is 'Periodens startdato. Ikke NULL';
comment on column "regnskapsperioder".til_dato is ' Periodens sluttdato. Ikke NULL';
COMMENT ON COLUMN "regnskapsperioder".status 
IS 'TEXT | `AAPEN`, `LUKKET`, `LAAST`. Styrer hvor posteringer kan gjøres. Ikke NULL. Standardverdien skal være ''AAPEN''. Sjekk at verdien er en av `AAPEN`, `LUKKET`, `LAAST`.';






create table MVA_koder(
     guid char(32) primary key,
     kode text not null unique,
     navn text not null ,
     type text not null check(type in('UTGAAENDE','INNGAAENDE','INGEN')) default 'INGEN',
     sats_teller BIGINT not null,
     sats_nevner BIGINT default 100 check(sats_nevner>0),
     mva_konto_guid char(32) not null,
     aktiv INTEGER not null default 1 check(aktiv in(0,1)),
     foreign key (mva_konto_guid) references kontoer(guid) on delete restrict
);
COMMENT ON TABLE "mva_koder" is 'Definerer de ulike MVA-kodene og -satsene som brukes i Norge';
comment on column "mva_koder".guid is 'Unik identifikator. Primærnøkkel. ';
comment on column "mva_koder".kode is 'TEXT | Standard MVA-kode, f.eks. `1`, `11`, `31`. Ikke NULL og unik.';
COMMENT ON COLUMN "mva_koder".type 
IS '`UTGAAENDE`, `INNGAAENDE`, `INGEN`. Ikke NULL. Sjekk for at verdien er en av ''UTGAAENDE'', ''INNGAAENDE'', ''INGEN''.';
comment on column "mva_koder".sats_teller is ' Sats i prosent (teller). Ikke NULL.|';
comment on column "mva_koder".sats_nevner is ' Nevner (alltid 100 for prosent). Standardverdien skal være 100. Sjekk at verdien er større enn 0.|';
comment on column "mva_koder".mva_konto_guid is ' Fremmednøkkel til `Kontoer`: kontoen MVA-beløpet skal posteres på. Ikke NULL.|';
comment on column "mva_koder".aktiv is 'Boolsk flagg (1/0): om koden er i aktiv bruk. Ikke NULL. Standardverdien skal være TRUE|';












ALTER TABLE "kontoer"
ADD CONSTRAINT fk_mva_kode
FOREIGN KEY (mva_kode_guid)
REFERENCES "mva_koder"(guid)
ON DELETE RESTRICT;


CREATE TABLE mva_linjer (
    guid char(32) PRIMARY KEY,
    transaksjon_guid char(32) NOT NULL,
    mva_kode_guid char(32) NOT NULL,
    grunnlag_teller BIGINT NOT NULL,
    grunnlag_nevner BIGINT NOT NULL DEFAULT 100 CHECK(grunnlag_nevner>0),
    mva_belop_teller BIGINT NOT NULL,
    mva_belop_nevner BIGINT NOT NULL DEFAULT 100 CHECK(mva_belop_nevner>0),
    FOREIGN KEY (transaksjon_guid) REFERENCES Transaksjoner(guid) ON DELETE CASCADE,
    FOREIGN KEY (mva_kode_guid) REFERENCES MVA_koder(guid) ON DELETE RESTRICT
);
COMMENT ON TABLE "mva_linjer" is 'Lagrer beregnet MVA-grunnlag og -beløp for hver transaksjon';
comment on column "mva_linjer".guid is ' Unik identifikator. Primærnøkkel. |';

comment on column "mva_linjer".transaksjon_guid is ' Fremmednøkkel til `Transaksjoner`. Ikke NULL.|';
comment on column "mva_linjer".mva_kode_guid is 'Fremmednøkkel til `MVA-koder`. Ikke NULL.|';
comment on column "mva_linjer".grunnlag_teller is ' MVA-grunnlaget (beløpet MVA beregnes av). Ikke NULL.';
comment on column "mva_linjer".grunnlag_nevner is ' Nevner for grunnlaget. Ikke NULL. Standardverdien er 100. Sjekk at verdien er større enn 0.|';
comment on column "mva_linjer".mva_belop_teller is ' Det beregnede MVA-beløpet. Ikke NULL.|';
comment on column "mva_linjer".mva_belop_nevner is ' Nevner for MVA-beløpet. Ikke NULL. Standardverdien er 100. Sjekk at verdien er større enn 0.';







create table Lot(
    guid char(32) primary key,
    konto_guid char(32),
    beskrivelse text,
    er_lukket INTEGER check(er_lukket in(1,0)),
    foreign key (konto_guid) references Kontoer(guid) on delete restrict
);
COMMENT ON TABLE "lot" is 'Brukes til å gruppere kjøps- og salgstransaksjoner for verdipapirer for å beregne realisert gevinst/tap.';
comment on column "lot".guid is 'Unik identifikator. Primærnøkkel. |';
comment on column "lot".konto_guid is ' Fremmednøkkel til `Kontoer` (en verdipapirkonto)';
comment on column "lot".beskrivelse is 'Valgfri beskrivelse av lottet. |';
comment on column "lot".er_lukket is ' Boolsk flagg (1/0): om alle enhetene i lottet er solgt';





create table Budsjetter(
    guid char(32) primary key,
    bok_guid char (32),
    navn text,
    beskrivelse text,
    antall_perioder INTEGER,
    foreign key (bok_guid) references bøker(guid) on delete restrict
);
COMMENT ON TABLE "budsjetter" is 'Toppnivå-entitet for budsjettering.';
comment on column "budsjetter".guid is 'Unik identifikator. Primærnøkkel. |';
comment on column "budsjetter".bok_guid is 'Fremmednøkkel til `Bøker`. |';
comment on column "budsjetter".navn is ' Navn på budsjettet, f.eks. `Årsbudsjett 2026`. |';
comment on column "budsjetter".antall_perioder is 'Antall perioder i budsjettet (f.eks. 12 for et årsbudsjett). |
';



create table Budsjettlinjer(
    id serial primary key,
    budsjett_guid char(32) not null,
    konto_guid char(32) not null,
    periode_nr INTEGER,
    belop_teller BIGINT,
    belop_nevner BIGINT,
   FOREIGN KEY (budsjett_guid) REFERENCES Budsjetter(guid) ON DELETE CASCADE,
    foreign key(konto_guid) references Kontoer(guid) on delete restrict
);
COMMENT ON TABLE "budsjettlinjer" is 'Inneholder de faktiske budsjetterte beløpene per konto per periode.
';
comment on column "budsjettlinjer".id is ' Auto-inkrementerende primærnøkkel. |';
comment on column "budsjettlinjer".budsjett_guid is 'Fremmednøkkel til `Budsjetter`. |';
comment on column "budsjettlinjer".konto_guid is ' Fremmednøkkel til `Kontoer`. |';
comment on column "budsjettlinjer".periode_nr is ' Periodenummer (f.eks. 1 for januar, 12 for desember). |';
comment on column "budsjettlinjer".belop_teller is ' Budsjettert beløp (teller).';
comment on column "budsjettlinjer".belop_nevner is ' Nevner for beløpet';











-----f;dv---
create table Planlagte_Transaksjoner(
    guid char(32) primary key,
    bok_guid char(32) not null,
    navn text,
    aktiv INTEGER check(aktiv in (1,0)),
    startdato date,
    sluttdato date,
    gjentakelse_type text check(gjentakelse_type in('MAANED','UKE','DAG','AAR')),
    gjentakelse_mult INTEGER,
    auto_opprett INTEGER check(auto_opprett in(1,0)),
    sist_opprettet date,
    foreign key (bok_guid) references bøker(guid) on delete restrict
); 
COMMENT ON TABLE planlagte_transaksjoner 
IS 'Maler for gjentakende transaksjoner som husleie, lønn eller faste avdrag.';
comment on column "planlagte_transaksjoner".guid is ' Unik identifikator. Primærnøkkel. |';
comment on column "planlagte_transaksjoner".bok_guid is ' Fremmednøkkel til `Bøker`. |';
comment on column "planlagte_transaksjoner".navn is ' Navn på den planlagte transaksjonen. |';
comment on column "planlagte_transaksjoner".aktiv is ' Boolsk flagg (1/0)';
comment on column "planlagte_transaksjoner".startdato is 'Dato for første forekomst. '; 
comment on column "planlagte_transaksjoner".sluttdato is ' Dato for siste forekomst (NULL for evigvarende). ';
comment on column "planlagte_transaksjoner".gjentakelse_type is '`MAANED`, `UKE`, `DAG`, `AAR`.';
comment on column "planlagte_transaksjoner".gjentakelse_mult is 'Multiplikator (f.eks. 2 for annenhver måned).';
comment on column "planlagte_transaksjoner".auto_opprett is 'Boolsk flagg (1/0): om transaksjonen skal opprettes automatisk. ';
comment on column "planlagte_transaksjoner".sist_opprettet is ' Dato for siste gang transaksjonen ble generert.';



ALTER TABLE "transaksjoner"
ADD CONSTRAINT periode_guid
FOREIGN KEY (periode_guid)
REFERENCES "regnskapsperioder"(guid)
ON DELETE RESTRICT;
-----
create table kunder(
    guid char(32) primary key,
    bok_guid char(32) not null,
    kundenummer text unique not null,
    navn text,
    organisasjonsnr text,
    adresse text,
    epost text,
    valuta_guid char(32) not null,
    betalingsbetingelse_guid char(32) not null,
    mva_kode_guid char(32) not null,
    aktiv INTEGER check(aktiv in(1,0)),
    foreign key(bok_guid) references bøker(guid)on delete restrict,
    foreign key(valuta_guid) references Valutaer(guid) on delete restrict,
    foreign key (mva_kode_guid) references MVA_koder(guid)on delete restrict
);
COMMENT ON TABLE kunder 
IS 'Register over virksomhetens kunder.';
comment on column "kunder".guid is ' Unik identifikator. Primærnøkkel. ';
comment on column "kunder".bok_guid is ' Fremmednøkkel til `Bøker`.  ';
comment on column "kunder".kundenummer is '  Internt, unikt kundenummer. .  ';
comment on column "kunder".organisasjonsnr is '   Kundens organisasjonsnummer (hvis bedrift) .  ';
comment on column "kunder".valuta_guid is '    Fremmednøkkel til `Valutaer`: foretrukket fakturavaluta.';
comment on column "kunder".betalingsbetingelse_guid is ' Fremmednøkkel til `Betalingsbetingelser ';
comment on column "kunder".mva_kode_guid is ' Fremmednøkkel til `MVA-koder`: standard MVA-behandling for kunden.';
comment on column "kunder".aktiv is 'Boolsk flagg (1/0)';



create table Leverandører(
    guid char(32) primary key,
    bok_guid char(32) not null,
    leverandornummer text unique,
    navn text,
    organisasjonsnr text,
    adresse text,
    epost text,
    valuta_guid char(32) not null,
    betalingsbetingelse_guid char(32),
    aktiv INTEGER check(aktiv in(0,1)) default 0,
    foreign key(bok_guid) references bøker(guid) on delete restrict,
    foreign key(valuta_guid) references Valutaer(guid) on delete restrict
);
COMMENT ON TABLE leverandører 
IS 'Register over virksomhetens leverandører.';
comment on column "leverandører".guid is ' Unik identifikator. Primærnøkkel. ';
comment on column "leverandører".bok_guid is '   Fremmednøkkel til `Bøker`. |  ';
comment on column "leverandører".leverandornummer is ' Internt, unikt leverandørnummer.';
comment on column "leverandører".organisasjonsnr is ' Leverandørens organisasjonsnummer';
comment on column "leverandører".valuta_guid is 'Fremmednøkkel til `Valutaer`: foretrukket betalingsvaluta';
comment on column "leverandører".betalingsbetingelse_guid is 'Fremmednøkkel til `Betalingsbetingelser';







create table Fakturaer(
    guid char(32) primary key,
    bok_guid char(32) not null,
    fakturanummer text,
    type text check(type in('SALG','KJOP','UTGIFT')),
    kunde_guid char(32) not null,
    leverandor_guid char(32)not null,
    valuta_guid char(32)not null,
    fakturadato date,
    forfallsdato date,
    posteringsdato TIMESTAMP,
    status text check(status in('UTKAST','SENDT','BETALT','KREDITERT')) not null,
    betalingsbetingelse_guid char(32) not null,
    transaksjon_guid CHAR(32) not null,
    foreign key (bok_guid)references bøker(guid) on delete restrict,
    foreign key (kunde_guid)references Kunder(guid)on delete restrict,
    foreign key (leverandor_guid)references Leverandører(guid)on delete restrict,
    foreign key(valuta_guid)references Valutaer(guid) on delete restrict,
    foreign key(transaksjon_guid) references Transaksjoner(guid)on delete restrict
);
COMMENT ON TABLE fakturaer 
is 'Representerer salgsfakturaer, inngående fakturaer og utgiftsbilag.';
comment on column "fakturaer".guid is 'Unik identifikator. Primærnøkkel.';
comment on column "fakturaer".bok_guid is ' Fremmednøkkel til `Bøker`.';
comment on column "fakturaer".fakturanummer is ' Eksternt fakturanummer (unikt per leverandør/salg).';
comment on column "fakturaer".type is '`SALG`, `KJOP`, `UTGIFT`';
comment on column "fakturaer".kunde_guid is ' Fremmednøkkel til `Kunder` (for salgsfakturaer)';
comment on column "fakturaer".leverandor_guid is 'Fremmednøkkel til `Leverandører` (for kjøpsfakturaer)';
comment on column "fakturaer".valuta_guid is 'Fremmednøkkel til `Valutaer`. ';
comment on column "fakturaer".fakturadato is ' Datoen på fakturaen';
comment on column "fakturaer".forfallsdato is 'Betalingsfrist';
comment on column "fakturaer".posteringsdato is 'Dato fakturaen ble bokført.';
comment on column "fakturaer".status is ' `UTKAST`, `SENDT`, `BETALT`, `KREDITERT`';
comment on column "fakturaer".betalingsbetingelse_guid is 'Fremmednøkkel til `Betalingsbetingelser`';
comment on column "fakturaer".transaksjon_guid is ' Fremmednøkkel til `Transaksjoner` (kobler til betalingstransaksjonen)';




create table Fakturalinjer(
    guid char(32) primary key,
    faktura_guid CHAR(32) not null,
    beskrivelse text,
    antall_teller BIGINT,
    antall_nevner BIGINT default 100 check(antall_nevner>0),
    enhetspris_teller BIGINT,
    enhetspris_nevner BIGINT default 100 check(enhetspris_nevner>0),
    inntekt_konto_guid CHAR(32) not null,
    kostnad_konto_guid CHAR(32) not null,
    mva_kode_guid CHAR(32) not null,
    mva_inkludert INTEGER check(mva_inkludert in(1,0)),
    rabatt_teller BIGINT,
    rabatt_nevner BIGINT default 100 check(rabatt_nevner>0),
    foreign key (faktura_guid)references Fakturaer(guid)on delete CASCADE ,
    foreign key(inntekt_konto_guid) references Kontoer (guid)on delete restrict,
    foreign key(kostnad_konto_guid) references Kontoer (guid)on delete restrict,
     foreign key(mva_kode_guid) references MVA_koder (guid)on delete restrict
);
COMMENT ON TABLE fakturalinjer 
is 'Representerer én linje på en faktura.';
comment on column "fakturalinjer".guid is ' Unik identifikator. Primærnøkkel.';
comment on column "fakturalinjer".faktura_guid is ' Fremmednøkkel til `Fakturaer`';
comment on column "fakturalinjer".beskrivelse is ' Varetekst eller tjenestebeskrivelse. ';
comment on column "fakturalinjer".antall_teller is ' Antall enheter (teller).';
comment on column "fakturalinjer".antall_nevner is ' Nevner for antall';
comment on column "fakturalinjer".enhetspris_teller is ' Pris per enhet (teller).';
comment on column "fakturalinjer".enhetspris_nevner is '  Nevner for enhetspris';
comment on column "fakturalinjer".inntekt_konto_guid is '   Fremmednøkkel til `Kontoer` (en inntektskonto i klasse 3).';
comment on column "fakturalinjer".kostnad_konto_guid is 'Fremmednøkkel til `Kontoer` (en kostnadskonto i klasse 4-7';
comment on column "fakturalinjer".mva_kode_guid is ' Fremmednøkkel til `MVA-koder`.';
comment on column "fakturalinjer".mva_inkludert is '  Boolsk flagg (1/0): om enhetsprisen er oppgitt inkludert MVA.';
comment on column "fakturalinjer".rabatt_teller is ' Rabatt i prosent (teller).';
comment on column "fakturalinjer".rabatt_nevner is '  Nevner for rabatt.';


create table Betalingsbetingelser(
    guid char(32) primary key,
    navn text,
    type text check(type in('DAGER','PROXIMO')),
    forfallsdager INTEGER,
    kontantrabatt_dager INTEGER,
    rabatt_teller BIGINT,
    rabatt_nevner BIGINT default 100 check(rabatt_nevner>0)
);
COMMENT ON TABLE betalingsbetingelser 
is 'Definerer betalingsbetingelser som kan gjenbrukes på tvers av kunder, leverandører og fakturaer.';
comment on column "betalingsbetingelser".guid is 'Unik identifikator. Primærnøkkel.';
comment on column "betalingsbetingelser".type is ' `DAGER` (antall dager) eller `PROXIMO` (fast dag i måneden).';
comment on column "betalingsbetingelser".forfallsdager is ' Antall dager til forfall.';
comment on column "betalingsbetingelser".kontantrabatt_dager is ' Antall dager for å oppnå kontantrabatt.';
comment on column "betalingsbetingelser".rabatt_teller is 'Kontantrabatt i prosent (teller).';
comment on column "betalingsbetingelser".rabatt_nevner is ' Nevner for rabatt.';


ALTER TABLE "fakturaer"
ADD CONSTRAINT betalingsbetingelse_guid
FOREIGN KEY (betalingsbetingelse_guid)
REFERENCES "betalingsbetingelser"(guid)
ON DELETE RESTRICT;


ALTER TABLE "leverandører"
ADD CONSTRAINT betalingsbetingelse_guid
FOREIGN KEY (betalingsbetingelse_guid)
REFERENCES "betalingsbetingelser"(guid)
ON DELETE RESTRICT;


ALTER TABLE "kunder"
ADD CONSTRAINT betalingsbetingelse_guid
FOREIGN KEY (betalingsbetingelse_guid)
REFERENCES "betalingsbetingelser"(guid)
ON DELETE RESTRICT;




CREATE INDEX idx_kontoer_bok_guid ON "kontoer"(bok_guid);
create index idx_kontoer_kontonummer on kontoer(kontonummer);
create index idx_kontoer_overordnet_guid on kontoer(overordnet_guid);
create index idx_mva_linjer_transaksjon_guid on  MVA_linjer (transaksjon_guid);
create index idx_posteringer_konto_guid on  Posteringer (konto_guid);
create index idx_posteringer_transaksjon_guid on  Posteringer (transaksjon_guid);
create index idx_transaksjoner_bok_guid on  Transaksjoner (bok_guid);
create index idx_transaksjoner_periode_guid on  Transaksjoner (periode_guid);
create index idx_transaksjoner_posteringsdato on  Transaksjoner (posteringsdato);