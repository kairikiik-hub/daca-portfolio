Roll D - Kvaliteedikontrollija (Data Quality Analyst)

VÄLJUND (Ristvalideerimise raport (orbid leitud, ebakõlad leitud, soovitused) + SQL skript); kas ühe tabeli väärtus leidub teises tabelis

|Kategooria | Leitud probleeme | Kirjeldus |
| :--- | :---: | ---: |
| Orbid kliendid | 0 | Pole kliente, kes on ostnud, aga ei ole klientide tabelis |
| Orbid tooted | 0 | Pole tooteid, mis on müüdud, aga pole toodete tabelis |
|Vaimkliendid | 592 | Nii palju kliente pole kunagi ostnud |
| Vaimtooted | 12 | Neid tooteid pole kunagi müüdud | 
| Hinna ebakõlad | -- | -- |
|Kokku probleeme | -- | -- |

Probleemid: vaimklientide moonutavad kliendibaasi suurust ja keskmist käivet kliendi kohta
            vaimtooted  - vale laoseis ja ostuotsused, moonutatud müügiaruanne 
Kõige kriitilisem probleem

Müük: müügitulu 
