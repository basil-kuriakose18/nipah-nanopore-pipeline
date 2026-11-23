#!/usr/bin/env bash
set -euo pipefail
mkdir -p data/published results
for acc in PP981676 PP981677 PP981678 PP981679 PP981680 PP981681 PP981682 PP981683 PQ368168 PQ368169 PQ368170; do
wget -q -O data/published/${acc}.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${acc}&rettype=fasta&retmode=text"
sleep 1
done
cat results/consensus/SRR*.fasta data/published/*.fasta > results/ours_vs_published.fa
mafft --auto --thread 4 results/ours_vs_published.fa > results/ours_vs_published.aln.fa
python scripts/04_compare.py results/ours_vs_published.aln.fa > results/published_comparison.tsv
column -t results/published_comparison.tsv
