function [Bonds] = extractBonds(Atoms,CartCoord,bond_cutoff)
% 
% Copyright (c) 2023 Conrad Szczuka
%
%% EXTRACTION OF BOND LENGTHS USING A DISTANCE MATRIX

steps = size(CartCoord(1,1,:),3);
CartCoordSeq = CartCoord(:,:,1); % creating a sequential CartCoord set
distM = squareform(pdist(CartCoordSeq)); % computing the distance matrix of all atoms
distM(distM>bond_cutoff)=0; % setting all "bonds" larger than the cut-off to zero
% extracting bonds
distMtril = tril(distM);  % extracting the lower triangular part
bondLogic = logical(distMtril);
[A1,A2,bondDistance] = find(distMtril);
% creating the ouput
Bstr = string([Atoms.Atom(A1),Atoms.Atom(A2)]);
Bstr = strcat("B-",Bstr(:,1),Bstr(:,2));
Bonds = table(Atoms.Atom(A1),Atoms.Atom(A2),bondDistance,'VariableNames',["Atom1","Atom2","bondDistance"]);
disp(append("Found ", num2str(size(Bstr,1))," bonds.")) %print how many bonds were found

%extracting all bonds from trajectory
Bonds = zeros(steps,size(Bstr,1));
for s = 1:steps % repeating the steps from above for all steps
    CartCoordSeq = CartCoord(:,:,s);
    distM = squareform(pdist(CartCoordSeq)); % computing the distance matrix of all atoms
    % extracting bonds
    distMtril = bondLogic.*distM; % using the logical matrix from the first snapshot
    [~,~,bondDistance] = find(distMtril);
    Bonds(s,:) = bondDistance';
end
Bonds = array2table(Bonds,'VariableNames',Bstr);

end

