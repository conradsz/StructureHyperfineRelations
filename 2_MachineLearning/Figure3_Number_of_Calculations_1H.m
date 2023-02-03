%% Compare all CH3 WeightMatrices with respect to the Stepnumber (H)
% 
% Copyright (c) 2023 Conrad Szczuka
%
clc, clear, addpath functions
StepNumber = 10:10:500;
Nuclei = {'H1','H2','H3'};
lambda = 0.05;
folder = 'CH3';

% generate Featureweights with: StepNumber // StrucParam // Hyperfine // Nucleus
for n = 1:length(Nuclei)
    for idx_s = 1:length(StepNumber)
        FeatureWeights(idx_s,:,:,n) = table2array(NCA_reducedSteps(folder,Nuclei(n),lambda, StepNumber(idx_s)));
        set(gcf,'visible','off')
    end
end
FW = permute(FeatureWeights,[2 3 1 4]);% StrucParam // Hyperfine // StepNumber // Nucleus
close all

% change the StructParam according to the symmetry of CH3
FW(:,:,:,2) = FW([2 3 1 6 4 5],:,:,2);
FW(:,:,:,3) = FW([3 1 2 5 6 4],:,:,3);

for s_idx = 1:length(StepNumber)
    a(1) = immse(FW(:,:,s_idx,1),FW(:,:,s_idx,2));
    a(2) = immse(FW(:,:,s_idx,1),FW(:,:,s_idx,3));
    a(3) = immse(FW(:,:,s_idx,2),FW(:,:,s_idx,3));
    mse(s_idx) = sum(a);
end
stddev = sqrt(mse);

figure
plot(StepNumber,mse,'o',LineWidth=1.2)
set(gca, 'YScale', 'log')
title(append('Lambda = ',string(lambda)))
xlabel('# of calculations')
ylabel('1H symmetry-based mean square error')