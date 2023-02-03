function WeightTable = NCA_complete(folder,bestlambda)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% load data
[FeaturesX,Calc] = loadData(folder);

for k = 2:size(Calc,2)
    % extract the nuclei one by one
    ResponseTab = Calc{:,k};

    for i = 1:size(ResponseTab,2)
        % Normal NCA
        mdl = fsrnca(table2array(FeaturesX),table2array(ResponseTab(:,i)),'Lambda',bestlambda,'Standardize',true);
        FeatureWeightMatrix(:,i) = mdl.FeatureWeights; % structure param // hyperfine
    end
    allWeights(:,:,k-1) = FeatureWeightMatrix; % structure param // hyperfine // atom
end
allWeights = permute(allWeights,[3 2 1]); % atom // hyperfine // structure param

WeightTable = array2table(FeatureWeightMatrix,"RowNames",FeaturesX.Properties.VariableNames,"VariableNames",ResponseTab.Properties.VariableNames);

WeightTable = {};
for i=1:size(allWeights,3)
    WeightTable{i} = array2table(allWeights(:,:,i),'VariableNames',ResponseTab.Properties.VariableNames);
end
WeightTable = table(WeightTable{:},'VariableNames',FeaturesX.Properties.VariableNames,'RowNames',Calc.Properties.VariableNames(2:end));

disp(append('Number of nuclei: ',string(size(WeightTable,1))))
disp(append('Number of structure parameters: ',string(size(WeightTable,2))))
disp('Feature weights are stored in a 3-dimensional table.')
end

