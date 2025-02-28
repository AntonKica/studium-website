+++
layout = 'subject-info'
title = 'Manažment dát'

[params.links.fmfi]
name = 'Stránka predmetu'
url = 'https://compbio.fmph.uniba.sk/vyuka/mad/index.php/Materials'
+++

Pripojenie sa na Linux:

```bash
ssh <aisusername>@compbio.fmph.uniba.sk -XC # -X is for X11 session, -C is for compression
```

## Úlohy

### [2025-02-20] Perl

Makefile pre zbehnutie všetkých skriptov a skopírovanie súborov na odozvdanie:
```makefile
AIS_USERNAME=kica6
SUBMISSION_FOLDER=/submit/perl/${AIS_USERNAME}/

submit: run
        cp series-stats.pl series-stats.txt fastq2fasta.pl reads-tiny.fasta reads-small.fasta ${SUBMISSION_FOLDER}
        cp fastq-quality.pl reads-qualities.tsv fastq-trim.pl reads-small-trim.fastq reads-trim-qualities.tsv ${SUBMISSION_FOLDER}
        cp protocol.txt ${SUBMISSION_FOLDER}
        echo "Resulting submission: "
        ls -lA ${SUBMISSION_FOLDER}

run:
        ./series-stats.pl < /tasks/perl/series.tsv > series-stats.txt
        ./fastq2fasta.pl < /tasks/perl/reads-tiny.fastq > reads-tiny.fasta
        ./fastq2fasta.pl < /tasks/perl/reads-small.fastq > reads-small.fasta
        ./fastq-quality.pl < /tasks/perl/reads.fastq | perl -lane 'print if $F[0] % 10 == 0' > reads-qualities.tsv
        ./fastq-trim.pl '(' 95 < /tasks/perl/reads-small.fastq > reads-small-trim.fastq # quality ASCII >= 40
```

### [2025-02-27] Bash
Makefile:
```makefile
AIS_USERNAME=kica6
SUBMIT_DIRECTORY=/submit/bash/$(AIS_USERNAME)

submit: run
        @echo "[Submitting]"
        cp -pv protocol.txt human.txt pairs.txt similar.tsv best.txt function.txt passwords.csv $(SUBMIT_DIRECTORY)
run:
        @echo "[Running commands]"
        cat human.fa | grep -e '^>' | sed 's/>\(.*\) OS=.*$$/\1/'|sort > human.txt
        cat matches.tsv | grep -ve '^#' |  sort | cut -f1,2 | tr '\t' ' ' | uniq  > pairs.txt
        cat matches.tsv | grep -ve '^#' | awk -F '\t' '{ if ($$3 >= 90) print }' > similar.tsv
        cat matches.tsv | grep '^#' -A 1 | grep -v -e '^#' -e '^--$$' | cut -f1,2 | sort -k2 >  best.txt
        join best.txt human.txt -12 | sort -k2 > function.txt
        pwgen -1 -N $$(cat names.txt | wc -l) | paste -d' ' names.txt - | sed -e 's/\(.\+\) \([^ ]\+\) \(.\+\)@uniba\.sk \(.\+\)$$/\3,\2,\1,\4/' > passwords.csv
```
