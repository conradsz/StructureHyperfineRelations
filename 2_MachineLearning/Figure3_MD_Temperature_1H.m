%% Compare 1H symmetry-based mean square error with respect to temperature (H)
% 
% Copyright (c) 2023 Conrad Szczuka
%
clc, clear, addpath functions

Nuclei = {'H1','H2','H3'};
lambda = 0.05;
d = dir('data/CH3_TemperatureSeries/CH3_*');
Temp = [150 300 600 750 900 1100 1300 1500 1700 2000];
% generate Featureweights with: Temperature // StrucParam // Hyperfine // Nucleus
for n = 1:length(Nuclei)
    for i = 1:length(d)
        folder = d(i).name; folder = append('CH3_TemperatureSeries/',folder);
        FeatureWeights(i,:,:,n) = table2array(NCA(folder,Nuclei(n),lambda));
        set(gcf,'visible','off')
    end
end
FW_orig = permute(FeatureWeights,[2 3 1 4]);% StrucParam // Hyperfine // Temperature // Nucleus
close all

% change the StructParam according to the symmetry of CH3
FW_sym1(:,:,:,2) = FW_orig([2 3 1 6 4 5],:,:,2);
FW_sym1(:,:,:,3) = FW_orig([3 1 2 5 6 4],:,:,3);
FW_sym2(:,:,:,2) = FW_orig([2 3 1 4 6 5],:,:,2);
FW_sym2(:,:,:,3) = FW_orig([3 1 2 6 5 4],:,:,3);

for s_idx = 1:length(Temp)
    a(1) = immse(FW_orig(:,:,s_idx,1),FW_sym1(:,:,s_idx,2));
    a(2) = immse(FW_orig(:,:,s_idx,1),FW_sym1(:,:,s_idx,3));
    a(3) = immse(FW_sym1(:,:,s_idx,2),FW_sym1(:,:,s_idx,3));
    a(4) = immse(FW_orig(:,:,s_idx,1),FW_sym2(:,:,s_idx,2));
    a(5) = immse(FW_orig(:,:,s_idx,1),FW_sym2(:,:,s_idx,3));
    a(6) = immse(FW_sym1(:,:,s_idx,2),FW_sym2(:,:,s_idx,3));
    mse(s_idx) = sum(a);
end

figure
plot(Temp,mse,'o',LineWidth=1.2)
xlabel('Temperature (K)')
ylabel('1H symmetry-based mean square error')


