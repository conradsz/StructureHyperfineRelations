# StructureHyperfineRelations

This Matlab script collection is an open-access package to identify correlations between
structure parameters of organic radicals and hyperfine coupling constants of all involved magnetic nuclei.
It accompanies the [open-access publication in XXX](https://doi.org/).

This package is based on molecular dynamics trajectories computed with the MD-module of the quantum chemistry software package
ORCA, version 5. In addition to the trajectory, hyperfine coupling constant calculations of trajectory snapshots, performed
in ORCA via the EPRNMR computation flag, are needed as input.

The included scripts handle data extraction, data processing, and execution of a suitable machine learning algorithm (Neighborhood Components Analysis).

Contents
----
The collection is subdivided into two main folders:  <br>
* In folder 1, hyperfine calculation output files (.out) from ORCA are deposited in a descriptive folder, e.g., CH3 for the methyl radical.
The output files need to be placed in subfolders named by the respective step number of the corresponding snapshot along the molecular dynamics trajectory. 
Counting starts with 0 for the starting structure. <br>
* In folder 2, a subfolder in data/ with the identical name as chosen in step (1) needs to be created. Therein, the trajectory.xyz file from the ORCA MD module is deposited.
Subsequently, the data preparation script can be used to create features (bonds, angles, dihedrals) and responses (hyperfine coupling constants) for the machine learning algorithm.
Importance matrices as displayed in the publication can be created by using the Neighborhoof Components Analysis afterwards. 
In addition, symmetry-based analyses of MD simulation parameters can be reproduced. <br><br>
More explanations can be found in the respective folders.

Reuse and modification
----
Reuse, modification, and distribution is possible (and encouraged) under the MIT license. 
