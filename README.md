# VQE_paper — figure reproduction

Self-contained reproduction of the **data figures** in the manuscript

> *Optimizing resource allocation for accuracy in noisy variational quantum algorithms*
> H. Verma, T. Ayral, A. Auffèves, R. Whitney.

It bundles the four figure-producing notebooks and the **already-generated data**
they consume (raw VQE convergence pickles + realistic-hardware QPU dumps), copied
from the `eviden/VQE` working repository. No quantum simulation is re-run here —
the notebooks only load the saved data and render figures.

Schematic / circuit-diagram figures are **not** reproduced (they are drawn by hand,
not from data): **Fig. 1** (VQE loop), **Fig. 2** (HVA circuit), **Fig. 3**
(transpiled circuit), **Fig. 11** (RYA circuit).

## Figure → notebook map

| Manuscript figure | Notebook | Output file(s) in `figures/` |
|---|---|---|
| **Fig. 4** — HVA noiseless convergence `E(Nit)` and `E∞(Ng)` | `heisenberg_hva_noisy_comp.ipynb` | `noiseless_conv_en_fit_COBY_inset.png`, `noiseless_E_t_inset.png` |
| **Fig. 5** — convergence rate `µ(Ng)`, noiseless + noisy | `heisenberg_hva_noisy_comp.ipynb` | `noisy_noiseless_conv_COBY.png`, `noisy_alpha_fit_COBY*.png` |
| **Fig. 6** — noisy converged `E∞(Ng)` (U-shape vs ε) | `heisenberg_hva_noisy_comp.ipynb` | `noisy_alpha_fit_shifted_COBY.png` |
| **Fig. 7** — resource `∆` and efficiency `η` heatmaps + red stars | `heisenberg_hva_noisy_comp.ipynb` | `resource_heatmap.png`, `efficiency_heatmap.png` |
| **Fig. 8** — optimal `Ng` vs `∆` (transcendental solution) | `transcendental_ng_solver.ipynb` | `notebooks/optimal_ng_delta_corrected.png` |
| **Fig. 9** — max metric / min error vs `∆` (+ efficiency inset) | `heisenberg_hva_noisy_comp.ipynb` | `Error_vs_fixed_resources_with_inset.png` |
| **Fig. 10** — realistic-hardware validation (IBM Nighthawk) | `qpu_phenomenological_relations.ipynb` | `fig10_FakeNighthawk.png` |
| **Fig. 12** — RYA noiseless convergence (appendix) | `heisenberg_rya_noisy_comp.ipynb` | `*_rya.png` |
| **Fig. 13** — RYA `µ(Ng)` (appendix) | `heisenberg_rya_noisy_comp.ipynb` | `noisy_*_rya.png` |
| **Fig. 14** — RYA noisy converged `E∞(Ng)` (appendix) | `heisenberg_rya_noisy_comp.ipynb` | `noisy_noiseless_conv_COBY_rya.png` |

> The Fig. 10 notebook also renders the same panel for three non-manuscript QPUs
> (Marrakesh / IonQ / IQM) and a cross-QPU summary — these are extra and can be
> ignored; the manuscript figure is `fig10_FakeNighthawk.png`.

## Data provenance

Copied verbatim from `eviden/VQE`:

- `archive/heisenberg_n5/{hva,rya}/Results/` — 50-seed noiseless (`noiseless_COBY_50_seeds.pkl`)
  and per-ε noisy (`global_noisy_gates_seeds_assumptions_COBY_scipy/noisy-<base>_<expo>.pkl`,
  ε ∈ {1e-3,1e-4,1e-5,1e-6,5e-4,5e-5,5e-6}) COBYLA convergence trajectories.
- `results/hardware/` — IBM Nighthawk per-seed pickles (`ibm_nighthawk_{baseline,zne}_raw.pkl`)
  plus `ibm_marrakesh_data.json`, `ionq_forte_data.json`, `iqm_apollo_data.json`.

These binaries (~2.6 GB) are **git-ignored** (see `.gitignore`) — they live in the
working tree but are not committed, mirroring the source repo's convention. Only the
notebooks and this documentation are tracked in git.

## Run

```bash
python -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
./run_all.sh                 # executes all four notebooks -> figures/
```

Or run a single notebook (each expects to run from `notebooks/`):

```bash
cd notebooks
jupyter nbconvert --to notebook --execute --inplace heisenberg_hva_noisy_comp.ipynb
```

Only NumPy / SciPy / Matplotlib / Jupyter are needed — no Qiskit or myQLM, since the
data is already generated.
