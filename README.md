# DiákPlusz – Oktatási és Pénzügyi Edukációs Platform

A **DiákPlusz** egy komplex, reszponzív oktatási webalkalmazás felső tagozatos, gimnáziumi és technikumi diákok számára. A platform egyetlen átlátható ökoszisztémában egyesíti a tananyagokat, a digitális tanulókártyákat (flashcard), az interaktív kvízeket, a gamifikált motivációs rendszert (XP, streak, szintek) és az alapvető gyakorlati pénzügyi ismereteket.

---

## Csapattagok és szerepkörök (13.D)

| Név | Szerepkör | Fő feladatok | GitHub |
| :--- | :--- | :--- | :--- |
| **Ludmann Dániel** | Frontend fejlesztő | UI/UX tervezés (Figma), reszponzív kliensoldali felület (HTML5, CSS3, JS) | `@ludmanndani` |
| **Zóka Péter** | Backend fejlesztő | MySQL adatbázis-architektúra, ER diagram, szerveroldali logika és API végpontok | `@zoka-peter` |
| **Susányi János** | Full-stack fejlesztő | Frontend–backend integráció, JIRA projektmenedzsment, dokumentáció | `@JaneK-Developer` |

---

## Főbb funkciók és modulok

* **Felhasználói fiók és adatvédelem:** Regisztráció, bejelentkezés, személyre szabható diákprofil, GDPR hozzájárulás-kezelés és szerepkör-alapú jogosultságkezelés (RBAC).
* **Személyre szabott Dashboard:** Napi tanulási célok, aktuális XP, szint, napi sorozat (streak) és haladási statisztikák.
* **Flashcard és Kvízrendszer:** Saját és tantárgyi tanulókártya-csomagok, feleletválasztós és számolós/szöveges kvízek azonnali szerveroldali kiértékeléssel.
* **Pénzügyi oktatás:** Gyakorlatorientált leckék (megtakarítás, bankszámla, adózás, bruttó–nettó bér, kamat, hitel) és kapcsolódó tudáspróbák.
* **Előfizetési rendszer:** Ingyenes és Prémium csomagok kezelése külső fizetési szolgáltató (Stripe/Barion) integrációjára felkészítve.
* **Adminisztrációs felület:** Felhasználók, tantárgyak, kvízek és tananyagok központi kezelése.

---

## Technológiai stack

* **Frontend:** HTML5, CSS3, JavaScript (reszponzív kialakítás)
* **Backend:** REST-jellegű API architektúra (JSON kommunikáció)
* **Adatbázis:** Relációs MySQL adatbázis (PK/FK kapcsolatok, indexek, tranzakciókezelés)
* **Tervezés és projektmenedzsment:** Figma, Jira, Git & GitHub

---

## Projektstruktúra

* `docs/` – Projektbemutató, funkcionális és UI tervek, műszaki design terv, adatbázis-tervdokumentáció
* `database/` – A teljes MySQL adatbázisséma (`schema.sql`), példaadatok (`seed.sql`) és az ER diagram
* `frontend/` – Kliensoldali forráskódok
* `backend/` – Szerveroldali forráskódok

---

## Kapcsolódó linkek

* **Figma UI terv:** `[https://www.figma.com/design/sCNSJAzP1x3q4ixbkUl51m/Untitled?node-id=0-1&p=f&t=kqDs3erWUDsIlnyL-0]`
* **Jira projekt tábla:** `[https://diakplus.atlassian.net/jira/software/projects/DIAK/list?jql=project%20%3D%20DIAK%20ORDER%20BY%20cf%5B10019%5D%20ASC]`

---

## Verziókezelési munkafolyamat

A fejlesztés során külön ágakon dolgozunk:
* `main` – Stabil, ellenőrzött és bemutatható állapot
* `dev` – Aktív fejlesztési és integrációs ág
* `feature/*`, `docs/*` – Funkció- és dokumentációs ágak, amelyek **Pull Request** és kölcsönös átnézés (code review) után kerülnek beolvasztásra.
