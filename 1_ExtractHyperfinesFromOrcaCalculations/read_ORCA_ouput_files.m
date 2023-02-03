%% Extract Hyperfine coupling constants from ORCA Calculation output files
%
% Copyright (c) 2023 Conrad Szczuka
%
% The function Hyperfine_Read(DIR) automatically extracts hyperfine
% coupling constants from ORCA output files in separate folders. The DIR
% input denotes the parent folder. Subfolders are named by a number
% corresponding to the molecular dynamics step number. The geometry
% optimized structure is therefore in folder '0'. The function will create
% csv files within the parent folder and print the coupling constants into
% the Command Window.
%
% In this example, ORCA calculations of the methyl radical are provided in
% the parent folder 'CH3'.

clc, clear, addpath function

DIR = 'CH3';     % define folder
Hyperfine_Read(DIR)