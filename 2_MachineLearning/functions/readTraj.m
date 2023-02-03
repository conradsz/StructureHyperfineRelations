function [Atoms,CartCoord] = readTraj(folder,MDsteps)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% READ-IN OF NECESSARY COORDINATES AND ATOMIC INFORMATION 
% FROM A trajectory.xyz FILE
% input: path to the trajectory.xyz, Number of MD steps performed
% output: Table of Atoms with various labels
% output: Cartesian Coordinates in 3D matrix (Atoms x xyz x MDstep)

%% loading the xyz file and initializing output variables
directory = append('data/',folder,'/trajectory.xyz');
file = fopen(directory);
tline = fgetl(file);
atoms = str2double(tline); % extracting the number of atoms

CartCoord = zeros(atoms,3,MDsteps+1); % initializing matrix
Element = cell(1,atoms); % initializing string array for element

tline = fgetl(file); tline = fgetl(file);

%% looping over MDsteps and Number of Atoms
tic
for s = 1:MDsteps+1
    for a = 1:atoms
        strarray = strsplit(tline); 
        strarray = strarray(~cellfun('isempty',strarray));
        if s==1, Element(a) = strarray(1); end
        CartCoord(a,1,s) = str2double(strarray{1,2});
        CartCoord(a,2,s) = str2double(strarray{1,3});
        CartCoord(a,3,s) = str2double(strarray{1,4});
        tline = fgetl(file);
    end
    tline = fgetl(file); tline = fgetl(file);
end
t = toc; 
disp(append("Time for data import: ",num2str(round(t,1))," s"))
fclose('all');

 %% assign Atom Number from Periodic Table, sort in descending direction, finalize output
PerioTab = readtable('functions/PeriodicTable.txt','NumHeaderLines', 2,'VariableNamesLine',1);
PerioTab.Num = uint8(PerioTab.Num);
[~,ElementNum] = ismember(Element,PerioTab.Sym);
%creating the output table and sorting
Atoms = table(ElementNum',Element','VariableNames',["ElementNum","ElementSym"]);
[Atoms,idx] = sortrows(Atoms,'ElementNum','descend'); % sorting atoms by ElementNum
% create consecutive numbers for atoms of same identity
groupCount = 1; AtomGroupNum = 1:atoms; lastElementNum = 0;
for i = 1:max(size(Atoms.ElementNum))
    if lastElementNum==Atoms.ElementNum(i) 
        groupCount = groupCount+1; 
    else
        groupCount = 1; 
    end
    AtomGroupNum(i) = groupCount;
    lastElementNum = Atoms.ElementNum(i);
end
Atoms.GroupNum = AtomGroupNum';
Atoms.Atom = categorical(strcat(Atoms.ElementSym,int2str(Atoms.GroupNum)));
Atoms.Label = string(strcat(Atoms.ElementSym,int2str(Atoms.GroupNum)));
Atoms.Index = [1:atoms]';
% also apply sorting to CartCoord list
CartCoord = CartCoord(idx,:,:); 

end
