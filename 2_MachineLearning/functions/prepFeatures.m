function [Features] = prepFeatures(folder,BondInput,AngleInput,DihedralInput)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% CONVERSION OF DIHEDRALS TO SINE AND COSINE VALUES
% AND FINAL FEATURE PREPARATION
% input: tables for bonds, angles, and dihedrals. 
% change for desired angle/dihedral data set
% output: final feature table ready for machine learning

Amatrix = []; Astr = [];
for i = 1:size(AngleInput,2)
    [angle] = table2array(AngleInput(:,i));
    Amatrix = [Amatrix, angle];
    Astr = [Astr; string(AngleInput.Properties.VariableNames{i})];
end

% converting dihedrals to sine and cosine values
Dmatrix = []; Dstr = [];
if class(DihedralInput) == "table" % checking whether dihedral angles exist
    for i = 1:size(DihedralInput,2)
        [cosine,sine] = pol2cart(deg2rad(table2array(DihedralInput(:,i))),1);
        Dmatrix = [Dmatrix, cosine, sine];
        Dstr = [Dstr; string(append(DihedralInput.Properties.VariableNames{i},'cos'))];
        Dstr = [Dstr; string(append(DihedralInput.Properties.VariableNames{i},'sin'))];
    end
end
Features = array2table([Amatrix,Dmatrix],'VariableNames',[Astr; Dstr]);
Features = [BondInput Features];

save(append('data/',folder,'/Features'),'Features');
disp("Features successfully compiled and saved.")
end

