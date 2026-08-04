# MSc Grid-Cell CAN Project

A continuous attractor network (CAN) model of grid cells to ask whether the
60°/90° Fourier symmetry biomarker of Ying et al. (2023) can be reproduced by
localised synaptic damage and by afferent velocity noise.

The analysis pipeline is validated against Ying et al.'s released data before
being applied to model output.

---

## Third-party code is **not** included

Two dependencies are required but absent, below are the downloading links:

### 1. CMBHOME (Hasselmo Lab, Boston University)

Bill Chapman and Andrew Bogaard — <https://github.com/wchapman/CMBHOME>

Provides `moserac`, `Utils.extrema2`, `Utils.EllipseDirectFit`,
`Utils.EllipseFromCoef` and `Session.Gridness`, which supply the autocorrelogram,
grid spacing and gridness score.

```
MSc-Grid-Cell-CAN-Project/
└── CMBHOME-master/
    └── +CMBHOME/          <- the package folder; its PARENT goes on the path
```

`startup_paths.m` adds `CMBHOME-master`, not `+CMBHOME`.

**One local modification is required.** In `+CMBHOME/@Session/ValidCells.m`,
comment out `disp('No cells in session object')`.

### 2. Code for Ying et al. (2023)

Johnson Ying — <https://github.com/johnson-ying/Code-for-Ying-et-al.-2023>

Provides `rotateAround` (used by the Voronoi shuffle) and the reference
implementation the analysis pipeline was validated against.

```
MSc-Grid-Cell-CAN-Project/
└── Code-for-Ying-et-al.-2023-main/
    └── Figure_2/rotateAround/
```

The repository is ~5 GB because of `session_data/` and `grid data/`. Only the
`.m` files are needed to run this project; the data is required only to re-run
`validation/validate_against_ying.m`.

### Included third-party file

`analysis/VoronoiLimit.m` (Jakob Sievers, Aarhus University) **is** included —
it is BSD-3-Clause, and `analysis/VoronoiLimit_LICENSE.txt` carries the notice as
that licence requires.

---

## Setup

```matlab
run('<project root>/startup_paths.m')
```

Adds `model/`, `analysis/`, `hpc/`, `aggregate/`, `validation/`, `CMBHOME-master/`
and Ying's `rotateAround/` to the path.

Developed on MATLAB R2025b; the cluster runs R2024b.

---

## Layout

| Folder | Contents |
|---|---|
| `model/` | CAN simulations. `gc_periodic_baseline` (healthy), `gc_periodic_alpha` (Zhi & Cox damage), `gc_periodic_noise` (Nagaraj & Narayanan velocity noise), and `gc_dynamics` as the entry point |
| `analysis/` | `population_fourier_analysis` — the Fourier pipeline, Voronoi noise baseline, spacing and gridness. `plot_band_phase` builds the phase diagrams |
| `hpc/` | PBS array-job drivers for the parameter sweeps |
| `aggregate/` | Sweep aggregation |
| `validation/` | Reproduction of Ying et al.'s published values, plus regression tests |

`docs/`, `outputs/`, `figures/` and `results/` are untracked — see `.gitignore`.

---

## Running

Single condition:

```matlab
gc_dynamics()                    % healthy baseline
gc_dynamics('alpha', 0.7, 30)    % damage: severity 0.7, lesion radius 30 neurons
gc_dynamics('noise', 0.5)        % afferent velocity noise, sigma_v = 0.5 m/s
```

Each analyses the same 78 tracked cells the sweep uses, so a single run is
directly comparable with a phase-diagram grid point.

Sweep (Imperial CX3):

```bash
qsub -J 1-18768 hpc/band3.pbs
matlab -nodisplay -batch "plot_band_phase('output_band3')"
```

Re-plot locally from a saved grid, without re-aggregating 18,767 files:

```matlab
plot_band_phase(fullfile('outputs','phase_band_all_pop.mat'))
```

---

## References

- Ying, J. et al. (2023). Grid cell disruption in a mouse model of early
  Alzheimer's disease reflects reduced integration of self-motion cues.
  *Current Biology* 33, 2425–2437.
- Burak, Y. & Fiete, I. R. (2009). Accurate path integration in continuous
  attractor network models of grid cells. *PLoS Computational Biology* 5, e1000291.
- Zhi, Y. & Cox, C. (2021). Synaptic damage in a continuous attractor model of
  grid cells.
- Nagaraj, D. & Narayanan, R. (2024). Afferent noise in a continuous attractor
  network model of grid cells.
- Krupic, J. et al. Fourier decomposition of spatial firing patterns; source of
  the Voronoi field-shuffle null.
- Chapman, B. & Bogaard, A. CMBHOME: a custom MATLAB class for neural data.
  Boston University. <https://github.com/wchapman/CMBHOME>
- Sievers, J. VoronoiLimit. BSD-3-Clause.
