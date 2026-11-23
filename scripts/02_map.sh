#!/usr/bin/env bash
set -euo pipefail
REF=data/AY988601.fasta
mkdir -p results/bam
for fq in results/filtered/*.q7.fastq; do
id=$(basename "$fq" .q7.fastq)
minimap2 -ax map-ont -t 4 "$REF" "$fq" 2> "results/bam/${id}.minimap2.log" | samtools sort -@ 4 -o "results/bam/${id}.bd.bam"
samtools index "results/bam/${id}.bd.bam"
done
printf "sample\tpct_1x\tmean_depth\tpct_20x\n" > results/mapping_summary.tsv
for bam in results/bam/*.bd.bam; do
id=$(basename "$bam" .bd.bam)
cov=$(samtools coverage "$bam" | awk 'NR==2 {print $6"\t"$7}')
d20=$(samtools depth -a "$bam" | awk '$3>=20 {c++} END {printf "%.1f", 100*c/NR}')
printf "%s\t%s\t%s\n" "$id" "$cov" "$d20" >> results/mapping_summary.tsv
done
column -t results/mapping_summary.tsv
