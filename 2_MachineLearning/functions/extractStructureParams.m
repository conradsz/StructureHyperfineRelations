function [Bonds,Angles,Dihedrals,DihedralsReduced] = extractStructureParams(Atoms,CartCoord,bond_cutoff)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% EXTRACTION OF ALL BONDS, ANGLES, AND DIHEDRALS AND COMPILATION INTO A TABLE
% input: Atoms and CartCoord from read-in
% output: Tables for bonds, angles, and dihedrals
% output: reduced number of dihedrals (only one representative for identical center atoms
tic
[Bonds] = extractBonds(Atoms,CartCoord,bond_cutoff);
[Angles,Cell] = extractAngles(Atoms,CartCoord,bond_cutoff);
if size(Angles,2) >3 % fast check if dihedral angles are plausible.
    [Dihedrals,DihedralsReduced] = extractDihedrals(Atoms,CartCoord,Cell);
else
    Dihedrals = 0; DihedralsReduced = 0;
end
 
t = toc; 
disp(append("Time for conversion from cartesian to internal coordinates: ",num2str(round(t,1))," s"))

end

