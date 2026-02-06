> **Ansvarsfraskrivelse:** Denne guiden er produsert av Manus, en AI-assistent. Informasjonen er basert på offentlig tilgjengelige kilder per februar 2026. GitHubs funksjonalitet kan endres over tid.

# Omfattende Guide: Hvordan Lage en Privat Kopi av et Offentlig GitHub Repository

**Dato:** 06. februar 2026

## Introduksjon

Å jobbe med åpen kildekode-prosjekter på GitHub innebærer ofte å bruke "forks" for å foreslå endringer. En standard fork av et offentlig repository vil imidlertid også være offentlig. Dette kan være problematisk hvis du ønsker å gjøre private endringer, eksperimentere med koden, eller lagre proprietære tilpasninger uten å dele dem med offentligheten. GitHub tillater ikke direkte å endre synligheten på en offentlig fork til privat [1].

Denne guiden gir en detaljert oversikt over de mest effektive metodene for å lage en fullstendig privat kopi (en "speil" eller "klone") av et offentlig GitHub-repository i din egen konto. Vi vil dekke tre ulike tilnærminger, fra den enkleste metoden via GitHubs web-grensesnitt til den mest robuste metoden ved hjelp av kommandolinjen, som også muliggjør synkronisering med det opprinnelige (upstream) repositoryet.

## Sammenligning av Metoder

Før vi går i dybden, gir tabellen under en rask oversikt over de tre hovedmetodene for å lage en privat kopi.

| Metode                             | Fordeler                                                                 | Ulemper                                                                    | Anbefalt for                                                                 |
| ---------------------------------- | ------------------------------------------------------------------------ | -------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| **1. GitHub Import**               | Svært enkel, krever ingen kommandolinje, gjøres via web-grensesnitt.      | Kan være treg for store repositories, ikke den offisielt anbefalte metoden. | Nybegynnere og raske, private kopier uten behov for fremtidig synkronisering. |
| **2. Bare Clone & Mirror Push**    | **Anbefalt metode.** Robust, rask, kopierer all historikk, tags og branches. | Krever bruk av kommandolinje.                                              | Alle som trenger en fullstendig og synkroniserbar privat kopi.                |
| **3. Fork & "Leave Fork Network"** | Kan gjøres delvis via web-grensesnitt.                                   | Bryter den direkte koblingen til upstream, gjør synkronisering vanskelig.  | Situasjoner der man raskt vil gjøre en eksisterende fork privat.              |

--- 

## Metode 1: Bruk av GitHubs Import-funksjon (Enklest)

Den desidert enkleste måten å lage en privat kopi på, er å bruke GitHubs innebygde importverktøy. Dette verktøyet er egentlig ment for å importere prosjekter fra andre plattformer, men fungerer utmerket for å duplisere et annet GitHub-repository [2].

### Steg-for-steg:

1.  **Naviger til Import-siden:** Åpne nettleseren din og gå til [https://github.com/new/import](https://github.com/new/import).

2.  **Oppgi URL til kilde-repository:** I feltet "Your old repository's clone URL", limer du inn den fullstendige HTTPS-URLen til det offentlige repositoryet du vil kopiere. For eksempel: `https://github.com/openai/gpt-3.git`.

3.  **Velg eier og navn:** Velg din egen GitHub-konto som eier ("Owner") og gi det nye repositoryet et passende navn.

4.  **Sett synlighet til Privat:** Under "Privacy", velg alternativet **Private**.

5.  **Start importen:** Klikk på knappen "Begin import".

GitHub vil nå starte prosessen med å kopiere hele repositoryet, inkludert all commit-historikk, over til ditt nye private repository. Avhengig av størrelsen på det opprinnelige repositoryet, kan dette ta alt fra noen sekunder til flere minutter [3].

## Metode 2: Bare Clone & Mirror Push (Anbefalt og mest robust)

Dette er den offisielt anbefalte metoden fra GitHub for å duplisere et repository [4]. Den gir deg en perfekt, komplett speiling (mirror) og legger grunnlaget for å kunne hente fremtidige oppdateringer fra det opprinnelige prosjektet.

### Steg-for-steg:

1.  **Opprett et nytt privat repository på GitHub:** Gå til [https://github.com/new](https://github.com/new) og opprett et nytt, tomt repository. Gi det et navn, sett det til **Private**, og **ikke** initialiser det med en `README`, `.gitignore` eller lisensfil.

2.  **Åpne terminalen:** Åpne en kommandolinje-applikasjon på din datamaskin (Terminal på macOS/Linux, Git Bash eller PowerShell på Windows).

3.  **Lag en "bare clone" av det offentlige repositoryet:** Dette lager en spesiell type klone som kun inneholder Git-data, uten en lokal arbeidsmappe. Erstatt `public-repo-url` med URL-en til det offentlige repositoryet.

    ```bash
    git clone --bare <public-repo-url>
    ```

4.  **Naviger inn i den nye mappen:** Mappen vil ha samme navn som repositoryet, med `.git` på slutten.

    ```bash
    cd <repository-name>.git
    ```

5.  **Utfør en "mirror push" til ditt nye private repository:** Dette dytter alt – alle branches, tags og commits – til ditt nye private repository. Erstatt `private-repo-url` med URL-en til det private repositoryet du opprettet i steg 1.

    ```bash
    git push --mirror <private-repo-url>
    ```

6.  **Rydd opp:** Du kan nå slette den lokale "bare clone"-mappen.

    ```bash
    cd ..
    rm -rf <repository-name>.git
    ```

Du har nå en perfekt privat kopi i din egen GitHub-konto. Du kan klone dette private repositoryet til din lokale maskin og begynne å jobbe med det som normalt.

### Hvordan holde din private kopi synkronisert

En stor fordel med Metode 2 er muligheten til å hente oppdateringer fra det opprinnelige offentlige repositoryet. Slik gjør du det:

1.  **Klon ditt private repository lokalt (hvis du ikke har gjort det allerede):**

    ```bash
    git clone <private-repo-url>
    cd <private-repo-name>
    ```

2.  **Legg til det opprinnelige repositoryet som en "remote" kalt `upstream`:**

    ```bash
    git remote add upstream <public-repo-url>
    ```

3.  **Når du vil hente oppdateringer, kjør følgende kommandoer:**

    ```bash
    git fetch upstream
    git merge upstream/main  # Eller den branchen du vil hente fra, f.eks. master
    ```

    Dette vil flette inn de nyeste endringene fra det offentlige prosjektet i din private kopi.

## Metode 3: Fork & "Leave Fork Network"

Denne metoden er et alternativ hvis du allerede har laget en offentlig fork og ønsker å gjøre den privat. Den innebærer å manuelt koble forken fra det opprinnelige "fork-nettverket" [5].

### Steg-for-steg:

1.  **Lag en vanlig, offentlig fork** av repositoryet via GitHubs web-grensesnitt.
2.  **Gå til `Settings`** i din nye fork.
3.  Under fanen **`General`**, scroll ned til **"Danger Zone"**.
4.  Finn og klikk på **"Leave fork network"**. Du må bekrefte dette valget.
5.  Når prosessen er fullført, vil din fork være et uavhengig repository. Gå tilbake til **"Danger Zone"**.
6.  Nå vil alternativet **"Change repository visibility"** være tilgjengelig. Klikk på dette og endre synligheten til **Private**.

**Ulempen** med denne metoden er at den bryter den innebygde funksjonaliteten for å enkelt lage "pull requests" tilbake til det opprinnelige prosjektet. Du må manuelt sette opp `upstream` remote (som beskrevet i Metode 2) for å hente endringer.

## Konklusjon

Å lage en privat kopi av et offentlig GitHub-repository er en vanlig og nyttig praksis. For de fleste brukere vil **Metode 2 (Bare Clone & Mirror Push)** være det beste valget, da den er robust, komplett og offisielt støttet av GitHub. For de som foretrekker en enklere tilnærming uten kommandolinje, er **Metode 1 (GitHub Import)** et utmerket og raskt alternativ. Metode 3 er en reserveløsning for spesifikke tilfeller.

Ved å bruke disse teknikkene kan du trygt jobbe med din egen versjon av et prosjekt, med full kontroll over kodens synlighet og historikk.

---

## Referanser

[1] GitHub Community Discussion. "Is it possible to make a fork private?". [https://github.com/orgs/community/discussions/128990](https://github.com/orgs/community/discussions/128990)

[2] Stack Overflow. "GitHub: How to make a fork of public repository private?". [https://stackoverflow.com/questions/10065526/github-how-to-make-a-fork-of-public-repository-private](https://stackoverflow.com/questions/10065526/github-how-to-make-a-fork-of-public-repository-private)

[3] Medium. "GitHub: How to create Private Downstream from Public Upstream". [https://medium.com/@life-is-short-so-enjoy-it/github-how-to-create-private-downstream-from-public-upstream-3a34ff641806](https://medium.com/@life-is-short-so-enjoy-it/github-how-to-create-private-downstream-from-public-upstream-3a34ff641806)

[4] GitHub Docs. "Duplicating a repository". [https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository)

[5] GitHub Gist by 0xjac. "Create a private fork of a public repository". [https://gist.github.com/0xjac/85097472043b697ab57ba1b1c7530274](https://gist.github.com/0xjac/85097472043b697ab57ba1b1c7530274)
