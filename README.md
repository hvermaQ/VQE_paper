# VQE_paper — figure reproduction

Self-contained reproduction of the **data figures** in the manuscript

> *Optimizing resource allocation for accuracy in noisy variational quantum algorithms*
> H. Verma, T. Ayral, A. Auffèves, R. Whitney — [arXiv:2606.20153](https://arxiv.org/abs/2606.20153)

The paper studies a Variational Quantum Eigensolver (VQE) for a **5-spin open
Heisenberg chain** (`J = 1`, exact `E_gs = -7.712`), and extracts phenomenological
scaling relations linking the algorithm's accuracy, the noise strength `ε`, and the
algorithmic resource cost `∆ = N_g·N_it` (gate count × iterations). Two ansätze are
used — the **HVA** (`N_g = 150·N_layers + 15`) in the main text and the
**RYA** (`N_g = 25·N_layers + 5`) in Appendix A — optimized with COBYLA over
50 random seeds (20 seeds for the hardware run). Noise is modelled as global
depolarizing (`ε ∈ {1e-6 … 1e-3}`), and the hardware validation adds error
mitigation (ZNE gate-folding + Pauli twirling via Mitiq).

This repo bundles the four **figure notebooks** and the **already-generated data**
they consume (raw VQE convergence pickles + FakeNighthawk QPU dumps). No quantum
simulation is re-run to make the figures — the notebooks only load the saved data
and render figures. For provenance, the `gen_*` **generation notebooks** also carry
the original data-generation code (myQLM for HVA/RYA, Qiskit for the IBM data).

## Repository layout

```
VQE_paper/
├── notebooks/
│   ├── analysis/                      # figure notebooks (load results/ → write figures/)
│   │   ├── heisenberg_hva_noisy_comp.ipynb    # Figs 4, 5, 6, 7, 9
│   │   ├── heisenberg_rya_noisy_comp.ipynb    # Figs 12, 13, 14 (appendix)
│   │   ├── transcendental_ng_solver.ipynb     # Fig 8
│   │   └── analyze_qpu_data.ipynb             # Fig 10 (IBM Nighthawk + mitigation)
│   └── data_generation/               # original data-generation code (reference only)
│       ├── gen_hva_myqlm_noiseless.ipynb
│       ├── gen_hva_myqlm_noisy.ipynb
│       ├── gen_rya_myqlm_noiseless.ipynb
│       ├── gen_rya_myqlm_noisy.ipynb
│       ├── gen_ibm_qisk_noisy_baseline.ipynb
│       └── gen_ibm_qisk_zne_mitiq_v5.ipynb
├── results/                           # already-generated data (git-ignored, ~2.6 GB)
│   ├── heisenberg_n5/{hva,rya}/Results/…       # myQLM convergence trajectories
│   └── hardware/…                              # FakeNighthawk QPU dumps
├── figures/                           # figure outputs (regenerated; git-ignored)
├── run_all.sh                         # execute all four figure notebooks
└── requirements.txt                   # NumPy / SciPy / Matplotlib / Jupyter
```

Schematic / circuit-diagram figures are **not** reproduced (they are drawn by hand,
not from data): **Fig. 1** (VQE loop), **Fig. 2** (HVA circuit), **Fig. 3**
(transpiled circuit), **Fig. 11** (RYA circuit).

## Figure → notebook map

| Manuscript figure | Notebook (`notebooks/analysis/`) | Output(s) in `figures/` |
|---|---|---|
| **Fig. 4** — HVA noiseless convergence `E(N_it)` and `E∞(N_g)` | `heisenberg_hva_noisy_comp.ipynb` | `noiseless_E_t_inset.png`, `noiseless_conv_en_fit_COBY_inset.png` |
| **Fig. 5** — convergence rate `µ(N_g)`, noiseless + noisy | `heisenberg_hva_noisy_comp.ipynb` | `noisy_noiseless_conv_COBY.png` |
| **Fig. 6** — noisy converged `E∞(N_g)` (U-shape vs `ε`) | `heisenberg_hva_noisy_comp.ipynb` | `noisy_alpha_fit_shifted_COBY.png` |
| **Fig. 7** — resource `∆` and efficiency `η` heatmaps + red stars | `heisenberg_hva_noisy_comp.ipynb` | `resource_heatmap.png`, `efficiency_heatmap.png` |
| **Fig. 8** — optimal `N_g` vs `∆` (transcendental solution) | `transcendental_ng_solver.ipynb` | `optimal_ng_delta_corrected.png` |
| **Fig. 9** — max metric / min error vs `∆` (+ efficiency inset) | `heisenberg_hva_noisy_comp.ipynb` | `Error_vs_fixed_resources_with_inset.png` |
| **Fig. 10** — realistic-hardware validation (FakeNighthawk + mitigation) | `analyze_qpu_data.ipynb` | `Einf_fit.pdf`(+`_loglin`), `depol_residual_signed.png`, `depol_residual_abs.pdf`, `convergence_{noiseless,mitigated}.pdf`, `fit_params_table.pdf` |
| **Fig. 12** — RYA noiseless convergence (appendix) | `heisenberg_rya_noisy_comp.ipynb` | `noiseless_E_t_inset_rya.png`, `noiseless_conv_en_fit_COBY_inset_rya.png` |
| **Fig. 13** — RYA `µ(N_g)` (appendix) | `heisenberg_rya_noisy_comp.ipynb` | `noisy_noiseless_conv_COBY_rya.png` |
| **Fig. 14** — RYA noisy converged `E∞(N_g)` (appendix) | `heisenberg_rya_noisy_comp.ipynb` | `noisy_alpha_fit_shifted_COBY_rya.png` |

> **Extra (non-manuscript) outputs.** The RYA notebook also emits RYA analogues of the
> HVA resource/efficiency plots (`resource_heatmap_rya.png`, `efficiency_heatmap_rya.png`,
> `Error_vs_fixed_resources_with_inset_rya.png`); these are not paper figures.
> `analyze_qpu_data.ipynb` corresponds to panels (a) and (b) of Fig. 10 (converged
> energy fit and the global-depolarizing residual) plus convergence-trajectory panels
> and a fit-parameter table; the `µ(N_g)` panel (c) is present but its `savefig` is
> commented out.

## Data (already generated)

All data lives under `results/`. These binaries (~2.6 GB) are **git-ignored** (see
`.gitignore`) — they live in the working tree but are not committed; only the
notebooks and this documentation are tracked in git.

- **`results/heisenberg_n5/{hva,rya}/Results/`** — myQLM COBYLA convergence trajectories:
  - `noiseless_COBY_50_seeds.pkl` — 50-seed noiseless run (all `N_layers`).
  - `global_noisy_gates_seeds_assumptions_COBY_scipy/noisy-<base>_<expo>.pkl` — per-`ε`
    noisy runs, where `ε = base × 10^-expo`. The seven files cover
    `ε ∈ {1e-6, 5e-6, 1e-5, 5e-5, 1e-4, 5e-4, 1e-3}`.
- **`results/hardware/`** — Qiskit FakeNighthawk per-seed dumps (20 seeds), each a dict
  holding `noiseless_results`, `mitigated_results`, `exact_energy`, and the noiseless
  fit parameters `beta_fit` / `kappa_fit` / `eps_eff`:
  - `ibm_nighthawk_baseline_raw.pkl` — raw noisy, no mitigation.
  - `ibm_nighthawk_zne_raw.pkl` — with ZNE gate-folding + Pauli twirling.

## Data generation (reference only)

The notebooks in `notebooks/data_generation/` are the **original code that produced the
data above**. They are included for provenance/reproducibility only — they are **not**
needed to render the figures, they require their own heavy environments (myQLM / `qat`
for HVA/RYA, and the Qiskit + Aer + `qiskit-ibm-runtime` + Mitiq stack for IBM), and
re-running them takes hours.

| Generation notebook | Environment | Produces |
|---|---|---|
| `gen_hva_myqlm_noiseless.ipynb` | myQLM (`qat`) | `heisenberg_n5/hva/.../noiseless_COBY_50_seeds.pkl` |
| `gen_hva_myqlm_noisy.ipynb` | myQLM (`qat`) | `heisenberg_n5/hva/.../noisy-<base>_<expo>.pkl` (per `ε`) |
| `gen_rya_myqlm_noiseless.ipynb` | myQLM (`qat`) | `heisenberg_n5/rya/.../noiseless_COBY_50_seeds.pkl` |
| `gen_rya_myqlm_noisy.ipynb` | myQLM (`qat`) | `heisenberg_n5/rya/.../noisy-<base>_<expo>.pkl` (per `ε`) |
| `gen_ibm_qisk_noisy_baseline.ipynb` | Qiskit + Aer | `hardware/ibm_nighthawk_baseline_raw.pkl` |
| `gen_ibm_qisk_zne_mitiq_v5.ipynb` | Qiskit + Aer + Mitiq | `hardware/ibm_nighthawk_zne_raw.pkl` |

The myQLM noisy generators are run once per `ε` (7 noise levels). The IBM generators
are the qisk scripts `vqe_noisy_baseline.py` / `vqe_zne_mitiq_v5.py` wrapped as
notebooks; their output pickles are renamed to the `ibm_nighthawk_*` files consumed by
`analyze_qpu_data.ipynb`.

## Run

Only NumPy / SciPy / Matplotlib / Jupyter are needed — no Qiskit or myQLM, since the
data is already generated.

```bash
python -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
./run_all.sh                 # executes all four analysis notebooks -> figures/
```

Or run a single notebook (each is wired to `../../results/` and `../../figures/`, so
execute it in place from `notebooks/analysis/`):

```bash
cd notebooks/analysis
jupyter nbconvert --to notebook --execute --inplace heisenberg_hva_noisy_comp.ipynb
```

`run_all.sh` passes `--allow-errors`: a couple of notebooks carry extra exploratory
cells *after* their manuscript figures (e.g. the transcendental notebook's
"crossover analysis" following Fig. 8). Those are not paper figures and are allowed
to fail without aborting the run.
