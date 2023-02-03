function FeatureWeightTable = NCA_reducedSteps(folder, Nucleus,bestlambda, StepNumber)
% 
% Copyright (c) 2023 Conrad Szczuka
%
%% load data
DirFeatures = append('data/',folder,'/Features_withoutSumOfAngles');
DirCalc = append('data/',folder,'/Calc');
% preparation of the data for the machine learning model:
% extracting the Features for the actually calculated data
load(DirFeatures);
load(DirCalc);
FeaturesX = Features(Calc.CalcIndex,:);
Calc = Calc;

FeaturesX = FeaturesX(1:StepNumber,:); Calc = Calc(1:StepNumber,:);
ResponseTab = Calc{:,string(Calc.Properties.VariableNames)==Nucleus};

%% perform NCA
for i = 1:size(ResponseTab,2)
    % Normal NCA
    mdl = fsrnca(table2array(FeaturesX),table2array(ResponseTab(:,i)),'Lambda',bestlambda,'Standardize',true);
    FeatureWeightMatrix(:,i) = mdl.FeatureWeights;
end
FeatureWeightTable = array2table(FeatureWeightMatrix,"RowNames",FeaturesX.Properties.VariableNames,"VariableNames",ResponseTab.Properties.VariableNames);

end

