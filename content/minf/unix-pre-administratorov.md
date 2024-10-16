+++
layout = 'subject-info'
title = 'UNIX pre administrátorov'

[params.links.fmfi]
name = "Stránka predmetu"
url = "http://www.dcs.fmph.uniba.sk/unix/"
+++

## Cvičenia

### Cvičenie 16.10.

1. V adresari 'zahrada' vytvorte adresar 'kompost', do ktoreho mozu zapisovat
   vsetci clenovia skupiny 'zelenina' (a nikto viac), ale kazdy uzivatel moze
   vymazat iba objekty nim vytvorene.

```sh
mkdir /home/kompost
chmod 1770 /home/kompost
chown :zelenina /home/kompost
```

2. Pamatate sa este na mrkvu a kapustu a ich spolocnu zahradu?

   Vedeli by ste dosiahnut, aby (z pohladu uzivatelov 'mrkva' a 'kapusta')
   veci fungovali tak, ze pokial mrkva vyrobi nejaky subor ci podadresar v
   adresari 'zahrada', bude s nim vediet pracovat (t.j. citat z neho,
   zapisovat don) aj uzivatel 'kapusta' a naopak? Predpokladame, ze
   uzivatelia 'mrkva' a 'kapusta' nebudu lotri a nebudu sa to snazit
   umyselne znemoznit -- jednoducho budu system pouzivat beznym sposobom
   (napriklad spravia 'mkdir /home/zahrada/kukurica', ...).

```sh
chmod g+s /home/kompost
umask 0011 # aby sa nam vytvárali súbory s vhodnými právami
```

3. Vytvorte uzivatela 'hrach', ktory bude vediet menit obsah(!) toho
   "tajneho" foliovnika z predosleho cvika bez toho, aby vedel jeho nazov,
   ale nebude mat pristup nikde inde do adresara 'zahrada'. Dajte si pozor,
   aby 'hrach' vedel menit jeho obsah aj ked ho 'mrkva' alebo 'kapusta'
   premenuju a 'hrach' sa nedozvie jeho novy nazov.
```sh
ln /home/zahrada/foliovnik # vytvorime si hardlinku na ten subor u seba
```

4. Uzivatelia 'mrkva' a 'kapusta' su lenivi zakazdym, ked su vo svojich home
   adresaroch, pisat '../zahrada', aby sa dostali k suborom v adresari
   'zahrada'. Zjednoduste im to!

```sh
ln -s /home/zahrada/ /home/mrkva/zahrada # cista symbolicka linka v home adresaroch
```


5. Vyrobte si v zahrade zariadenie zvane "hadica" (prekvapivo, mala by to
   byt rura, cize "pipe"). V jednom terminali ju zacnite citat, v druhom do
   nej nieco zapiste. Zistite tiez, co sa stane, ak do jednej rury chcu
   naraz dvaja pisat, alebo z nej naraz dvaja citat.
```sh
mkpipe /home/zahrada/hadica # cisto vytvorenie pipy
```

6. Pozrite sa do adresara /proc a vsimnite si, ake uzitocne informacie o
   systeme sa mozno z neho dozvediet. Vacsina z nich su pekne textove
   subory, a tak ich mozno citat uplne priamo.

   Dobra rada: Subor "kcore" na citanie vhodny nie je :-) Verte nam,
   kolegovia na prvom cviku to uz skusili :)
```sh
# nic specialne
```
