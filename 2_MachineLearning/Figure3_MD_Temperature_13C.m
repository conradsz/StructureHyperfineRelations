%% Compare 13C symmetry-based mean standard deviation with respect to temperature (C)
% 
% Copyright (c) 2023 Conrad Szczuka
%
clc, clear, addpath functions

Nucleus = {'C1'};
lambda = 0.05;
d = dir('data/CH3_TemperatureSeries/CH3_*');
Temp = [150 300 600 750 900 1100 1300 1500 1700 2000];
% generate Featureweights with: Temperature // StrucParam // Hyperfine
for i = 1:length(d)
    folder = d(i).name; folder = append('CH3_TemperatureSeries/',folder);
    FeatureWeights(i,:,:) = table2array(NCA(folder,Nucleus,lambda));
    set(gcf,'visible','off')
end

FW = permute(FeatureWeights,[2 3 1]);% StrucParam // Hyperfine // Temperature
close all


for s_idx = 1:length(Temp)
   for hyp = 1:4
    Bondstddev(s_idx,hyp) = std(FW(1:3,hyp,s_idx));
    Anglestddev(s_idx,hyp) = std(FW(4:6,hyp,s_idx));
    end
end
Bondstddev = mean(Bondstddev,2);
Anglestddev = mean(Anglestddev,2);
combined_stddev = (Bondstddev+Anglestddev)./2;
figure
plot(Temp,combined_stddev,'o',LineWidth=1.2)
xlabel('Temperature (K)')
ylabel('13C symmetry-based mean standard deviation')