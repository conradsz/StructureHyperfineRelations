%% Plot the Response data vs. Features and extract Feature Importance via NCA
% 
% Copyright (c) 2023 Conrad Szczuka
%
% If 'A_DataPreparation' was succesfully finalized, the neighborhood
% components analysis algorithm can be used to gauge importance values.
% You need to define the organic radical by defining the folder in the
% parent folder 'data/' and specify the regularization parameter lambda.
% Below, 2D importance matrices can be plotted either for all magnetic
% nuclei and one coupling constant or for one nucleus and all coupling
% constants.

clc, clear, addpath functions
folder = 'CH3'; % specify the folder of the radical under investigation
lambda = 0.05;

% ->> possibility to look at the raw data via a matrix plot
% MatrixPlot(folder,Nucleus)      % in analogy to Figure 2f

% ->> possibility to optimize lambda using cross-validation
% lambda = NCA_lambdaOpt(folder,Nucleus);

% =========================================================================
% PLOT THE IMPORTANCE MATRIX FOR ALL HYPERFINE CONSTANTS OF ONE NUCLEUS
Nucleus = 'C1';
ImportanceTableAxyziso = NCA(folder,Nucleus,lambda);
% =========================================================================


%% Initiate
clc, clear, addpath functions
folder = 'CH3'; % specify the folder of the radical under investigation
lambda = 0.05;
% ========================================================================
% CALCULATE THE ENTIRE 3-DIMENSIONAL IMPORTANCE MATRIX
% structure parameters x coupling constants x magnetic nuclei
ImportanceTable3D = NCA_complete(folder,lambda);
% plot the importance matrix for a specific hyperfine constant
NCA_hyperfine(ImportanceTable3D, folder,'Aiso');
% =========================================================================

