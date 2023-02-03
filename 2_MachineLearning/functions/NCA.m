function FeatureWeightTable = NCA(folder, Nucleus,bestlambda)
% 
% Copyright (c) 2023 Conrad Szczuka
%
%% load data
[FeaturesX,Calc] = loadData(folder);
ResponseTab = Calc{:,string(Calc.Properties.VariableNames)==Nucleus};

%% perform NCA
for i = 1:size(ResponseTab,2)
    % Normal NCA
    mdl = fsrnca(table2array(FeaturesX),table2array(ResponseTab(:,i)),'Lambda',bestlambda,'Standardize',true);
    FeatureWeightMatrix(:,i) = mdl.FeatureWeights;
end
FeatureWeightTable = array2table(FeatureWeightMatrix,"RowNames",FeaturesX.Properties.VariableNames,"VariableNames",ResponseTab.Properties.VariableNames);

figure, h = heatmap(FeatureWeightMatrix); load('functions/colormap.mat'); colormap(copper_mod),colorbar off,  title(Nucleus)
h.CellLabelFormat = '%.1f';
h.XDisplayLabels = ResponseTab.Properties.VariableNames;
h.YDisplayLabels = FeaturesX.Properties.VariableNames;

end

