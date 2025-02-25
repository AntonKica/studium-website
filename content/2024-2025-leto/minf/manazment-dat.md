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
```Makefile
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
