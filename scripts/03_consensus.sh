#!/usr/bin/env bash
set -euo pipefail
REF=data/AY988601.fasta
MIN_DP=20
MIN_AF=0.7
mkdir -p results/vcf results/consensus
printf "sample\tsnps\tN_bases\tpct_called\n" > results/consensus_summary.tsv
for bam in results/bam/SRR*.bd.bam; do
id=$(basename "$bam" .bd.bam)
bcftools mpileup -f "$REF" -d 10000 -B -I -Q 7 -a FORMAT/AD,FORMAT/DP "$bam" | bcftools call -m -v --ploidy 1 -Ov -o "results/vcf/${id}.raw.vcf"
bcftools view -i "FORMAT/DP>=${MIN_DP} && FORMAT/AD[0:1]/FORMAT/DP>=${MIN_AF}" "results/vcf/${id}.raw.vcf" -Oz -o "results/vcf/${id}.filt.vcf.gz"
bcftools index -f "results/vcf/${id}.filt.vcf.gz"
samtools depth -a "$bam" | awk -v d="$MIN_DP" '$3<d {print $1"\t"$2-1"\t"$2}' > "results/consensus/${id}.mask.bed"
bcftools consensus -f "$REF" -m "results/consensus/${id}.mask.bed" "results/vcf/${id}.filt.vcf.gz" | sed "1s/.*/>${id}/" > "results/consensus/${id}.fasta"
snps=$(bcftools view -H "results/vcf/${id}.filt.vcf.gz" | wc -l)
len=$(grep -v '>' "results/consensus/${id}.fasta" | tr -d '\n' | wc -c)
nn=$(grep -v '>' "results/consensus/${id}.fasta" | tr -d '\n' | tr -cd 'Nn' | wc -c)
awk -v s="$id" -v v="$snps" -v n="$nn" -v l="$len" 'BEGIN {printf "%s\t%s\t%s\t%.1f\n", s, v, n, 100*(l-n)/l}' >> results/consensus_summary.tsv
done
column -t results/consensus_summary.tsv
