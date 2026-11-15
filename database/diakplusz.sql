-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2026. Nov 09. 11:12
-- Kiszolgáló verziója: 10.11.16-MariaDB
-- PHP verzió: 8.3.36

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `diakplusz`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `adatkezelesi_kerelmek`
--

CREATE TABLE `adatkezelesi_kerelmek` (
  `kerelem_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `tipus` varchar(40) NOT NULL COMMENT 'TORLES, EXPORT, HELYESBITES',
  `statusz` varchar(40) NOT NULL COMMENT 'NYITOTT, FOLYAMATBAN, LEZARVA',
  `benyujtva` datetime NOT NULL,
  `lezarva` datetime DEFAULT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `adatkezelesi_kerelmek`
--

INSERT INTO `adatkezelesi_kerelmek` (`kerelem_id`, `felhasznalo_id`, `tipus`, `statusz`, `benyujtva`, `lezarva`, `letrehozva`) VALUES
(1, 1, 'EXPORT', 'FOLYAMATBAN', '2026-06-03 10:15:00', NULL, '2026-11-05 12:11:27'),
(2, 2, 'HELYESBITES', 'LEZARVA', '2026-04-10 14:20:00', '2026-04-11 09:30:00', '2026-11-05 12:11:27'),
(3, 2, 'TORLES', 'NYITOTT', '2026-06-04 16:45:00', NULL, '2026-11-05 12:11:27');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `audit_naplo`
--

CREATE TABLE `audit_naplo` (
  `naplo_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'FK-cél következtetve a mezőnévből',
  `muvelet` varchar(40) NOT NULL,
  `tabla_nev` varchar(120) NOT NULL,
  `rekord_id` int(10) UNSIGNED NOT NULL,
  `ip_cim` varchar(45) NOT NULL,
  `idopont` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `audit_naplo`
--

INSERT INTO `audit_naplo` (`naplo_id`, `felhasznalo_id`, `muvelet`, `tabla_nev`, `rekord_id`, `ip_cim`, `idopont`, `letrehozva`) VALUES
(1, 1, 'BEJELENKEZÉS', 'felhasznalo_munkamenetek', 1, '192.168.1.15', '2026-06-01 14:22:10', '2026-11-05 12:14:28'),
(2, 2, 'INSERT', 'adatkezelési_kerelmek', 2, '172.16.254.1', '2026-04-10 14:20:00', '2026-11-05 12:14:28'),
(3, NULL, 'JELSZO_VISSZAALLITAS_KERELEM', 'jelszo_visszaallitas', 1, '10.0.0.5', '2026-06-05 15:55:00', '2026-11-05 12:14:28');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `csomagok`
--

CREATE TABLE `csomagok` (
  `csomag_id` int(10) UNSIGNED NOT NULL,
  `csomag_kod` varchar(100) NOT NULL COMMENT '''INGYENES'', ''PREMIUM''',
  `csomag_nev` varchar(120) NOT NULL,
  `ar` decimal(12,2) NOT NULL,
  `penznem` char(3) NOT NULL COMMENT 'HUF / EUR',
  `szamlazasi_periodus` varchar(40) NOT NULL COMMENT 'HAVI, EVES',
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `csomagok`
--

INSERT INTO `csomagok` (`csomag_id`, `csomag_kod`, `csomag_nev`, `ar`, `penznem`, `szamlazasi_periodus`, `aktiv`, `letrehozva`) VALUES
(1, 'INGYENES', 'Ingyenes Alapcsomag', 0.00, 'HUF', 'HAVI', 1, '2026-11-09 09:20:04'),
(2, 'PREMIUM', 'Prémium Havi Csomag', 2990.00, 'HUF', 'HAVI', 1, '2026-11-09 09:20:04');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `csomag_funkciok`
--

CREATE TABLE `csomag_funkciok` (
  `id` int(10) UNSIGNED NOT NULL,
  `csomag_id` int(10) UNSIGNED NOT NULL,
  `funkcio_id` int(10) UNSIGNED NOT NULL,
  `korlat_ertek` int(10) UNSIGNED DEFAULT NULL COMMENT 'pl. napi 3 kvíz ingyenesen, NULL = korlátlan',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `elofizetesek`
--

CREATE TABLE `elofizetesek` (
  `elofizetes_id` int(10) UNSIGNED NOT NULL,
  `elofizeto_id` int(10) UNSIGNED NOT NULL,
  `csomag_id` int(10) UNSIGNED NOT NULL,
  `kulso_elofizetes_id` varchar(255) NOT NULL COMMENT 'szolgáltatói előfizetés-azonosító',
  `kezdet_datuma` date NOT NULL,
  `lejarat_datuma` datetime NOT NULL,
  `automatikus_megujitas` tinyint(1) NOT NULL DEFAULT 0,
  `statusz` varchar(40) NOT NULL COMMENT 'ACTIVE, PAST_DUE, CANCELLED, EXPIRED',
  `lemondas_datuma` datetime DEFAULT NULL,
  `lemondas_oka` varchar(100) DEFAULT NULL,
  `hozzaferes_vege` datetime DEFAULT NULL COMMENT 'lemondás után a kifizetett időszak végéig él',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `elofizetesek`
--

INSERT INTO `elofizetesek` (`elofizetes_id`, `elofizeto_id`, `csomag_id`, `kulso_elofizetes_id`, `kezdet_datuma`, `lejarat_datuma`, `automatikus_megujitas`, `statusz`, `lemondas_datuma`, `lemondas_oka`, `hozzaferes_vege`, `letrehozva`) VALUES
(1, 3, 1, 'sub_free_annakovacs123', '2026-01-01', '2026-12-31 23:59:59', 0, 'ACTIVE', NULL, NULL, NULL, '2026-11-09 09:42:37'),
(2, 4, 2, 'sub_stripe_nagypeter987', '2026-06-01', '2026-07-01 00:00:00', 1, 'ACTIVE', NULL, NULL, NULL, '2026-11-09 09:42:37'),
(5, 3, 1, 'sub_free_annakovacs123', '2026-01-01', '2026-12-31 23:59:59', 0, 'ACTIVE', NULL, NULL, NULL, '2026-11-09 09:48:36'),
(6, 4, 2, 'sub_stripe_nagypeter987', '2026-06-01', '2026-07-01 00:00:00', 1, 'ACTIVE', NULL, NULL, NULL, '2026-11-09 09:48:36');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `elofizetok`
--

CREATE TABLE `elofizetok` (
  `elofizeto_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `szamlazasi_nev` varchar(120) NOT NULL,
  `szamlazasi_iranyitoszam` varchar(12) NOT NULL,
  `szamlazasi_varos` varchar(100) NOT NULL,
  `szamlazasi_utca_hazszam` varchar(180) NOT NULL,
  `adoszam` varchar(100) DEFAULT NULL,
  `kulso_ugyfel_id` varchar(255) NOT NULL COMMENT 'Stripe/Barion customer azonosító',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `elofizetok`
--

INSERT INTO `elofizetok` (`elofizeto_id`, `felhasznalo_id`, `szamlazasi_nev`, `szamlazasi_iranyitoszam`, `szamlazasi_varos`, `szamlazasi_utca_hazszam`, `adoszam`, `kulso_ugyfel_id`, `letrehozva`) VALUES
(3, 1, 'Kovács Anna', '1051', 'Budapest', 'Fő utca 1.', NULL, 'cus_stripe_abc12345', '2026-11-09 09:40:21'),
(4, 2, 'Nagy Péter E.V.', '4028', 'Debrecen', 'Nagyerdei körút 12.', '12345678-1-42', 'cus_barion_xyz98765', '2026-11-09 09:40:21');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalok`
--

CREATE TABLE `felhasznalok` (
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `email_cim` varchar(254) NOT NULL,
  `email_megerositve` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'regisztráció utáni e-mail megerősítés',
  `jelszo_hash` varchar(255) NOT NULL COMMENT 'Argon2id / bcrypt',
  `szuletesi_ido` date NOT NULL COMMENT 'korhatár-ellenőrzéshez szükséges',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `utolso_belepes` datetime NOT NULL,
  `regisztracio_datuma` datetime NOT NULL,
  `torolve_datuma` datetime DEFAULT NULL COMMENT 'soft delete / törlési kérelem végrehajtása',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `felhasznalok`
--

INSERT INTO `felhasznalok` (`felhasznalo_id`, `email_cim`, `email_megerositve`, `jelszo_hash`, `szuletesi_ido`, `is_active`, `utolso_belepes`, `regisztracio_datuma`, `torolve_datuma`, `letrehozva`) VALUES
(1, 'anna.kovacs@example.com', 1, '$2y$10$abcdefghijklmnopqrstuvwxYZ123456789', '1995-06-15', 1, '2026-06-01 10:30:00', '2026-05-10 14:20:00', NULL, '2026-11-05 11:14:21'),
(2, 'peter.nagy@example.com', 0, '$2y$10$zyxwvutsrqponmlkjihgfedcba987654321', '1988-11-22', 1, '2026-06-02 08:15:00', '2026-06-02 08:00:00', NULL, '2026-11-05 11:14:21');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalo_munkamenetek`
--

CREATE TABLE `felhasznalo_munkamenetek` (
  `session_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `refresh_token_hash` varchar(255) NOT NULL COMMENT 'NEM nyers token, hanem hash',
  `ip_cim` varchar(45) NOT NULL,
  `user_agent` varchar(512) NOT NULL,
  `lejarat_datuma` datetime NOT NULL,
  `visszavonva` tinyint(1) NOT NULL DEFAULT 0,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `felhasznalo_munkamenetek`
--

INSERT INTO `felhasznalo_munkamenetek` (`session_id`, `felhasznalo_id`, `refresh_token_hash`, `ip_cim`, `user_agent`, `lejarat_datuma`, `visszavonva`, `letrehozva`) VALUES
(1, 1, '$2y$10$tokenhashsamplefortestuser1xyz789', '192.168.1.105', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', '2026-12-05 12:00:00', 0, '2026-11-05 11:24:04'),
(2, 2, '$2y$10$tokenhashsamplefortestuser2abc456', '10.0.0.25', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1', '2026-11-20 18:30:00', 0, '2026-11-05 11:24:04');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `felhasznalo_szerepkor`
--

CREATE TABLE `felhasznalo_szerepkor` (
  `id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `szerepkor_id` int(10) UNSIGNED NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `felhasznalo_szerepkor`
--

INSERT INTO `felhasznalo_szerepkor` (`id`, `felhasznalo_id`, `szerepkor_id`, `letrehozva`) VALUES
(1, 1, 1, '2026-11-09 10:07:16'),
(2, 2, 3, '2026-11-09 10:07:16');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `fizetesi_tranzakciok`
--

CREATE TABLE `fizetesi_tranzakciok` (
  `tranzakcio_id` int(10) UNSIGNED NOT NULL,
  `elofizeto_id` int(10) UNSIGNED NOT NULL,
  `elofizetes_id` int(10) UNSIGNED DEFAULT NULL,
  `szolgaltato` varchar(40) NOT NULL COMMENT '''STRIPE'' vagy ''BARION''',
  `kulso_tranzakcio_id` varchar(255) NOT NULL,
  `osszeg` decimal(12,2) NOT NULL,
  `penznem` char(3) NOT NULL,
  `statusz` varchar(40) NOT NULL COMMENT 'SUCCESS, PENDING, FAILED, REFUNDED',
  `hibakod` varchar(100) DEFAULT NULL COMMENT 'sikertelen fizetés oka',
  `probalkozas_szama` int(10) UNSIGNED NOT NULL COMMENT 'újrapróbálkozások (dunning)',
  `kovetkezo_probalkozas` datetime DEFAULT NULL,
  `tranzakcio_datuma` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `fizetesi_tranzakciok`
--

INSERT INTO `fizetesi_tranzakciok` (`tranzakcio_id`, `elofizeto_id`, `elofizetes_id`, `szolgaltato`, `kulso_tranzakcio_id`, `osszeg`, `penznem`, `statusz`, `hibakod`, `probalkozas_szama`, `kovetkezo_probalkozas`, `tranzakcio_datuma`, `letrehozva`) VALUES
(3, 3, 1, 'STRIPE', 'tx_stripe_free_001', 0.00, 'HUF', 'SUCCESS', NULL, 1, NULL, '2026-01-01 10:00:00', '2026-11-09 09:54:16'),
(4, 4, 2, 'BARION', 'tx_barion_prem_992', 2990.00, 'HUF', 'SUCCESS', NULL, 1, NULL, '2026-06-01 12:15:00', '2026-11-09 09:54:16');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `fizetesi_webhook_naplo`
--

CREATE TABLE `fizetesi_webhook_naplo` (
  `esemeny_id` int(10) UNSIGNED NOT NULL,
  `szolgaltato` varchar(40) NOT NULL,
  `kulso_esemeny_id` varchar(255) NOT NULL,
  `esemeny_tipus` varchar(40) NOT NULL,
  `feldolgozva` tinyint(1) NOT NULL DEFAULT 0,
  `beerkezett` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `fizetesi_webhook_naplo`
--

INSERT INTO `fizetesi_webhook_naplo` (`esemeny_id`, `szolgaltato`, `kulso_esemeny_id`, `esemeny_tipus`, `feldolgozva`, `beerkezett`, `letrehozva`) VALUES
(1, 'STRIPE', 'evt_1Mox2A2eZvKYlo2C5vX12345', 'invoice.payment_succeeded', 1, '2026-06-01 12:14:50', '2026-11-09 09:59:05'),
(2, 'BARION', 'wh_barion_998877665544', 'PaymentSucceeded', 1, '2026-06-04 19:05:12', '2026-11-09 09:59:05');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `funkciok`
--

CREATE TABLE `funkciok` (
  `funkcio_id` int(10) UNSIGNED NOT NULL,
  `funkcio_kod` varchar(100) NOT NULL COMMENT 'pl. ''KORLATLAN_KVIZ'', ''AJANLASOK'', ''GAZDASAGI_KVIZ''',
  `leiras` text NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `funkciok`
--

INSERT INTO `funkciok` (`funkcio_id`, `funkcio_kod`, `leiras`, `letrehozva`) VALUES
(1, 'KORLATLAN_KVIZ', 'Korlátlan számú kvíz kitöltési lehetőség naponta, várakozási idő nélkül.', '2026-11-09 09:34:28'),
(2, 'AJANLASOK', 'Személyre szabott tanulási ajánlások és intelligens feladatválasztás az eddigi eredmények alapján.', '2026-11-09 09:34:28'),
(3, 'GAZDASAGI_KVIZ', 'Exkluzív hozzáférés a speciális gazdasági, adózási és pénzügyi ismeretterjesztő kvízekhez.', '2026-11-09 09:34:28');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `hozzajarulasok`
--

CREATE TABLE `hozzajarulasok` (
  `hozzajarulas_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `tipus` varchar(40) NOT NULL COMMENT 'ADATKEZELES, MARKETING, ELOFIZETES_ASZF',
  `verzio` varchar(100) NOT NULL COMMENT 'az elfogadott szöveg verziója',
  `megadva` tinyint(1) NOT NULL DEFAULT 0,
  `idopont` datetime NOT NULL,
  `visszavonas_idopontja` datetime DEFAULT NULL,
  `szuloi_megerosites_modja` varchar(100) DEFAULT NULL COMMENT 'kiskorúnál, pl. ''EMAIL_MEGEROSITES'' (nem felhasználó!)',
  `szuloi_megerosites_datuma` datetime DEFAULT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `hozzajarulasok`
--

INSERT INTO `hozzajarulasok` (`hozzajarulas_id`, `felhasznalo_id`, `tipus`, `verzio`, `megadva`, `idopont`, `visszavonas_idopontja`, `szuloi_megerosites_modja`, `szuloi_megerosites_datuma`, `letrehozva`) VALUES
(1, 1, 'ADATKEZELES', 'v1.2', 1, '2026-01-10 08:00:00', NULL, NULL, NULL, '2026-11-05 12:09:41'),
(2, 1, 'MARKETING', 'v2.0', 0, '2026-01-10 08:00:00', '2026-04-15 12:30:00', NULL, NULL, '2026-11-05 12:09:41'),
(3, 2, 'ELOFIZETES_ASZF', 'v1.0', 1, '2026-02-15 11:30:00', NULL, NULL, NULL, '2026-11-05 12:09:41');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `iskolak`
--

CREATE TABLE `iskolak` (
  `iskola_id` int(10) UNSIGNED NOT NULL,
  `iskola_nev` varchar(120) NOT NULL,
  `varos` varchar(100) NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `iskolak`
--

INSERT INTO `iskolak` (`iskola_id`, `iskola_nev`, `varos`, `letrehozva`) VALUES
(1, 'Budapesti Fazekas Mihály Gyakorló Általános Iskola és Gimnázium', 'Budapest', '2026-11-06 09:15:26'),
(2, 'Szegedi Radnóti Miklós Kísérleti Gimnázium', 'Szeged', '2026-11-06 09:15:26'),
(3, 'Debreceni Református Kollégium Gimnáziuma', 'Debrecen', '2026-11-06 09:15:26');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jelszo_visszaallitas`
--

CREATE TABLE `jelszo_visszaallitas` (
  `reset_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL COMMENT 'NEM nyers token, hanem hash',
  `felhasznalva` tinyint(1) NOT NULL DEFAULT 0,
  `lejarat_datuma` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `jelszo_visszaallitas`
--

INSERT INTO `jelszo_visszaallitas` (`reset_id`, `felhasznalo_id`, `token_hash`, `felhasznalva`, `lejarat_datuma`, `letrehozva`) VALUES
(1, 1, '$argon2id$v=19$m=65536,t=4,p=1$resettokenhash12345$abcdef1234567890abcdef1234567890', 0, '2026-06-05 16:00:00', '2026-11-05 12:03:06'),
(2, 2, '$argon2id$v=19$m=65536,t=4,p=1$resettokenhash67890$fedcba0987654321fedcba0987654321', 1, '2026-05-25 10:00:00', '2026-11-05 12:03:06');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jogosultsagok`
--

CREATE TABLE `jogosultsagok` (
  `jogosultsag_id` int(10) UNSIGNED NOT NULL,
  `jogosultsag_nev` varchar(120) NOT NULL COMMENT '''QUIZ_CREATE'', ''MANAGE_USERS'' + a blog jogosultságok (BLOG_* lista a 4. fejezetben)',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `jogosultsagok`
--

INSERT INTO `jogosultsagok` (`jogosultsag_id`, `jogosultsag_nev`, `letrehozva`) VALUES
(1, 'QUIZ_CREATE', '2026-11-09 10:06:44'),
(2, 'MANAGE_USERS', '2026-11-09 10:06:44'),
(3, 'BLOG_CREATE', '2026-11-09 10:06:44'),
(4, 'BLOG_EDIT', '2026-11-09 10:06:44');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kvizek`
--

CREATE TABLE `kvizek` (
  `kviz_id` int(10) UNSIGNED NOT NULL,
  `tantargy_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'gazdasági kvíznél lehet NULL',
  `tema_id` int(10) UNSIGNED DEFAULT NULL,
  `kviz_nev` varchar(120) NOT NULL,
  `leiras` text NOT NULL,
  `kviz_tipus` varchar(40) NOT NULL COMMENT 'ALTALANOS, GAZDASAGI',
  `kategoria` varchar(40) NOT NULL COMMENT 'pl. adók, kamat, bruttó-nettó bér',
  `nehezseg` int(10) UNSIGNED NOT NULL,
  `elerheto_csomag_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'ingyenes/fizetős szétválasztás',
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `kvizek`
--

INSERT INTO `kvizek` (`kviz_id`, `tantargy_id`, `tema_id`, `kviz_nev`, `leiras`, `kviz_tipus`, `kategoria`, `nehezseg`, `elerheto_csomag_id`, `aktiv`, `letrehozva`) VALUES
(1, 1, 1, 'Másodfokú egyenletek gyakorló kvíz', 'Teszteld a tudásodat a diszkriminánsról és a megoldóképlet helyes alkalmazásáról!', 'ALTALANOS', 'egyenletek', 2, NULL, 1, '2026-11-06 11:36:29'),
(2, NULL, NULL, 'Alapvető adók és a bruttó-nettó bér számítása', 'Gyakorlati pénzügyi ismeretek: SZJA, TB járulék és a nettó bér kalkulációja a mindennapokban.', 'GAZDASAGI', 'bruttó-nettó bér', 3, 1, 1, '2026-11-06 11:36:29');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kviz_kerdesek`
--

CREATE TABLE `kviz_kerdesek` (
  `kerdes_id` int(10) UNSIGNED NOT NULL,
  `kviz_id` int(10) UNSIGNED NOT NULL,
  `kerdes_szoveg` text NOT NULL,
  `kerdes_tipus` varchar(40) NOT NULL COMMENT 'EGY_VALASZ, TOBB_VALASZ, SZAMOLOS',
  `is_dynamic` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'dinamikus kalkulált feladat',
  `parameter_sablon` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'dinamikusnál: tartományok, képlet' CHECK (json_valid(`parameter_sablon`)),
  `pont` int(10) UNSIGNED NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `kviz_kerdesek`
--

INSERT INTO `kviz_kerdesek` (`kerdes_id`, `kviz_id`, `kerdes_szoveg`, `kerdes_tipus`, `is_dynamic`, `parameter_sablon`, `pont`, `letrehozva`) VALUES
(1, 1, 'Mennyi a gyöke a x^2 - 5x + 6 = 0 másodfokú egyenletnek?', 'EGY_VALASZ', 0, NULL, 5, '2026-11-06 11:38:05'),
(2, 1, 'Számítsd ki egy tetszőleges másodfokú egyenlet diszkriminánsát a megadott együtthatókkal!', 'SZAMOLOS', 1, '{\"min_a\": 1, \"max_a\": 5, \"min_b\": -10, \"max_b\": 10, \"formula\": \"b*b - 4*a*c\"}', 10, '2026-11-06 11:38:05'),
(3, 2, 'Melyek adómentes juttatások vagy kedvezmények Magyarországon? (Több válasz is helyes lehet)', 'TOBB_VALASZ', 0, NULL, 5, '2026-11-06 11:38:05');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kviz_probalkozasok`
--

CREATE TABLE `kviz_probalkozasok` (
  `probalkozas_id` int(10) UNSIGNED NOT NULL,
  `tanulo_id` int(10) UNSIGNED NOT NULL,
  `kviz_id` int(10) UNSIGNED NOT NULL,
  `elert_pontszam` int(10) UNSIGNED NOT NULL,
  `max_pontszam` int(10) UNSIGNED NOT NULL,
  `szazalek` decimal(5,2) NOT NULL,
  `kitoltes_datuma` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `kviz_probalkozasok`
--

INSERT INTO `kviz_probalkozasok` (`probalkozas_id`, `tanulo_id`, `kviz_id`, `elert_pontszam`, `max_pontszam`, `szazalek`, `kitoltes_datuma`, `letrehozva`) VALUES
(3, 3, 1, 15, 15, 100.00, '2026-06-03 15:30:00', '2026-11-06 12:42:56'),
(4, 4, 2, 5, 5, 100.00, '2026-06-04 18:45:00', '2026-11-06 12:42:56');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kviz_valaszok`
--

CREATE TABLE `kviz_valaszok` (
  `valasz_id` int(10) UNSIGNED NOT NULL,
  `kerdes_id` int(10) UNSIGNED NOT NULL,
  `valasz_szoveg` text NOT NULL,
  `helyes` tinyint(1) NOT NULL DEFAULT 0,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `kviz_valaszok`
--

INSERT INTO `kviz_valaszok` (`valasz_id`, `kerdes_id`, `valasz_szoveg`, `helyes`, `letrehozva`) VALUES
(1, 1, 'x = 2 és x = 3', 1, '2026-11-06 12:35:03'),
(2, 1, 'x = -2 és x = -3', 0, '2026-11-06 12:35:03'),
(3, 1, 'x = 1 és x = 6', 0, '2026-11-06 12:35:03'),
(4, 3, 'Bizonyos törvényben meghatározott adómentes juttatások és támogatások', 1, '2026-11-06 12:35:03'),
(5, 3, 'Korlátlan magáncélú céges luxusautó használat adómentesen', 0, '2026-11-06 12:35:03');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `nkp_tananyagok`
--

CREATE TABLE `nkp_tananyagok` (
  `nkp_id` int(10) UNSIGNED NOT NULL,
  `tantargy_id` int(10) UNSIGNED NOT NULL,
  `tema_id` int(10) UNSIGNED DEFAULT NULL,
  `cim` varchar(100) NOT NULL,
  `url` varchar(2048) NOT NULL,
  `forras_tipus` varchar(40) NOT NULL COMMENT 'LINK, BEAGYAZOTT, SAJAT_TARTALOM',
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `utolso_ellenorzes` datetime NOT NULL COMMENT 'törött linkek kiszűrése',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `nkp_tananyagok`
--

INSERT INTO `nkp_tananyagok` (`nkp_id`, `tantargy_id`, `tema_id`, `cim`, `url`, `forras_tipus`, `aktiv`, `utolso_ellenorzes`, `letrehozva`) VALUES
(1, 1, 1, 'Másodfokú egyenletek megoldása képlettel', 'https://www.nkp.hu/tankonyv/matematika_10/lecke_02_01', 'LINK', 1, '2026-06-01 10:00:00', '2026-11-06 10:25:01'),
(2, 3, 4, 'A trianoni békeszerződés gazdasági és társadalmi hatásai', 'https://www.nkp.hu/tankonyv/tortenelem_12/lecke_04_02', 'BEAGYAZOTT', 1, '2026-06-02 11:30:00', '2026-11-06 10:25:01'),
(3, 4, 5, 'Relációs adatbázisok és lekérdezések alapjai', 'https://www.nkp.hu/tankonyv/digitalis_kultura_12/lecke_05_01', 'SAJAT_TARTALOM', 1, '2026-06-03 09:15:00', '2026-11-06 10:25:01');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szerepkorok`
--

CREATE TABLE `szerepkorok` (
  `szerepkor_id` int(10) UNSIGNED NOT NULL,
  `szerepkor_nev` varchar(120) NOT NULL COMMENT '''DIAK'', ''SZERKESZTO'', ''ADMIN''  (nincs pedagógus és gondviselő szerepkör)',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `szerepkorok`
--

INSERT INTO `szerepkorok` (`szerepkor_id`, `szerepkor_nev`, `letrehozva`) VALUES
(1, 'DIAK', '2026-11-09 10:05:30'),
(2, 'SZERKESZTO', '2026-11-09 10:05:30'),
(3, 'ADMIN', '2026-11-09 10:05:30');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szerepkor_jogosultsag`
--

CREATE TABLE `szerepkor_jogosultsag` (
  `id` int(10) UNSIGNED NOT NULL,
  `szerepkor_id` int(10) UNSIGNED NOT NULL,
  `jogosultsag_id` int(10) UNSIGNED NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `szerepkor_jogosultsag`
--

INSERT INTO `szerepkor_jogosultsag` (`id`, `szerepkor_id`, `jogosultsag_id`, `letrehozva`) VALUES
(1, 1, 1, '2026-11-09 10:07:00'),
(2, 2, 3, '2026-11-09 10:07:00'),
(3, 2, 4, '2026-11-09 10:07:00'),
(4, 3, 1, '2026-11-09 10:07:00'),
(5, 3, 2, '2026-11-09 10:07:00'),
(6, 3, 3, '2026-11-09 10:07:00'),
(7, 3, 4, '2026-11-09 10:07:00');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szintek`
--

CREATE TABLE `szintek` (
  `szint_id` int(10) UNSIGNED NOT NULL,
  `szint_szam` int(10) UNSIGNED NOT NULL,
  `szukseges_xp` int(10) UNSIGNED NOT NULL COMMENT 'összesített XP-küszöb',
  `szint_nev` varchar(120) NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `szintek`
--

INSERT INTO `szintek` (`szint_id`, `szint_szam`, `szukseges_xp`, `szint_nev`, `letrehozva`) VALUES
(1, 1, 0, 'Kezdő Tanuló', '2026-11-09 09:09:39'),
(2, 2, 100, 'Haladó Hallgató', '2026-11-09 09:09:39'),
(3, 3, 300, 'Kiváló Elme', '2026-11-09 09:09:39'),
(4, 4, 600, 'Tudás Mestere', '2026-11-09 09:09:39');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tantargyak`
--

CREATE TABLE `tantargyak` (
  `tantargy_id` int(10) UNSIGNED NOT NULL,
  `tantargy_nev` varchar(120) NOT NULL,
  `evfolyam` int(10) UNSIGNED NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tantargyak`
--

INSERT INTO `tantargyak` (`tantargy_id`, `tantargy_nev`, `evfolyam`, `letrehozva`) VALUES
(1, 'Matematika', 10, '2026-11-06 10:21:11'),
(2, 'Magyar nyelv és irodalom', 10, '2026-11-06 10:21:11'),
(3, 'Történelem', 12, '2026-11-06 10:21:11'),
(4, 'Informatika / Digitális kultúra', 12, '2026-11-06 10:21:11');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tanulok`
--

CREATE TABLE `tanulok` (
  `tanulo_id` int(10) UNSIGNED NOT NULL,
  `felhasznalo_id` int(10) UNSIGNED NOT NULL COMMENT '1:1 kapcsolat',
  `megjelenitett_nev` varchar(120) NOT NULL COMMENT 'becenév is lehet (adattakarékosság)',
  `iskola_id` int(10) UNSIGNED DEFAULT NULL,
  `evfolyam` int(10) UNSIGNED NOT NULL,
  `osztaly_jelzes` varchar(12) DEFAULT NULL COMMENT 'pl. ''A''',
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tanulok`
--

INSERT INTO `tanulok` (`tanulo_id`, `felhasznalo_id`, `megjelenitett_nev`, `iskola_id`, `evfolyam`, `osztaly_jelzes`, `letrehozva`) VALUES
(3, 1, 'Ancsa92', 1, 10, 'A', '2026-11-06 10:18:53'),
(4, 2, 'Petike', 2, 12, 'B', '2026-11-06 10:18:53');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tanulokartyak`
--

CREATE TABLE `tanulokartyak` (
  `kartya_id` int(10) UNSIGNED NOT NULL,
  `csomag_id` int(10) UNSIGNED NOT NULL,
  `elolap` text NOT NULL,
  `hatlap` text NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tanulokartyak`
--

INSERT INTO `tanulokartyak` (`kartya_id`, `csomag_id`, `elolap`, `hatlap`, `letrehozva`) VALUES
(1, 1, 'Mi a másodfokú egyenlet megoldóképlete?', 'x = (-b ± √(b² - 4ac)) / (2a)', '2026-11-06 12:46:04'),
(2, 1, 'Hogyan számítjuk ki a diszkriminánst (D)?', 'D = b² - 4ac', '2026-11-06 12:46:04'),
(3, 2, 'Mi a Pitagorasz-tétel?', 'A derékszögű háromszögben a befogók négyzetének összege megegyezik az átfogó négyzetével: a² + b² = c².', '2026-11-06 12:46:04');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tanulokartya_csomagok`
--

CREATE TABLE `tanulokartya_csomagok` (
  `csomag_id` int(10) UNSIGNED NOT NULL,
  `tantargy_id` int(10) UNSIGNED NOT NULL,
  `tema_id` int(10) UNSIGNED DEFAULT NULL,
  `csomag_nev` varchar(120) NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tanulokartya_csomagok`
--

INSERT INTO `tanulokartya_csomagok` (`csomag_id`, `tantargy_id`, `tema_id`, `csomag_nev`, `letrehozva`) VALUES
(1, 1, 1, 'Másodfokú egyenletek gyakorló kártyák', '2026-11-06 12:44:27'),
(2, 1, NULL, 'Matematika fontosabb képletek és definíciók', '2026-11-06 12:44:27');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tanulokartya_haladas`
--

CREATE TABLE `tanulokartya_haladas` (
  `id` int(10) UNSIGNED NOT NULL,
  `tanulo_id` int(10) UNSIGNED NOT NULL,
  `kartya_id` int(10) UNSIGNED NOT NULL,
  `tudom_szint` int(10) UNSIGNED NOT NULL COMMENT 'pl. 0-5 (ismétlési ütemezéshez)',
  `utolso_ismetles` datetime NOT NULL,
  `kovetkezo_ismetles` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tanulokartya_haladas`
--

INSERT INTO `tanulokartya_haladas` (`id`, `tanulo_id`, `kartya_id`, `tudom_szint`, `utolso_ismetles`, `kovetkezo_ismetles`, `letrehozva`) VALUES
(4, 3, 1, 4, '2026-06-03 16:00:00', '2026-06-10 16:00:00', '2026-11-06 12:58:21'),
(5, 3, 2, 3, '2026-06-03 16:05:00', '2026-06-07 16:05:00', '2026-11-06 12:58:21'),
(6, 4, 3, 5, '2026-06-04 19:00:00', '2026-06-18 19:00:00', '2026-11-06 12:58:21');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tanulo_statisztika`
--

CREATE TABLE `tanulo_statisztika` (
  `tanulo_id` int(10) UNSIGNED NOT NULL,
  `osszes_xp` int(10) UNSIGNED NOT NULL COMMENT 'gyorsítótár – az xp_esemenyek összege',
  `szint_id` int(10) UNSIGNED NOT NULL,
  `aktualis_sorozat_nap` int(10) UNSIGNED NOT NULL COMMENT 'streak',
  `utolso_aktivitas` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tanulo_statisztika`
--

INSERT INTO `tanulo_statisztika` (`tanulo_id`, `osszes_xp`, `szint_id`, `aktualis_sorozat_nap`, `utolso_aktivitas`, `letrehozva`) VALUES
(3, 50, 1, 3, '2026-06-03 16:00:00', '2026-11-09 09:14:22'),
(4, 5, 1, 1, '2026-06-04 19:00:00', '2026-11-09 09:14:22');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tanulo_tantargy`
--

CREATE TABLE `tanulo_tantargy` (
  `kapcsolat_id` int(10) UNSIGNED NOT NULL,
  `tanulo_id` int(10) UNSIGNED NOT NULL,
  `tantargy_id` int(10) UNSIGNED NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `tanulo_tantargy`
--

INSERT INTO `tanulo_tantargy` (`kapcsolat_id`, `tanulo_id`, `tantargy_id`, `letrehozva`) VALUES
(5, 3, 1, '2026-11-06 11:23:02'),
(6, 3, 2, '2026-11-06 11:23:02'),
(7, 4, 3, '2026-11-06 11:23:02'),
(8, 4, 4, '2026-11-06 11:23:02');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `temak`
--

CREATE TABLE `temak` (
  `tema_id` int(10) UNSIGNED NOT NULL,
  `tantargy_id` int(10) UNSIGNED NOT NULL,
  `tema_nev` varchar(120) NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `temak`
--

INSERT INTO `temak` (`tema_id`, `tantargy_id`, `tema_nev`, `letrehozva`) VALUES
(1, 1, 'Másodfokú egyenletek', '2026-11-06 10:22:46'),
(2, 1, 'Trigonometria alapjai', '2026-11-06 10:22:46'),
(3, 2, 'A Nyugat első nemzedéke', '2026-11-06 10:22:46'),
(4, 3, 'A két világháború közötti Magyarország', '2026-11-06 10:22:46'),
(5, 4, 'Adatbázisok kezelése SQL nyelven', '2026-11-06 10:22:46');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `xp_esemenyek`
--

CREATE TABLE `xp_esemenyek` (
  `esemeny_id` int(10) UNSIGNED NOT NULL,
  `tanulo_id` int(10) UNSIGNED NOT NULL,
  `szabaly_id` int(10) UNSIGNED NOT NULL,
  `forras_tipus` varchar(40) NOT NULL COMMENT 'pl. ''KVIZ_PROBALKOZAS'', probalkozas_id',
  `forras_id` int(10) UNSIGNED NOT NULL COMMENT 'pl. ''KVIZ_PROBALKOZAS'', probalkozas_id',
  `xp_valtozas` int(11) NOT NULL,
  `idopont` datetime NOT NULL,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `xp_esemenyek`
--

INSERT INTO `xp_esemenyek` (`esemeny_id`, `tanulo_id`, `szabaly_id`, `forras_tipus`, `forras_id`, `xp_valtozas`, `idopont`, `letrehozva`) VALUES
(1, 3, 2, 'KVIZ_PROBALKOZAS', 1, 50, '2026-06-03 15:30:00', '2026-11-09 09:06:18'),
(2, 4, 3, 'KARTYA_HALADAS', 3, 5, '2026-06-04 19:00:00', '2026-11-09 09:06:18');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `xp_szabalyok`
--

CREATE TABLE `xp_szabalyok` (
  `szabaly_id` int(10) UNSIGNED NOT NULL,
  `esemeny_tipus` varchar(40) NOT NULL COMMENT 'KVIZ_BEFEJEZES, KARTYA_ISMETLES, NAPI_BELEPES...',
  `xp_ertek` int(10) UNSIGNED NOT NULL,
  `szorzo_szazalekfuggo` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'pl. XP = alap * szazalek/100',
  `napi_limit` int(10) UNSIGNED DEFAULT NULL COMMENT 'visszaélés ellen',
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `letrehozva` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `xp_szabalyok`
--

INSERT INTO `xp_szabalyok` (`szabaly_id`, `esemeny_tipus`, `xp_ertek`, `szorzo_szazalekfuggo`, `napi_limit`, `aktiv`, `letrehozva`) VALUES
(1, 'NAPI_BELEPES', 10, 0, 1, 1, '2026-11-09 09:03:48'),
(2, 'KVIZ_BEFEJEZES', 50, 1, 10, 1, '2026-11-09 09:03:48'),
(3, 'KARTYA_ISMETLES', 5, 0, 50, 1, '2026-11-09 09:03:48');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `adatkezelesi_kerelmek`
--
ALTER TABLE `adatkezelesi_kerelmek`
  ADD PRIMARY KEY (`kerelem_id`),
  ADD KEY `fk_adatkezelesi_kerelmek_felhasznalo_id` (`felhasznalo_id`);

--
-- A tábla indexei `audit_naplo`
--
ALTER TABLE `audit_naplo`
  ADD PRIMARY KEY (`naplo_id`),
  ADD KEY `fk_audit_naplo_felhasznalo_id` (`felhasznalo_id`);

--
-- A tábla indexei `csomagok`
--
ALTER TABLE `csomagok`
  ADD PRIMARY KEY (`csomag_id`),
  ADD UNIQUE KEY `uq_csomagok_csomag_kod` (`csomag_kod`);

--
-- A tábla indexei `csomag_funkciok`
--
ALTER TABLE `csomag_funkciok`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_csomag_funkciok_csomag_id` (`csomag_id`),
  ADD KEY `fk_csomag_funkciok_funkcio_id` (`funkcio_id`);

--
-- A tábla indexei `elofizetesek`
--
ALTER TABLE `elofizetesek`
  ADD PRIMARY KEY (`elofizetes_id`),
  ADD KEY `ix_elofizetesek_elofizeto_id_statusz` (`elofizeto_id`,`statusz`),
  ADD KEY `fk_elofizetesek_csomag_id` (`csomag_id`);

--
-- A tábla indexei `elofizetok`
--
ALTER TABLE `elofizetok`
  ADD PRIMARY KEY (`elofizeto_id`),
  ADD UNIQUE KEY `uq_elofizetok_felhasznalo_id` (`felhasznalo_id`);

--
-- A tábla indexei `felhasznalok`
--
ALTER TABLE `felhasznalok`
  ADD PRIMARY KEY (`felhasznalo_id`),
  ADD UNIQUE KEY `uq_felhasznalok_email_cim` (`email_cim`);

--
-- A tábla indexei `felhasznalo_munkamenetek`
--
ALTER TABLE `felhasznalo_munkamenetek`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `ix_felhasznalo_munkamenetek_felhasznalo_id_lejarat_datuma` (`felhasznalo_id`,`lejarat_datuma`);

--
-- A tábla indexei `felhasznalo_szerepkor`
--
ALTER TABLE `felhasznalo_szerepkor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_felhasznalo_szerepkor_1` (`felhasznalo_id`,`szerepkor_id`),
  ADD KEY `fk_felhasznalo_szerepkor_szerepkor_id` (`szerepkor_id`);

--
-- A tábla indexei `fizetesi_tranzakciok`
--
ALTER TABLE `fizetesi_tranzakciok`
  ADD PRIMARY KEY (`tranzakcio_id`),
  ADD UNIQUE KEY `uq_fizetesi_tranzakciok_kulso_tranzakcio_id` (`kulso_tranzakcio_id`),
  ADD KEY `fk_fizetesi_tranzakciok_elofizeto_id` (`elofizeto_id`),
  ADD KEY `fk_fizetesi_tranzakciok_elofizetes_id` (`elofizetes_id`);

--
-- A tábla indexei `fizetesi_webhook_naplo`
--
ALTER TABLE `fizetesi_webhook_naplo`
  ADD PRIMARY KEY (`esemeny_id`),
  ADD UNIQUE KEY `uq_fizetesi_webhook_naplo_kulso_esemeny_id` (`kulso_esemeny_id`);

--
-- A tábla indexei `funkciok`
--
ALTER TABLE `funkciok`
  ADD PRIMARY KEY (`funkcio_id`),
  ADD UNIQUE KEY `uq_funkciok_funkcio_kod` (`funkcio_kod`);

--
-- A tábla indexei `hozzajarulasok`
--
ALTER TABLE `hozzajarulasok`
  ADD PRIMARY KEY (`hozzajarulas_id`),
  ADD KEY `fk_hozzajarulasok_felhasznalo_id` (`felhasznalo_id`);

--
-- A tábla indexei `iskolak`
--
ALTER TABLE `iskolak`
  ADD PRIMARY KEY (`iskola_id`);

--
-- A tábla indexei `jelszo_visszaallitas`
--
ALTER TABLE `jelszo_visszaallitas`
  ADD PRIMARY KEY (`reset_id`),
  ADD KEY `fk_jelszo_visszaallitas_felhasznalo_id` (`felhasznalo_id`);

--
-- A tábla indexei `jogosultsagok`
--
ALTER TABLE `jogosultsagok`
  ADD PRIMARY KEY (`jogosultsag_id`),
  ADD UNIQUE KEY `uq_jogosultsagok_jogosultsag_nev` (`jogosultsag_nev`);

--
-- A tábla indexei `kvizek`
--
ALTER TABLE `kvizek`
  ADD PRIMARY KEY (`kviz_id`),
  ADD KEY `fk_kvizek_tantargy_id` (`tantargy_id`),
  ADD KEY `fk_kvizek_tema_id` (`tema_id`),
  ADD KEY `fk_kvizek_elerheto_csomag_id` (`elerheto_csomag_id`);

--
-- A tábla indexei `kviz_kerdesek`
--
ALTER TABLE `kviz_kerdesek`
  ADD PRIMARY KEY (`kerdes_id`),
  ADD KEY `fk_kviz_kerdesek_kviz_id` (`kviz_id`);

--
-- A tábla indexei `kviz_probalkozasok`
--
ALTER TABLE `kviz_probalkozasok`
  ADD PRIMARY KEY (`probalkozas_id`),
  ADD KEY `ix_kviz_probalkozasok_tanulo_id_kitoltes_datuma` (`tanulo_id`,`kitoltes_datuma`),
  ADD KEY `fk_kviz_probalkozasok_kviz_id` (`kviz_id`);

--
-- A tábla indexei `kviz_valaszok`
--
ALTER TABLE `kviz_valaszok`
  ADD PRIMARY KEY (`valasz_id`),
  ADD KEY `fk_kviz_valaszok_kerdes_id` (`kerdes_id`);

--
-- A tábla indexei `nkp_tananyagok`
--
ALTER TABLE `nkp_tananyagok`
  ADD PRIMARY KEY (`nkp_id`),
  ADD KEY `fk_nkp_tananyagok_tantargy_id` (`tantargy_id`),
  ADD KEY `fk_nkp_tananyagok_tema_id` (`tema_id`);

--
-- A tábla indexei `szerepkorok`
--
ALTER TABLE `szerepkorok`
  ADD PRIMARY KEY (`szerepkor_id`),
  ADD UNIQUE KEY `uq_szerepkorok_szerepkor_nev` (`szerepkor_nev`);

--
-- A tábla indexei `szerepkor_jogosultsag`
--
ALTER TABLE `szerepkor_jogosultsag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_szerepkor_jogosultsag_1` (`szerepkor_id`,`jogosultsag_id`),
  ADD KEY `fk_szerepkor_jogosultsag_jogosultsag_id` (`jogosultsag_id`);

--
-- A tábla indexei `szintek`
--
ALTER TABLE `szintek`
  ADD PRIMARY KEY (`szint_id`),
  ADD UNIQUE KEY `uq_szintek_szint_szam` (`szint_szam`);

--
-- A tábla indexei `tantargyak`
--
ALTER TABLE `tantargyak`
  ADD PRIMARY KEY (`tantargy_id`);

--
-- A tábla indexei `tanulok`
--
ALTER TABLE `tanulok`
  ADD PRIMARY KEY (`tanulo_id`),
  ADD UNIQUE KEY `uq_tanulok_felhasznalo_id` (`felhasznalo_id`),
  ADD KEY `fk_tanulok_iskola_id` (`iskola_id`);

--
-- A tábla indexei `tanulokartyak`
--
ALTER TABLE `tanulokartyak`
  ADD PRIMARY KEY (`kartya_id`),
  ADD KEY `fk_tanulokartyak_csomag_id` (`csomag_id`);

--
-- A tábla indexei `tanulokartya_csomagok`
--
ALTER TABLE `tanulokartya_csomagok`
  ADD PRIMARY KEY (`csomag_id`),
  ADD KEY `fk_tanulokartya_csomagok_tantargy_id` (`tantargy_id`),
  ADD KEY `fk_tanulokartya_csomagok_tema_id` (`tema_id`);

--
-- A tábla indexei `tanulokartya_haladas`
--
ALTER TABLE `tanulokartya_haladas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tanulokartya_haladas_1` (`tanulo_id`,`kartya_id`),
  ADD KEY `fk_tanulokartya_haladas_kartya_id` (`kartya_id`);

--
-- A tábla indexei `tanulo_statisztika`
--
ALTER TABLE `tanulo_statisztika`
  ADD PRIMARY KEY (`tanulo_id`),
  ADD KEY `fk_tanulo_statisztika_szint_id` (`szint_id`);

--
-- A tábla indexei `tanulo_tantargy`
--
ALTER TABLE `tanulo_tantargy`
  ADD PRIMARY KEY (`kapcsolat_id`),
  ADD UNIQUE KEY `uq_tanulo_tantargy_1` (`tanulo_id`,`tantargy_id`),
  ADD KEY `fk_tanulo_tantargy_tantargy_id` (`tantargy_id`);

--
-- A tábla indexei `temak`
--
ALTER TABLE `temak`
  ADD PRIMARY KEY (`tema_id`),
  ADD KEY `fk_temak_tantargy_id` (`tantargy_id`);

--
-- A tábla indexei `xp_esemenyek`
--
ALTER TABLE `xp_esemenyek`
  ADD PRIMARY KEY (`esemeny_id`),
  ADD KEY `ix_xp_esemenyek_tanulo_id_idopont` (`tanulo_id`,`idopont`),
  ADD KEY `fk_xp_esemenyek_szabaly_id` (`szabaly_id`);

--
-- A tábla indexei `xp_szabalyok`
--
ALTER TABLE `xp_szabalyok`
  ADD PRIMARY KEY (`szabaly_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `adatkezelesi_kerelmek`
--
ALTER TABLE `adatkezelesi_kerelmek`
  MODIFY `kerelem_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `audit_naplo`
--
ALTER TABLE `audit_naplo`
  MODIFY `naplo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `csomagok`
--
ALTER TABLE `csomagok`
  MODIFY `csomag_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `csomag_funkciok`
--
ALTER TABLE `csomag_funkciok`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `elofizetesek`
--
ALTER TABLE `elofizetesek`
  MODIFY `elofizetes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `elofizetok`
--
ALTER TABLE `elofizetok`
  MODIFY `elofizeto_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `felhasznalok`
--
ALTER TABLE `felhasznalok`
  MODIFY `felhasznalo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `felhasznalo_munkamenetek`
--
ALTER TABLE `felhasznalo_munkamenetek`
  MODIFY `session_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `felhasznalo_szerepkor`
--
ALTER TABLE `felhasznalo_szerepkor`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `fizetesi_tranzakciok`
--
ALTER TABLE `fizetesi_tranzakciok`
  MODIFY `tranzakcio_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `fizetesi_webhook_naplo`
--
ALTER TABLE `fizetesi_webhook_naplo`
  MODIFY `esemeny_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `funkciok`
--
ALTER TABLE `funkciok`
  MODIFY `funkcio_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `hozzajarulasok`
--
ALTER TABLE `hozzajarulasok`
  MODIFY `hozzajarulas_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `iskolak`
--
ALTER TABLE `iskolak`
  MODIFY `iskola_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `jelszo_visszaallitas`
--
ALTER TABLE `jelszo_visszaallitas`
  MODIFY `reset_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `jogosultsagok`
--
ALTER TABLE `jogosultsagok`
  MODIFY `jogosultsag_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `kvizek`
--
ALTER TABLE `kvizek`
  MODIFY `kviz_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `kviz_kerdesek`
--
ALTER TABLE `kviz_kerdesek`
  MODIFY `kerdes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `kviz_probalkozasok`
--
ALTER TABLE `kviz_probalkozasok`
  MODIFY `probalkozas_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `kviz_valaszok`
--
ALTER TABLE `kviz_valaszok`
  MODIFY `valasz_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `nkp_tananyagok`
--
ALTER TABLE `nkp_tananyagok`
  MODIFY `nkp_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `szerepkorok`
--
ALTER TABLE `szerepkorok`
  MODIFY `szerepkor_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `szerepkor_jogosultsag`
--
ALTER TABLE `szerepkor_jogosultsag`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT a táblához `szintek`
--
ALTER TABLE `szintek`
  MODIFY `szint_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `tantargyak`
--
ALTER TABLE `tantargyak`
  MODIFY `tantargy_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `tanulok`
--
ALTER TABLE `tanulok`
  MODIFY `tanulo_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `tanulokartyak`
--
ALTER TABLE `tanulokartyak`
  MODIFY `kartya_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `tanulokartya_csomagok`
--
ALTER TABLE `tanulokartya_csomagok`
  MODIFY `csomag_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `tanulokartya_haladas`
--
ALTER TABLE `tanulokartya_haladas`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `tanulo_tantargy`
--
ALTER TABLE `tanulo_tantargy`
  MODIFY `kapcsolat_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT a táblához `temak`
--
ALTER TABLE `temak`
  MODIFY `tema_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `xp_esemenyek`
--
ALTER TABLE `xp_esemenyek`
  MODIFY `esemeny_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `xp_szabalyok`
--
ALTER TABLE `xp_szabalyok`
  MODIFY `szabaly_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `adatkezelesi_kerelmek`
--
ALTER TABLE `adatkezelesi_kerelmek`
  ADD CONSTRAINT `fk_adatkezelesi_kerelmek_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `audit_naplo`
--
ALTER TABLE `audit_naplo`
  ADD CONSTRAINT `fk_audit_naplo_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Megkötések a táblához `csomag_funkciok`
--
ALTER TABLE `csomag_funkciok`
  ADD CONSTRAINT `fk_csomag_funkciok_csomag_id` FOREIGN KEY (`csomag_id`) REFERENCES `csomagok` (`csomag_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_csomag_funkciok_funkcio_id` FOREIGN KEY (`funkcio_id`) REFERENCES `funkciok` (`funkcio_id`) ON UPDATE CASCADE;

--
-- Megkötések a táblához `elofizetesek`
--
ALTER TABLE `elofizetesek`
  ADD CONSTRAINT `fk_elofizetesek_csomag_id` FOREIGN KEY (`csomag_id`) REFERENCES `csomagok` (`csomag_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_elofizetesek_elofizeto_id` FOREIGN KEY (`elofizeto_id`) REFERENCES `elofizetok` (`elofizeto_id`) ON UPDATE CASCADE;

--
-- Megkötések a táblához `elofizetok`
--
ALTER TABLE `elofizetok`
  ADD CONSTRAINT `fk_elofizetok_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON UPDATE CASCADE;

--
-- Megkötések a táblához `felhasznalo_munkamenetek`
--
ALTER TABLE `felhasznalo_munkamenetek`
  ADD CONSTRAINT `fk_felhasznalo_munkamenetek_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `felhasznalo_szerepkor`
--
ALTER TABLE `felhasznalo_szerepkor`
  ADD CONSTRAINT `fk_felhasznalo_szerepkor_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_felhasznalo_szerepkor_szerepkor_id` FOREIGN KEY (`szerepkor_id`) REFERENCES `szerepkorok` (`szerepkor_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `fizetesi_tranzakciok`
--
ALTER TABLE `fizetesi_tranzakciok`
  ADD CONSTRAINT `fk_fizetesi_tranzakciok_elofizetes_id` FOREIGN KEY (`elofizetes_id`) REFERENCES `elofizetesek` (`elofizetes_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_fizetesi_tranzakciok_elofizeto_id` FOREIGN KEY (`elofizeto_id`) REFERENCES `elofizetok` (`elofizeto_id`) ON UPDATE CASCADE;

--
-- Megkötések a táblához `hozzajarulasok`
--
ALTER TABLE `hozzajarulasok`
  ADD CONSTRAINT `fk_hozzajarulasok_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `jelszo_visszaallitas`
--
ALTER TABLE `jelszo_visszaallitas`
  ADD CONSTRAINT `fk_jelszo_visszaallitas_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `kvizek`
--
ALTER TABLE `kvizek`
  ADD CONSTRAINT `fk_kvizek_elerheto_csomag_id` FOREIGN KEY (`elerheto_csomag_id`) REFERENCES `csomagok` (`csomag_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_kvizek_tantargy_id` FOREIGN KEY (`tantargy_id`) REFERENCES `tantargyak` (`tantargy_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_kvizek_tema_id` FOREIGN KEY (`tema_id`) REFERENCES `temak` (`tema_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Megkötések a táblához `kviz_kerdesek`
--
ALTER TABLE `kviz_kerdesek`
  ADD CONSTRAINT `fk_kviz_kerdesek_kviz_id` FOREIGN KEY (`kviz_id`) REFERENCES `kvizek` (`kviz_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `kviz_probalkozasok`
--
ALTER TABLE `kviz_probalkozasok`
  ADD CONSTRAINT `fk_kviz_probalkozasok_kviz_id` FOREIGN KEY (`kviz_id`) REFERENCES `kvizek` (`kviz_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_kviz_probalkozasok_tanulo_id` FOREIGN KEY (`tanulo_id`) REFERENCES `tanulok` (`tanulo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `kviz_valaszok`
--
ALTER TABLE `kviz_valaszok`
  ADD CONSTRAINT `fk_kviz_valaszok_kerdes_id` FOREIGN KEY (`kerdes_id`) REFERENCES `kviz_kerdesek` (`kerdes_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `nkp_tananyagok`
--
ALTER TABLE `nkp_tananyagok`
  ADD CONSTRAINT `fk_nkp_tananyagok_tantargy_id` FOREIGN KEY (`tantargy_id`) REFERENCES `tantargyak` (`tantargy_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_nkp_tananyagok_tema_id` FOREIGN KEY (`tema_id`) REFERENCES `temak` (`tema_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Megkötések a táblához `szerepkor_jogosultsag`
--
ALTER TABLE `szerepkor_jogosultsag`
  ADD CONSTRAINT `fk_szerepkor_jogosultsag_jogosultsag_id` FOREIGN KEY (`jogosultsag_id`) REFERENCES `jogosultsagok` (`jogosultsag_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_szerepkor_jogosultsag_szerepkor_id` FOREIGN KEY (`szerepkor_id`) REFERENCES `szerepkorok` (`szerepkor_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `tanulok`
--
ALTER TABLE `tanulok`
  ADD CONSTRAINT `fk_tanulok_felhasznalo_id` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`felhasznalo_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tanulok_iskola_id` FOREIGN KEY (`iskola_id`) REFERENCES `iskolak` (`iskola_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Megkötések a táblához `tanulokartyak`
--
ALTER TABLE `tanulokartyak`
  ADD CONSTRAINT `fk_tanulokartyak_csomag_id` FOREIGN KEY (`csomag_id`) REFERENCES `tanulokartya_csomagok` (`csomag_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `tanulokartya_csomagok`
--
ALTER TABLE `tanulokartya_csomagok`
  ADD CONSTRAINT `fk_tanulokartya_csomagok_tantargy_id` FOREIGN KEY (`tantargy_id`) REFERENCES `tantargyak` (`tantargy_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tanulokartya_csomagok_tema_id` FOREIGN KEY (`tema_id`) REFERENCES `temak` (`tema_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Megkötések a táblához `tanulokartya_haladas`
--
ALTER TABLE `tanulokartya_haladas`
  ADD CONSTRAINT `fk_tanulokartya_haladas_kartya_id` FOREIGN KEY (`kartya_id`) REFERENCES `tanulokartyak` (`kartya_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tanulokartya_haladas_tanulo_id` FOREIGN KEY (`tanulo_id`) REFERENCES `tanulok` (`tanulo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `tanulo_statisztika`
--
ALTER TABLE `tanulo_statisztika`
  ADD CONSTRAINT `fk_tanulo_statisztika_szint_id` FOREIGN KEY (`szint_id`) REFERENCES `szintek` (`szint_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tanulo_statisztika_tanulo_id` FOREIGN KEY (`tanulo_id`) REFERENCES `tanulok` (`tanulo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `tanulo_tantargy`
--
ALTER TABLE `tanulo_tantargy`
  ADD CONSTRAINT `fk_tanulo_tantargy_tantargy_id` FOREIGN KEY (`tantargy_id`) REFERENCES `tantargyak` (`tantargy_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tanulo_tantargy_tanulo_id` FOREIGN KEY (`tanulo_id`) REFERENCES `tanulok` (`tanulo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `temak`
--
ALTER TABLE `temak`
  ADD CONSTRAINT `fk_temak_tantargy_id` FOREIGN KEY (`tantargy_id`) REFERENCES `tantargyak` (`tantargy_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Megkötések a táblához `xp_esemenyek`
--
ALTER TABLE `xp_esemenyek`
  ADD CONSTRAINT `fk_xp_esemenyek_szabaly_id` FOREIGN KEY (`szabaly_id`) REFERENCES `xp_szabalyok` (`szabaly_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_xp_esemenyek_tanulo_id` FOREIGN KEY (`tanulo_id`) REFERENCES `tanulok` (`tanulo_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
