function Calc = prepCalcs(folder)
% 
% Copyright (c) 2023 Conrad Szczuka
%
%% read from csv
cd('..'), cd('1_ExtractHyperfinesFromOrcaCalculations\')
cd(folder)
d2 = dir; 
d2 = d2(cell2mat({d2.isdir})==false);
sized2 = size(d2);
d2 = natsortfiles({d2.name}); 
for j = 1:sized2(1,1) %go through all files that exist
    T = readtable(string(d2{j}), 'HeaderLines',1);
    x(j) = extractNumFromStr(d2{j});
    for atom = 1:size(T,1)
        for Acomp = 1:4 %sampling through Ax, Ay, Az, Aiso
            Z(j,atom,Acomp) = T{atom,Acomp+1};
        end
    end
end


% note labels for your atoms and your calculted values (hyperfines by default)
LabelsAtoms = string(T.(1));
LabelsAtoms = regexprep(LabelsAtoms,'\d*','');
AtomsCount = table(0,'VariableNames',"Init");
for i = 1:length(LabelsAtoms)
    [a,b] = ismember(LabelsAtoms(i),AtomsCount.Properties.VariableNames);
    if  a == true
        AtomsCount.(b) = AtomsCount.(b) + 1;
        LabelsAtoms(i) = append(LabelsAtoms(i),string(AtomsCount.(b)));
    else
        AtomsCount = [AtomsCount table(1,'VariableNames',LabelsAtoms(i))];
        LabelsAtoms(i) = append(LabelsAtoms(i),"1");
    end
    
end
LabelsHyperfine = {'Ax','Ay','Az','Aiso'};

Z = permute(Z,[1 3 2]); % switching indices of atoms and A value
cell4Tab = {};
for i=1:size(Z,3)
    cell4Tab{i} = array2table(Z(:,:,i),'VariableNames',LabelsHyperfine);
end
CalcVar = table(cell4Tab{:},'VariableNames',LabelsAtoms);
CalcIDX = table((x+1)','VariableNames',{'CalcIndex'});
Calc = [CalcIDX CalcVar];

cd('..'), cd('..'), cd('2_MachineLearning')
save(append('data/',folder,'/Calc'),'Calc')
disp("Hyperfine data successfully compiled and saved.")
end