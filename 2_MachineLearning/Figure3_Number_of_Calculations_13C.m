%% Compare all CH3 WeightMatrices with respect to the Stepnumber (C)
% 
% Copyright (c) 2023 Conrad Szczuka
%
clc, clear, addpath functions
StepNumber = 10:10:500;
Nuclei = {'C1'};
lambda = 0.05;
folder = 'CH3';

% generate Featureweights with: StepNumber // StrucParam // Hyperfine
for idx_s = 1:length(StepNumber)
    FeatureWeights(idx_s,:,:) = table2array(NCA_reducedSteps(folder,Nuclei,lambda, StepNumber(idx_s)));
    set(gcf,'visible','off')
end

FW = permute(FeatureWeights,[2 3 1]);% StrucParam // Hyperfine // StepNumber
close all

for s_idx = 1:length(StepNumber)
   for hyp = 1:4
    Bondstddev(s_idx,hyp) = std(FW(1:3,hyp,s_idx));
    Anglestddev(s_idx,hyp) = std(FW(4:6,hyp,s_idx));
    end
end
Bondstddev = mean(Bondstddev,2);
Anglestddev = mean(Anglestddev,2);
combined_stddev = (Bondstddev+Anglestddev)./2;
figure
plot(StepNumber,combined_stddev,'o',LineWidth=1.2)
xlabel('# of calculations')
ylabel('13C symmetry-based mean standard deviation')