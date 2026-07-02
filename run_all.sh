#!/usr/bin/env bash
# Execute the four figure-producing notebooks in notebooks/analysis/. Each loads
# pre-generated data from results/ and writes its figures into figures/.
# Run from anywhere; paths are resolved relative to this script.
set -euo pipefail
cd "$(dirname "$0")/notebooks/analysis"

NOTEBOOKS=(
  heisenberg_hva_noisy_comp        # Figs 4, 5, 6, 7, 9
  heisenberg_rya_noisy_comp        # Figs 12, 13, 14 (appendix)
  transcendental_ng_solver         # Fig 8
  analyze_qpu_data                 # Fig 10 (IBM Nighthawk, error mitigation)
)

for nb in "${NOTEBOOKS[@]}"; do
  echo "==> executing $nb.ipynb"
  # --allow-errors: some notebooks carry extra exploratory cells beyond the paper
  # figures (e.g. the transcendental notebook's post-Fig-8 crossover analysis);
  # the manuscript figures are saved before those, so don't abort the run on them.
  jupyter nbconvert --to notebook --execute --inplace --allow-errors \
    --ExecutePreprocessor.timeout=2400 "$nb.ipynb"
done

echo "==> done. Figures written to ./figures/"
