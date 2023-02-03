function [FeaturesX,Calc] = loadData(path)
% 
% Copyright (c) 2023 Conrad Szczuka
%
DirFeatures = append('data/',path,'/Features'); %if analysing more than one trajectory, don'use Reduced Angles/Dihedrals
DirCalc = append('data/',path,'/Calc');
% preparation of the data for the machine learning model:
% extracting the Features for the actually calculated data
load(DirFeatures);
load(DirCalc);
FeaturesX = Features(Calc.CalcIndex,:);
Calc = Calc;


disp(append("Number of calculation data sets: ",num2str(size(FeaturesX,1))))

end


