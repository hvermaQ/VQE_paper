#!/usr/bin/env bash
# Execute the four figure-producing notebooks; each saves its figures into
# ../figures/ (Fig 8 lands in notebooks/). Run from the repo root.
set -euo pipefail
cd "$(dirname "$0")/notebooks"

NOTEBOOKS=(
  heisenberg_hva_noisy_comp        # Figs 4, 5, 6, 7, 9
  heisenberg_rya_noisy_comp        # Figs 12, 13, 14 (appendix)
  transcendental_ng_solver         # Fig 8
  qpu_phenomenological_relations   # Fig 10 (IBM Nighthawk)
)

for nb in "${NOTEBOOKS[@]}"; do
  echo "==> executing $nb.ipynb"
  # --allow-errors: some notebooks carry extra exploratory cells beyond the paper
  # figures (e.g. the transcendental notebook's post-Fig-8 crossover analysis);
  # the manuscript figures are saved before those, so don't abort the run on them.
  jupyter nbconvert --to notebook --execute --inplace --allow-errors \
    --ExecutePreprocessor.timeout=2400 "$nb.ipynb"
done

echo "==> done. Figures in ./figures/ (Fig 8: notebooks/optimal_ng_delta_corrected.png)"
