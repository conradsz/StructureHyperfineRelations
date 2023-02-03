function NCA_hyperfine(WeightTable, folder,Hyperfine)
% 
% Copyright (c) 2023 Conrad Szczuka
%
for i = 1:size(WeightTable,2)
    store = table2array(WeightTable{:,i}); 
    X(:,i) = store(:,string(WeightTable{1,1}.Properties.VariableNames)==Hyperfine);
end

figure, h = heatmap(X'); load('functions/colormap.mat'); colormap(copper_mod), colorbar off, title(append(folder,', ',Hyperfine))
h.CellLabelFormat = '%.1f';
h.XDisplayLabels = WeightTable.Properties.RowNames;
h.YDisplayLabels = WeightTable.Properties.VariableNames;
end

