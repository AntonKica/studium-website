+++
layout = 'subject-info'
title = 'Tvorba internetových aplikácií'

[params.links.teams]
name = 'Microsoft Teams'
url = 'https://teams.microsoft.com/l/team/19%3AP3WZVxlSG1Dd6ppjofRt9Lxh46cGFLNqVbkYa4utebw1%40thread.tacv2/conversations?groupId=44879243-aa15-4ef7-ab99-8d17d1e518ce&tenantId=ce31478d-6e7a-4ce7-8670-a5b9d51884f9'
alt='FMFI-2025-Tvorba-internetových-aplikácií-(2-INF-145)'

[params.links.fmfi]
name = 'Stránka predmetu'
url = 'https://micro.dcs.fmph.uniba.sk/dokuwiki/sk:dcs:tia:hodnotenie'
+++

Kód pre MS-Teams: 1nqjd1x

## Deadlines

|  od  |  do  | fáza |
| ---- | ---- | ----------------------------------- |
| 18.2 | 25.2 | vybranie témy projektu |
|  4.3 | 11.3 | špecifikácia projektu |
| 11.3 | 15.4 | práca na projekte, 6x týždenný report |
| 15.4 | 22.4 | beta verzia a feedback od spolužiakov |
| 22.4 | 29.4 | práca na projekte, 2x týždenný report |
|  6.5 | 13.5 | finálna verzie, prezentácia a feedback od spolužiakov |

## Projekt

### Skript na genererovanie reportov

Vytvoril som jednoduchý interaktívny bash skript, ktorý vyplní základné údaje a zgeneruje všetky reporty.
Mnoho vecí je tam duplicitných, tak som pre to vytvoril skript, plus má predvyplnené týždne a dni :)

Tu stiahni:

- [generate-from-templates.7z](/tvorba-internetovych-aplikacii/generate-from-templates.7z)
- [generate-from-templates.xz](/tvorba-internetovych-aplikacii/generate-from-templates.xz) 

Postup je jednoduchý:

1. Rozbaľ archív
2. Spusti skript `generate-from-templates`
3. Vyplň svoje údaje
4. Skopíruj si vygenerované .md súbory z priečinka `generated`
