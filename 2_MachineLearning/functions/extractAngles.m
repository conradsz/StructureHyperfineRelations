function [Angles,Cell] = extractAngles(Atoms,CartCoord,bond_cutoff)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% EXTRACTION OF BOND ANGLES
% initialization of distance matrix
steps = size(CartCoord(1,1,:),3);
CartCoordSeq = CartCoord(:,:,1); % creating a sequential CartCoord set
distM = squareform(pdist(CartCoordSeq)); % computing the distance matrix of all atoms
distM(distM>bond_cutoff)=0; % setting all "bonds" larger than the cut-off to zero

angleIDX = distM~=0;
Cell = cell(Atoms.Index(end),1);
AngleCounter = 0;
for c = 1:Atoms.Index(end)  % finding the angel connections. only necessary once
    aidx = Atoms.Index(angleIDX(:,c));
    [p1,p2] = ndgrid(aidx); % n = 2
    M = [p1(:),p2(:)];
    M = M(M(:,1)<M(:,2),:);
    Cell(c) = {M};
    AngleCounter = AngleCounter+size(M,1);
end
disp(append("Found ", num2str(AngleCounter)," bond angles.")) %print how many bonds were found
% assigning string array
Astr = [];
for c = 1:Atoms.Index(end) %looping over all atoms
    if isempty(Cell{c,1})==0
        rep = size(Cell{c});
        Astrloop = string([Atoms.Atom(Cell{c}(:,1)),repmat(Atoms.Atom(c),rep(1),1),Atoms.Atom(Cell{c}(:,2))]);
        Astrloop = strcat("A-",Astrloop(:,1),Astrloop(:,2),Astrloop(:,3));
        Astr = [Astr; Astrloop];
    end
end

% calculating all angles
Angles = zeros(steps,size(Astr,1));
for s = 1:steps
    CartCoordSeq = CartCoord(:,:,s);
    count=1;
    for c = 1:Atoms.Index(end) %looping over all steps
        if isempty(Cell{c,1})==0
            rep = size(Cell{c});
            dcoord1 = repmat(CartCoordSeq(c,:),rep(1),1)-CartCoordSeq(Cell{c}(:,1),:);
            dcoord2 = repmat(CartCoordSeq(c,:),rep(1),1)-CartCoordSeq(Cell{c}(:,2),:);
            dcoord1 = normr(dcoord1); dcoord2 = normr(dcoord2);
            dproduct = dot(dcoord1,dcoord2,2);
            a = acos(dproduct);
            a = rad2deg(a);
            Angles(s,count:count+size(a,1)-1) = a;
            count = count + size(a,1);
        end
    end
end
Angles = array2table(Angles,'VariableNames',Astr);

end

