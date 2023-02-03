function MatrixPlot(path, Nucleus)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% load data
[FeaturesX,Calc] = loadData(path);
X = table2array(FeaturesX);
ResponseTab = Calc{:,string(Calc.Properties.VariableNames)==Nucleus};
y = table2array(ResponseTab);
[~,ax] = plotmatrix(y,X);
for i = 1:size(ax,1)
    ylabel(ax(i,1),FeaturesX.Properties.VariableNames(i),'Rotation',0,'HorizontalAlignment','right')
end
for i = 1:size(ax,2)
    xlabel(ax(end,i),ResponseTab.Properties.VariableNames(i),'Rotation',0,'HorizontalAlignment','right')
end
end