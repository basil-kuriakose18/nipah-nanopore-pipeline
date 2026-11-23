#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
for acc in $(seq 30760182 30760192); do
fasterq-dump SRR${acc} -O data -e 4
done
for acc in AY988601 MH396625 NC_002728.1; do
wget -q -O data/${acc}.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${acc}&rettype=fasta&retmode=text"
sleep 1
done
