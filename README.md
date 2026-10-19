# fmri-analysis-code
Analysis Code

This repository contains analysis scripts associated with a study using neuroimaging and behavioral data from the NEBULA101 dataset.

Data Availability

The neuroimaging data, behavioral data, and preprocessing scripts are publicly available on OpenNeuro:

Dataset: OpenNeuro ds005613, version 1.0.1

Code Availability

This repository provides scripts for the following analyses:

First-level fMRI GLM: FSL FEAT scripts and design files (.fsf) used to model task-related BOLD responses for individual runs.

Second-level fMRI GLM: FSL FEAT scripts and design files (.fsf) used to combine the three Alice Localiser runs within each participant using fixed-effects analysis.

Behavioral modelling: Scripts used to fit the behavioral statistical model reported in the manuscript.

