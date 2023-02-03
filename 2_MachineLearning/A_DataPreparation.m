%% Preparation of Features (structure parameters) and responses (hyperfine Calcs) for machine learning
% 
% Copyright (c) 2023 Conrad Szczuka
%
% If you want to analyze new molecules, you first need to do:
% (a) Extract ORCA-calculated hyperfines into csv files (1_ExtractHyperfinesFromOrcaCalculations)
% (b) copy the trajectory.xyz file from the ORCA MD simulation into a folder in
%     '2_MachineLearning/data' with the identical folder name as in (a)
%
% Next you choose the desired organic radical by defining the folder. For
% the algorithm to work properly, you also need to provide the number of
% MD simulation steps and an upper bond length cutoff. By running the
% script, 'Features' and 'Calcs' are automatically saved in the defined folder.

clear, clc, addpath functions

folder = 'CH3';                % define radical folder in parent folder 'data'
MD_steps = 20000;              % define the total number of MD steps (see below)

% =========================================================================
% FEATURE PREPERATION
% reading in xyz coordinates of the MD trajectory
[Atoms,CartCoord] = readTraj(folder,MD_steps);
% transformation from xyz coordinates to structure parameters
bond_cutoff = 1.5;         % setting the upper distance in Angstrom to define bonds (1.5 for organic radicals)
[Bonds,Angles,Dihedrals,DihedralsReduced] = extractStructureParams(Atoms,CartCoord,bond_cutoff);
% the final Feature table is automatically saved
Features = prepFeatures(folder,Bonds,Angles,DihedralsReduced);
% =========================================================================

% =========================================================================
% RESPONSE PREPARATION
% calculated hyperfine values from csv fiels are arranged in a table 'Calc'
% -> script in '1_ExtractHyperfinesFromOrcaCalculations' needs to be performed first
% -> folder names for radicals in '1_ExtractHyperfinesFromOrcaCalculations'
%    and in '2_MachineLearning/data' need to be identical!!!
% the final Calculations table is automatically saved
Calc = prepCalcs(folder);
% IMPORTANT: we only provide exemplary data for the methyl radical CH3
% nontheless, the 'Calc.mat' Tables are provided for all organic radicals,
% so the neighborhood components analysis will still work for allmolecules.
% =========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step number for MD trajectories of organic radicals %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CH3: 20000
% CH3CH2: 50000
% CH3O2: 40000
% semiquinone: 60000
% tyrosyl: 70000
% tryptophan-type: 60000
