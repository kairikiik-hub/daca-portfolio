Roll D - Kvaliteedikontrollija (Data Quality Analyst)

VÄLJUND (Ristvalideerimise raport (orvud leitud, ebakõlad leitud, soovitused) + SQL skript); kas ühe tabeli väärtus leidub teises tabelis

|Kategooria | Leitud probleeme | Kirjeldus |
| :--- | :---: | ---: |
| Orvkliendid | 0 | Pole kliente, kes on ostnud, aga ei ole klientide tabelis |
| Orvtooted | 0 | Pole tooteid, mis on müüdud, aga ei ole toodete tabelis |
| Vaimkliendid | 592 | 592 klienti pole kunagi ostnud |
| Vaimtooted | 12 | 12 toodet ei ole kunagi müüdud | 
| Hinna ebakõlad | 664 | 664 tehingus ei klapi müügihind tootehinnaga |
| Kokku probleeme | 624 | Peamised ostuta kliendikontod; kriitilisi viitevigu ei esine |

Probleemid: vaimklientide moonutavad kliendibaasi suurust ja keskmist käivet kliendi kohta
            vaimtooted  - vale laoseis ja ostuotsused, moonutatud müügiaruanne 
Kõige kriitilisem probleem - hinna ebakõla (otsene rahaline ja raamatupidamislik mõju; hinda võib olla muudetud tagantjärele)


Nädala ühistegevus: osakondade sild

Klienditeenindus: klientide emaile enne puhastamist 2770; pärast andmete puhastamist 2640

SQL päring: 

SELECT COUNT(NULLIF(TRIM(email), '')) AS enne, COUNT(DISTINCT LOWER(NULLIF(TRIM(email), ''))) AS parast FROM customers_test;

Tähendus osakonnale:
pärast duplikaat emailide eemaldamist saame täpsema kampaaniate ja uudiskirjade statistika; klientidele ei saadeta topeltkirju (vähem rämpsposti kaebusi), terviklik kliendivaade (ühe ja sama kliendi ostud ei ole enam killustunud mitme konto vahel); kliendibaasi suurus ja keskmine tulu kliendi kohta on täpsem

Kontroll teise meeskonna numbritega : saime ....



