#!/usr/bin/env bash
set -euo pipefail
mkdir -p results/filtered
for acc in 30760182 30760183 30760184 30760185 30760187 30760188 30760189 30760190 30760191 30760192; do
cat data/SRR${acc}.fastq | chopper -q 7 -l 200 -t 4 > results/filtered/SRR${acc}.q7.fastq
done
# SRR30760186: plain file plus _1 only (_2 treated as a duplicate pending the test)
cat data/SRR30760186.fastq data/SRR30760186_1.fastq | chopper -q 7 -l 200 -t 4 > results/filtered/SRR30760186.q7.fastq
