#!/usr/bin/env bash
set -euo pipefail
bash scripts/00_download.sh
bash scripts/01_filter.sh
bash scripts/02_map.sh
bash scripts/03_consensus.sh
bash scripts/06_tree.sh
bash scripts/07_compare_published.sh
