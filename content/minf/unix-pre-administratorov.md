+++
layout = 'subject-info'
title = 'UNIX pre administrátorov'

[params.links.fmfi]
name = "Stránka predmetu"
url = "http://www.dcs.fmph.uniba.sk/unix/"
+++

## Cvičenia

### Oprávnenia

1. Preskumajte moznosti programov 'chage', 'useradd' resp. 'adduser'

#### riešenie

```sh
chage -d root                  # force root to change password on next logon
useradd -m -u UID -g GID login # create user login with home directory, specific UID and GID
adduser                        # create user interactively
```
    
 ---

2. Vyrobte uzivatela 'mrkva' tak, aby pri jeho prvom prihlaseni sa ho system
nepytal ziadne heslo, ale vyzval ho nastavit si nove heslo.

#### riešenie

```sh
useradd -m mrkva    # add user mrkva
chage -M 9999 mrkva # expire password, set age to maximum value
passwd -de mrkva    # deleta and expire password
```

---

3. Vyrobte skupinu 'zelenina' a uzivatelov 'mrkva', 'kapusta' a 'zajac'
tak, aby len 'mrkva' a 'kapusta' mohli pracovat s adresarom 'zahrada'
(ten vyrobte napriklad v adresari '/home') a vsetkymi jeho podadresarmi.
Ostatni uzivatelia (napr. 'zajac') budu moct s tymito adresarmi pracovat
iba ak budu poznat heslo ku skupine 'zelenina'.

Medzi uzitocne prikazy patri 'gpasswd', 'sg' a 'newgrp'. Prvy z nich umoznuje nastavit
heslo pre skupinu, dalsie dva zase davaju uzivatelovi moznost spustit si
nejaky program (napriklad novy prikazovy riadok) tak, ze bude mat
pridanu navyse niektoru inu skupinu -- ak, samozrejme, zadaju spravne
jej heslo. Ak ste ich este nevideli, manualova stranka povie viac. 

#### riešenie

```bash
groupadd zelenina
gpasswd zelenina

useradd -m mrkva
useradd -m kapusta
useradd -m zajac

usermod -aG zelenina mrkva
usermod -aG zelenina kapusta

mkdir /home/zahrada
chown :zelenina /home/zahrada
chmod 770 /home/zahrada

# create example file and test permissions
echo "smth" > /home/zahrada/grouponly
# not needed but still
chown :zelenina /home/zahrada/grouponly

su mrkva -c 'cat /home/zahrada/grouponly' # smth
su zajac -c 'cat /home/zahrada/grouponly' # cat: /home/zahrada/grouponly: Permission denied

---

```
 
4. Spoznajte program 'id' (tip: 'man id'). Ako uzivatel 'mrkva' skopiruje
program 'id' do svojho home adresara a nastavte mu SUID a/alebo SGID
atribut. Teraz ako uzivatel 'zajac' spustte program 'id' z home adresara
usera 'mrkva'. Vyskusajte vsetky moznosti.

Poznamka: Skuste zmenit skupinu skopirovaneho programu na 'zelenina'.
Ako sa to prejavi na vystupe tohoto programu?

#### riešenie

S nastavenými SUID a SGID sa mení aj UID a GID na výstupe príkazu `id`

---


5. V adresari 'zahrada' vytvorte "tajny" subor a zatial ho nazvite
'foliovnik'. "Tajny" subor vytvorite tak, ze adresar 'zahrada' upravite
tak, aby nikto okrem uzivatelov 'mrkva' a 'kapusta' (teda ani 'zajac')
nevedel tento subor zmazat, prememenovat, a ani len zistit, ze takyto
subor existuje. Chceme zabezpecit, aby ktokolvek (teda aj 'zajac'), kto
pozna nazov toho suboru, ho vedel editovat. Spravte to tak, aby 'mrkva'
a 'kapusta' vedeli "tajny" subor premenovat.

#### riešenie

```bash
chmod 771 /home/zahrada # everyone can access this file, but others can't list it's contents

echo "text" > /home/zahrada/foliovnik
chown :zelenina /home/zahrada/foliovnik
chmod 666 /home/zahrada/foliovnik # everyone can read and edit this file

su mrkva -c 'cat /home/zahrada/foliovnik' # text
su zajac -c 'cat /home/zahrada/foliovnik' # text
```


47. Otazka pre guruov: Co myslite, ktory zo spominanych uzivatelov je
    koren?;o))

#### riešenie

Fakt netuším, či to je neajký zeleninový easteregg/pun.

### Ďalšie oprávnenia, hardlinky a symbolické linky

1. V adresari 'zahrada' vytvorte adresar 'kompost', do ktoreho mozu zapisovat
vsetci clenovia skupiny 'zelenina' (a nikto viac), ale kazdy uzivatel moze
vymazat iba objekty nim vytvorene.

#### riešenie

```bash
mkdir /home/zahrada/kompost
chown :zelenina /home/zahrada/kompost
chmod 1770 /home/zahrada/kompost # set SUID bit on

su mrkva -c 'echo "oranzova" > /home/zahrada/kompost/mrkva' 
su kapusta -c 'echo "zelena" > /home/zahrada/kompost/kapusta'

su mrkva -c 'cat /home/zahrada/kompost/kapusta' 
su kapusta -c 'cat /home/zahrada/kompost/mrkva'

su mrkva -c 'rm /home/zahrada/kompost/kapusta' # rm: remove write-protected regular file '/home/zahrada/kompost/kapusta'?
su kapusta -c 'rm /home/zahrada/kompost/mrkva' # rm: remove write-protected regular file '/home/zahrada/kompost/mrkva'?
```

---

2. Pamatate sa este na mrkvu a kapustu a ich spolocnu zahradu?

Vedeli by ste dosiahnut, aby (z pohladu uzivatelov 'mrkva' a 'kapusta')
veci fungovali tak, ze pokial mrkva vyrobi nejaky subor ci podadresar v
adresari 'zahrada', bude s nim vediet pracovat (t.j. citat z neho,
zapisovat don) aj uzivatel 'kapusta' a naopak? Predpokladame, ze
uzivatelia 'mrkva' a 'kapusta' nebudu lotri a nebudu sa to snazit
umyselne znemoznit -- jednoducho budu system pouzivat beznym sposobom
(napriklad spravia 'mkdir /home/zahrada/kukurica', ...).

#### riešenie

```bash
chmod g+s /home/zahrada # set GUID bit on
ls -ld /home/zahrada

su mrkva -c 'echo "kukurica" > /home/zahrada/kompost/kukurica'
su kapusta -c 'cat /home/zahrada/kompost/kukurica'  # kukurica
ls -ld /home/zahrada/kompost/kukurica               # -rw-r--r-- 1 mrkva zelenina 9 Jan  6 14:09 /home/zahrada/kompost/kukurica
```

---

3. Vytvorte uzivatela 'hrach', ktory bude vediet menit obsah(!) toho
"tajneho" foliovnika z predosleho cvika bez toho, aby vedel jeho nazov,
ale nebude mat pristup nikde inde do adresara 'zahrada'. Dajte si pozor,
aby 'hrach' vedel menit jeho obsah aj ked ho 'mrkva' alebo 'kapusta'
premenuju a 'hrach' sa nedozvie jeho novy nazov.

#### riešenie

```bash
useradd -m hrach
ln /home/zahrada/foliovnik /home/hrach/moj_foliovnik # hardlink

su hrach -c 'cat /home/hrach/moj_foliovnik'                         # text
su mrkva -c 'mv /home/zahrada/foliovnik /home/zahrada/foliovnik2' 
su hrach -c 'echo "druhy text" > /home/hrach/moj_foliovnik' 
su mrkva -c 'mv /home/zahrada/foliovnik2 /home/zahrada/foliovnik' 
su hrach -c 'cat /home/hrach/moj_foliovnik'                         # druhy text
su mrkva -c 'cat /home/zahrada/foliovnik'                           # druhy text
su mrkva -c 'echo "text" > /home/zahrada/foliovnik' 
su hrach -c 'cat /home/hrach/moj_foliovnik'                         # text
```

---

4. Uzivatelia 'mrkva' a 'kapusta' su lenivi zakazdym, ked su vo svojich home
adresaroch, pisat '../zahrada', aby sa dostali k suborom v adresari
'zahrada'. Zjednoduste im to!

#### riešenie

```bash
# softlinks
ln -s /home/zahrada /home/mrkva/zahrada
ln -s /home/zahrada /home/kapusta/zahrada

su mrkva -c 'cd; cat zahrada/foliovnik'     # text
su kapusta -c 'cd; cat zahrada/foliovnik'   # text
```

---

5. Vyrobte si v zahrade zariadenie zvane "hadica" (prekvapivo, mala by to
byt rura, cize "pipe"). V jednom terminali ju zacnite citat, v druhom do
nej nieco zapiste. Zistite tiez, co sa stane, ak do jednej rury chcu
naraz dvaja pisat, alebo z nej naraz dvaja citat.

#### riešenie

```bash
mkfifo /home/zahrada/hadica

su kapusta -c 'echo "sprava" > /home/zahrada/hadica'
su mrkva -c 'cat /home/zahrada/hadica' # sprava
```

---

6. Pozrite sa do adresara /proc a vsimnite si, ake uzitocne informacie o
systeme sa mozno z neho dozvediet. Vacsina z nich su pekne textove
subory, a tak ich mozno citat uplne priamo.

Dobra rada: Subor "kcore" na citanie vhodny nie je :-) Verte nam,
kolegovia na prvom cviku to uz skusili :)

#### riešenie

kcore je vypis celeho adresoveho priestoru.

### Mount, blokové a znakové zariadenia

1. Zistite, ktore (mozno virtualne) zariadenia mate pripojene v adresarovej
strukture. Pozrite sa do suboru /etc/fstab a porovnajte jeho obsah s tym,
co ste prave zistili. Preskumajte tiez obsah adresara /dev a vsimnite si,
ake zariadenia sa v nom nachadzaju. Ktore z nich zodpovedaju diskom
na tomto virtualnom pocitaci?

Dalsie zaujimave subory su /etc/mtab a /proc/mounts. Viete aky je rozdiel
medzi nimi?


#### riešenie

```bash
mount   # list mounted devices
lsblk   # list block devices
```

- `/proc/mounts` provides filesystem information
- `/etc/mtab` is same as above with less information, however often is a symlink to `/proc/mounts`

+++

2. Zariadenie /dev/ubdc zodpoveda CD-ROMke Vasho virtualneho pocitaca.
Primountujte si ho niekam a pozrite sa, ake subory sa na nom nachadzaju.
Vyskusajte si tiez volby "norock", "nojoliet", "mode", "uid" a v
neposlednom rade volbu "ro" (!) pri jeho mountovani.

#### riešenie

```bash
mkdir /mnt/cd
mount /dev/ubdc /mnt/cd -t iso9660 -o norock,ro

ls /mnt/cd
```

---

3. Ako by ste dosiahli, aby vsetci uzivatelia patriaci do skupiny "zelenina"
vedeli mountovat CDcko, ktore vlozia do tejto (aj ked virtualnej)
CD-ROMky? Je potrebne pouzit nejake dalsie nastavenia (a ak ano, ake?),
aby ste si tym nevyrobili lahko zneuzitelnu dieru do systemu?

Vyskusajte si rozne volby na mountovanie tohto disku -- medzi
najzaujimavejsie patria "nosuid", "noexec", "nodev" a "ro". Vyskusajte
si, ci ich popis v manualovej stranke programu "mount" skutocne
zodpoveda realite.

#### riešenie

```bash
chown :zelenina /usr/bin/mount
chown :zelenina /mnt/cd
echo "/dev/ubdc /mnt/cd iso9660 user,ro 0 0" >> /etc/fstab # this, specificaly user, guarantess anyone can mount /dev/ubdc
umount /mnt/cd

su mrkva -c 'mount -a; ls /mnt/cd'
```

---

4. Vytvorte zariadenie s vhodnym nazvom (napriklad "/home/zahrada/kombajn"),
ktore bude fungovat presne ako standardny disk /dev/ubda. Vyskusajte si,
ci sa skutocne sprava tak, ako by ste ocakavali.

#### riešenie

```bash
ls -ld /dev/ubda                    # brw-rw---- 1 root disk 98, 0 Jan  6 16:42 /dev/ubda
mknod /home/zahrada/kombajn b 98 0  # create block device with major 98 minor 0
```

---

5. Medzi velmi zaujimave zariadenia patria /dev/null a /dev/zero. 
Na co vlastne take zariadenia mozu sluzit? A aky je medzi nimi rozdiel?
Dalsie dve zaujimave zariadenia su /dev/random a /dev/urandom. V com
sa odlisuju?

#### riešenie

- `/dev/null`    - dummy output device discarding any input, can be used to truncate output of processes
- `/dev/zero`    - character device outputting zeroes, can be used to initalize a memory with 0
- `/dev/random`  - character device outputting pseudo random bits, can be used as a PRNG
- `/dev/urandom` - character device outputting truly random bits collected from entropy, can be used as a seed to a PRNG,
however may take too long to be used as a random generator itself

---

6. Prave ste si kupili novy disk s hypermodernou kapacitou 5MB a zapojili
ste ho do pocitaca. Vas virtualny pocitac ho nasiel pod nazvom
/dev/ubdb. Aby ste nanho mohli ulozit nejake zmysluplne data, mali by
ste na nom vyrobit nejaky filesystem. Viete aky? A ako ho na ten disk
dostat?

#### riešenie

```bash
mkfs.ext4 /dev/ubdb
```

---

---- (a zopar extra uloh pre tych, co nemali co robit)

7. Aby ste ho nemuseli mountovat zakazdym nanovo, pripiste si do prislusneho
suboru riadok, ktory zabezpeci, ze disk bude namountovany na onom
mieste hned od spustenia systemu.

#### riešenie

```bash
mkdir /mnt/drive
echo "/dev/ubdb /mnt/drive ext4 defaults 0 0" >> /etc/fstab # automatically mounts on startup
```

---

8. Ako urcite viete, zalohovanie je dolezita vec. Ako by ste odzalohovali
obsah tohto disku?  Najjednoduchsie by mohlo byt skopirovanie jeho
kompletneho obsahu do nejakeho suboru. Vyskusajte to!

Existuje vela moznych rieseni, a jednym z nich je pouzit prikaz "dd".
Pozrite si jeho manualovu stranku a pokuste sa pouzit ho na vyriesenie
tohto prikladu.

Vyskusajte si tiez prikaz "file", ktory vam vie povedat nieco uzitocne
o suboroch ci adresaroch.

#### riešenie

```bash
dd if=/dev/ubdb of=/home/zaloha
```

---

9. Ako teraz overit, ci zaloha funguje ako ma? Najjednoduchsie by mohlo byt
namountovat si priamo subor so zalohou. Da sa to vobec? Ak sa vam to
podari, pozrite sa, ci sa v zalohe skutocne nachadzaju subory, ktore sa
nachadzali na vasom disku. Nezabudnite, ze zalohu si nechcete pokazit, a
tak je vhodne mountovat ju iba na citanie!

Klucovym slovickom je "loop".

#### riešenie

```bash
# should work, but doesn't
mount -o loop,ro -t iso9660 /home/zaloha /mnt/zaloha  # mount: /mnt/zaloha: mount failed: Operation not permitted.
```

### Runlevel a plánovanie úloh

1. Pozrite si obsah suboru /etc/inittab a zistite, ci rozumiete vyznamu
jednotlivych poloziek, ktore sa v nom nachadzaju. Ako by ste zabezpecili,
aby uzivatel, ktory stlaci znamu kombinaciu Ctrl+Alt+Del, dostal namiesto
rebootu spravu o tom, ze kolko je hodin? A ako by ste dosiahli, ze
namiesto standardnych siestich textovych konzol ich budete mat sedem?

Neprijemne upozornenie: Na tych virtualnych masinach si toto neviete
vyskusat :-(

#### riešenie

- `ca:12345:ctrlaltdel:/sbin/wall $(date)'`
- `7:23:respawn:/sbin/getty 38400 tty7`

---

2. Do ktoreho runlevelu standardne tieto virtualne pocitace bootuju?
Aky je vyznam runlevelov 0 a 6? Ktore skripty sa v nich spustaju?
Pozrite si ich a vsimnite si, ake veci sa v nich startuju / vypinaju.

#### riešenie

```bash
runlevel # N 2
```

---

3. Ktore skripty sa spustaju v "standardnom" runleveli? Pozrite si ich! 
Skadial sa vlastne spustaju skripty SnnMeno a KnnMeno spominane na
prednaske?

#### riešenie


- on entry to the specific runlevel

---

4. Pozrite si manualovu stranku prikazov "shutdown" a "telinit" a skuste sa
prepnut z jedneho runlevelu do druheho, pripadne vhodne nacasovat
vypnutie pocitaca.

#### riešenie

- play with it

---

5. Pomocou planovaca 'at' si nastavte vypnutie vasho virtualneho pocitaca na
koniec cvicenia. Vyskusajte si tiez prikazy 'atq' a 'atrm'.
S akou presnostou je mozne nacasovat spustenie prikazov pomocou 'at'-u?

```bash
at now + 1m shutdown # -bash: at: command not found
```

---

6. Vyskusajte si, ako funguje prikaz 'crontab'. Zabezpecte, ze kazdych 10
minut Vas virtualny pocitac posle spravu vsetkym prihlasenym uzivatelom a
informuje ich, kolko je prave hodin. Samozrejme, mal by to robit iba v
case cviceni. S akou presnostou sa vlastne da nacasovat spustanie
prikazov z 'cron'-u?

Poznamocka: Asi sa Vam zidu prikazy "write" a "wall".

#### riešenie

- add to crontab following line: `* * * * * /usr/bin/wall $(time)`


### Konfigurǎcia TCP/IP

1. Aby sa sietova karta dala pouzivat, treba ju nakonfigurovat. Vsetky
virtualne pocitace su momentalne zapojene do jednej velkej spolocnej
siete. Tak si ich vhodnym sposobom nakonfigurujte! V tejto sieti maju
adresy tvar 10.0.0.x, kde x je cislo vasho virtualneho pocitaca -- to
iste cislo, ako pouzivate pri pripajani sa na svoj pocitac (ak napriklad
mate prideleny port 44123, tak si pocitac nakonfigurujte tak, aby mal IP
adresu 10.0.0.123).

Aj ked to uz bolo skryte povedane, pre istotu zdoraznime, ze maska tejto
siete ma 24 bitov.

Poznamka: Ako urcite viete, hladanym prikazom je 'ifconfig'.

#### riešenie

```bash
ifconfig eth0 10.0.0.224 netmask 255.255.255.0
```

---

2. Ak ste si siet spravne skonfigurovali, skuste, ci viete 'ping'-nut
pocitac s IP adresou 10.0.0.254, pripadne pocitace dalsich svojich kolegov.
Vedeli by ste zistit, ktorym z nich sa uz podarilo skonfigurovat si siet?

#### riešenie

```bash
ping 10.0.0.254
# PING 10.0.0.254 (10.0.0.254) 56(84) bytes of data.
# From 10.0.0.224 icmp_seq=1 Destination Host Unreachable
# From 10.0.0.224 icmp_seq=2 Destination Host Unreachable
# From 10.0.0.224 icmp_seq=3 Destination Host Unreachable
```

---

3. Aby ste podobne nastavovania nemuseli robit zakazdym odznova, pozrite si
subor /etc/network/interfaces a upravte ho tak, aby po zapnuti virtualneho
pocitaca bola v tejto podobe siet dostupna "sama od seba".

#### riešenie

```bash
# must adhere to strict syntax rules
cat >> /etc/network/interfaces <<- EOF
auto eth0
iface eth0 inet static
  address 10.0.0.224
  netmask 255.255.255.0
  gateway 10.0.0.254
EOF

service networking restart
```

---

4. Tato siet s virtualnymi pocitacmi nie je jedina, okrem nej existuje aj
siet 192.168.0.0/24 (viete, co tento zapis znamena?). Navyse, ony su tie
siete prepojene prostrednictvom pocitaca s IP adresou 10.0.0.254 (ktory
je z druhej strany viditelny ako 192.168.0.254).

Ako ho skonfigurovat tak, aby ste mohli priamo zo svojho virtualneho
pocitaca pristupovat k pocitacom v onej sieti?

Poznamka: Uzitocny by mohol byt prikaz 'route'.

#### riešenie

```bash
route add -net 192.168.0.0 netmask 255.255.255.0 gw 10.0.0.254 # add network routing table to ip with mask and gateway
```

---

5. Uspesnost splnenia ulohy 4 si overite lahko -- staci skusit pingnut
pocitac s IP adresou 192.168.0.1; ak sa to podari, zozali ste uspech.
Nachadzaju sa v tej sieti aj nejake dalsie pocitace?

#### riešenie

```bash
ping 192.168.0.254
#PING 192.168.0.254 (192.168.0.254) 56(84) bytes of data.
#From 10.0.0.224 icmp_seq=1 Destination Host Unreachable
#From 10.0.0.224 icmp_seq=2 Destination Host Unreachable
#From 10.0.0.224 icmp_seq=3 Destination Host Unreachable
```

---

6. Predstavte si, ze namiesto jednej malickej "sietky", je mozne sa
prostrednictvom pocitaca 192.168.0.254 dostat na cely Internet. Ako by
ste nastavili routovanie v tomto pripade?

#### riešenie

```bash
route add default gw 10.0.0.254 # ads default route to internet via gateway
```
---

7. Nuz a ak sa to vsetko podarilo uspesne zrealizovat, je cas na male
aritmeticke cvicenie :-) Doplnte chybajuce udaje do doleuvedenej tabulky:

| Pocitac v sieti | Adresa siete   | Maska siete    | Broadcast adresa |
| --------------- | -------------- | -------------- | ---------------- |
| 198.81.129.100  |                | /18            |                  |
| 158.195.16.244  |                | 255.255.254.0  |                  |
| 18.7.22.83      |                | /8             |                  |

#### riešenie

| Pocitac v sieti | Adresa siete   | Maska siete    | Broadcast adresa |
| --------------- | -------------- | -------------- | ---------------- |
| 198.81.129.100  | 198.81.128.0   | 255.255.192.0  | 198.81.191.255   |
| 158.195.16.244  | 158.195.15.0   | 255.255.254.0  | 158.195.16.255   |
| 18.7.22.83      | 18.0.0.0       | 255.0.0.0      | 18.255.255.255   |

### Konfigurǎcia TCP/IP 2.0

1. Najprv si pekne zopakujete, co bolo na minulom cviceni -- t.j.
skonfigurovat si siet, vyskusat, ci uz funguje aj routovanie do tej
druhej "siete", ci tam niekto odpoveda, kto vsetko je na sieti, ...

---

2. Pozrite si subor /etc/inetd.conf a zistite, ktore sluzby vas pocitac
poskytuje, resp. moze poskytovat. Skonfrontujte jeho obsah s vystupom
programu "netstat". Zistite tiez, na co sluzia parametre -a, -n, -p
programu netstat.

---

3. Okrem klasickej sluzby "telnet", ktoru ste urcite nasli v subore
inetd.conf, by ste si chceli vyrobit "zaloznu" verziu telnetu --
taky telnet, ktory by bezal na porte 31415. Aby sme si toto cislo
nemuseli pamatat, nazvime si tuto novu sluzbu "supertelnet". Po spravnom
nastaveni by teda malo byt mozne napisat "telnet 127.0.0.1 supertelnet"
a malo by to mat ocakavany efekt.

Dobra rada nad zlato: Telnet v telnete nie je vzdy to prave orechove.
Pomoct moze CTRL+] a potom prikaz "set escape ^^".

Dobra rada #2: Ano, predchadzajuca rada takmer iste vyzaduje podrobnejsie
vysvetlenie :-)

#### riešenie

```bash
echo 'supertelnet     stream  tcp     nowait  root    /usr/sbin/tcpd  /usr/sbin/telnetd' >> /etc/inetd.conf
echo 'supertelnet 31415/tcp' >> /etc/services
telnet 127.0.0.1 supertelnet
```

---

4. Pozrite si subory /etc/hosts.allow a /etc/hosts.deny. Viete, na co sluzia
a aky je ich format? Vedeli by ste zabezpecit, aby k novej sluzbe
"supertelnet" mal pristup iba jeden konkretny pocitac a nie vsetky?

#### riešenie

```bash
echo 'in.telnetd: ALL' >> /etc/hosts.deny
echo 'in.telnetd: 192.168.0.220' >> /etc/hosts.allow
telnet 127.0.0.1 supertelnet
```

---

V pripade, že chceme rozlíšiť telnet a supertelnet, musíme v `/etc/inetd.conf` spusti symlinku `/usr/sbin/telnetd` -> `/usr/sbin/telnetd`.

5. Ked uz ten supertelnet (alebo aj normalny telnet) mate, mozete sa pobavit
tym, ze si budete navzajom skakat z pocitaca na pocitac a naspat,
popripade si v tom budete navzajom branit :-)

### NFS

1. Na serveri s IP adresou 192.168.0.1 je pristupny nejaky adresar. Zistite,
o ktory adresar ide, namountujte si ho a pozrite si jeho obsah.

Hint: Mozno sa bude hodit prikaz 'showmount'.

Poznamka: na mountovanie budede musiet pouzit prepinac: -o vers=3

#### riešenie

```bash
mount -t nfs 192.168.0.1:/export /mnt
```

---

2. Pokuste sa vyzdielat niektory z adresarov svojho virtualneho pocitaca,
podobne, ako to je spravene na onom serveri. Ci sa to podarilo, si mozete
lahko overit -- staci sa spytat ktorehokolvek kolegu ci kolegyne. :-)
Zistite ako sa budu spravat symlinky na subory mimo vyzdielaneho
adresara, prip. linky na neexistujuce subory.

#### riešenie

```bash
mkdir /export
echo "/export 10.0.0.0/24(ro,sync,no_subtree_check) 127.0.0.1/24(ro,sync,no_subtree_check)" >> /etc/exports

exportfs -r # reload from config
```

---

3. Pozrite si subor /etc/resolv.conf na lokalnych pocitacoch. Je jasne, co
sa v nom nachadza? Vedeli by ste vyrobit subor podobneho obsahu, keby
sme napriklad povedali, ze Vas pocitac patri do domeny zimmerman.net
a ako nameserver ma pouzivat pocitac s adresou 192.168.12.5?


```bash
cat >> /etc/hosts <<- EOF
domain zimmerman.net
nameserver 192.168.12.5
EOF
```
