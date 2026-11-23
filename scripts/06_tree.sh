#!/usr/bin/env bash
set -euo pipefail
mkdir -p results/tree
MAIN="SRR30760182 SRR30760184 SRR30760185 SRR30760187 SRR30760188 SRR30760190 SRR30760191 SRR30760192"
for s in $MAIN; do cat results/consensus/${s}.fasta; done > results/tree/main_ours.fa
cat results/tree/main_ours.fa data/AY988601.fasta data/MH396625.fasta data/NC_002728.1.fasta | sed '/^>/ s/ .*//' > results/tree/tree_input.fa
mafft --auto --thread 4 results/tree/tree_input.fa > results/tree/tree_input.aln.fa
iqtree3 -s results/tree/tree_input.aln.fa -st DNA -m MFP -B 1000 -T AUTO --prefix results/tree/niv -o NC_002728.1 -seed 12345 -redo
cat results/consensus/SRR*.fasta data/AY988601.fasta data/MH396625.fasta data/NC_002728.1.fasta | sed '/^>/ s/ .*//' > results/tree/tree_all.fa
mafft --auto --thread 4 results/tree/tree_all.fa > results/tree/tree_all.aln.fa
iqtree3 -s results/tree/tree_all.aln.fa -st DNA -m TIM2+F+G4 -B 1000 -T 2 --prefix results/tree/niv_all -o NC_002728.1 -seed 12345 -redo
