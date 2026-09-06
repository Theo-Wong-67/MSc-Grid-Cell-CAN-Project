# MSc Grid-Cell CAN Project

A continuous attractor network (CAN) model of grid cells, used to ask whether the
60 to 90 degree Fourier reorganisation reported by Ying et al. (2023) in a mouse
model of early Alzheimer's disease can be reproduced by localised synaptic damage,
by velocity-input noise, and by the two together.

`Models/` holds the network simulations, `Fourier/` the analysis pipeline and
`figures/` the scripts behind report Figures 2, 4, 7 and B1.
The earlier pipeline this replaced was removed from the repository; it remains in
the commit history before `08e6094`.

---

## Provenance and attribution

This project builds on published methods and released code. Nothing below is
claimed as original where it is not.

| File | What it does | Where it comes from |
|---|---|---|
| `Models/gc_baseline.m`, `gc_alpha.m`, `gc_noise.m`, `gc_sdnoise.m`, `gc_combined.m`, `gc_combined_sd.m` | Sheet dynamics, weight kernel, velocity input and the random-walk trajectory | Transcribed from the MATLAB code released with Burak and Fiete (2009), with their parameters. Walk speed is scaled as in Nagaraj and Narayanan (2024). |
| same files, synaptic damage term | Scaling of recurrent weights by alpha inside a disc of radius R | Zhi and Cox (2021) |
| same files, velocity-noise term | Gaussian white noise, and the signal-dependent variant sigma_t = sigma_v sqrt(v / mu_v) | Nagaraj and Narayanan (2024); the signal-dependent law is this project's extension, derived in the report annex |
| `Models/gc_run.m`, `gc_sweep.m`, `tracked_subset.m` | Condition wrapper, sweep driver, the 78 tracked neurons | This project |
| `Fourier/fourier_power.m` | Zero-padded FFT, normalisation, DC notch, thresholding | Reimplementation of Ying et al. (2023), validated line by line against their released `Grid component extraction.m` |
| `Fourier/fourier_components.m` | Component count, axis angles, 60 and 90 degree gap counts | Reimplementation of Ying et al. (2023), same conventions including the half-pixel centre |
| `Fourier/voronoi_baseline.m` | Field-shuffle noise floor | Method of Krupic et al. (2012); implementation transcribed from Ying et al. (2023). Every deviation from their code is marked `[CHANGED]` or `[ADDED]` in the source, the main one being the field-seeding kernel, which their spike-based seeding map cannot provide for model output. Calls `rotateAround` (Ying) and `VoronoiLimit` (Sievers). |
| `Fourier/ac_metrics.m` | Grid spacing and gridness from the autocorrelogram | Autocorrelogram and gridness are CMBHOME's own functions called directly (`CMBHOME.Utils.moserac`, `CMBHOME.Session.Gridness`). The spacing block is transcribed from CMBHOME `gridDistance.m`. |
| `Fourier/fourier_analysis.m`, `population_fourier_analysis.m` | Per-cell and population wrappers, f60 = n60 / (n60 + n90) | This project |

The pipeline reproduces the published group ratios of Ying et al. (2023) on their
released 171 cells to the reported precision; the comparison and the residual
differences are documented in the report annex.

---

## Third-party code that is required but not included

Neither upstream repository carries a licence, so neither grants redistribution
rights. Download them and place them in the project root.

### 1. CMBHOME (Hasselmo Lab, Boston University)

Bill Chapman and Andrew Bogaard, <https://github.com/wchapman/CMBHOME>

Provides `CMBHOME.Utils.moserac`, `CMBHOME.Utils.extrema2` and
`CMBHOME.Session.Gridness`.

```
MSc-Grid-Cell-CAN-Project/
└── CMBHOME-master/
    └── +CMBHOME/          <- the package folder; its PARENT goes on the path
```

The bundled `chronux` subfolder is unused; do not `genpath` it.

One local edit is needed. In `+CMBHOME/@Session/ValidCells.m`, comment out
`disp('No cells in session object')`. `Session` is used here only as a carrier
for `Gridness` with a precomputed autocorrelogram, so that line fires on every
property access. Behaviour is otherwise unchanged.

### 2. Code for Ying et al. (2023)

Johnson Ying, <https://github.com/johnson-ying/Code-for-Ying-et-al.-2023>

Provides `rotateAround` and `VoronoiLimit` (both under `Figure_2/`; `VoronoiLimit`
is Jakob Sievers' BSD-3-Clause function, redistributed there) and the reference
implementation the analysis pipeline was validated against. Only the `.m` files
are needed; the data trees are required only to re-run the validation.

---

## Setup

```matlab
root = '<project root>';
ying = fullfile(root, 'Code-for-Ying-et-al.-2023-main', 'Figure_2');
addpath(fullfile(root, 'Models'), fullfile(root, 'Fourier'), fullfile(root, 'figures'), ...
        fullfile(root, 'CMBHOME-master'), fullfile(ying, 'rotateAround'), fullfile(ying, 'voronoiLimit'))
```

Developed on MATLAB R2025b; the cluster runs R2024b. Requires the Image
Processing Toolbox and the Statistics and Machine Learning Toolbox; `VoronoiLimit`
additionally requires the Mapping Toolbox.

---

## Running

```matlab
out = gc_run()                              % healthy baseline
out = gc_run(0.85, 21)                      % synaptic damage, alpha = 0.85, R = 21 neurons
out = gc_run([], [], 4.65 * 0.4998)         % Gaussian white velocity noise, sigma_v in m/s
out = gc_run(0.85, 21, 4.65 * 0.4998, 0.43, 1, 'sd')   % damage plus signal-dependent noise, seed 1
```

`out.res` holds the per-cell Fourier results for the 78 tracked neurons and the
population `s60`, `s90` and f60. Sweeps were run on Imperial CX3.

## Figures

| Report | Script | Data it loads |
|---|---|---|
| Figure 2 | `figures/fig02_healthy_exemplar.m` | `log/detail/det_dmg_a150_r01_s1.mat`, one `gc_run` output |
| Figure 4 | `figures/fig04_damage_plane.m` | `agg_merged_run1.mat`, the noise-free plane |
| Figure 7 | `figures/fig07_noise_ladder.m` | `agg_noise.mat`, `agg_constband.mat`, `agg_noise_sd.mat`, `agg_sdband.mat` |
| Figure B1 | `figures/figB1_wavelength_vs_ying.m` | `log/sdn_trial_const.mat` and Ying et al.'s `grid_data.mat` |

`figures/viz.m` carries the shared colours, panel primitives and file output.
The sweep outputs and aggregates are not in the repository and are available on
request; each script writes to `output/` after `viz.nosave(false)`.

---

## References

- Burak, Y. and Fiete, I. R. (2009). Accurate path integration in continuous
  attractor network models of grid cells. PLoS Computational Biology 5, e1000291.
- Giocomo, L. M. et al. (2011). Grid cells use HCN1 channels for spatial
  scaling. Cell 147, 1159 to 1170.
- Krupic, J., Burgess, N. and O'Keefe, J. (2012). Neural representations of
  location composed of spatially periodic bands. Science 337, 853 to 857.
- Nagaraj, D. and Narayanan, R. (2024). Afferent noise in a continuous attractor
  network model of grid cells. bioRxiv, doi 10.1101/2024.09.19.613994.
- Ying, J. et al. (2023). Grid cell disruption in a mouse model of early
  Alzheimer's disease reflects reduced integration of self-motion cues.
  Current Biology 33, 2425 to 2437.
- Zhi, Y. and Cox, C. (2021). Synaptic damage in a continuous attractor model of
  grid cells.
- Chapman, B. and Bogaard, A. CMBHOME. Boston University.
  <https://github.com/wchapman/CMBHOME>
- Sievers, J. (2020). VoronoiLimit. MATLAB File Exchange, BSD-3-Clause.
