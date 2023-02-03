function [Dihedrals,DihedralsReduced] = extractDihedrals(Atoms,CartCoord,Cell)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% EXTRACTION OF DIHEDRAL ANGLES
% with the help of the "Cell" from the angle analysis, all dihedrals are extracted
steps = size(CartCoord(1,1,:),3);
dihedral = [];
for c = 1:Atoms.Index(end) %looping over all atoms as vertexes
    if isempty(Cell{c})==0
        for row = 1:size(Cell{c},1)
            if isempty(Cell{Cell{c}(row,1)})==0  % check whether one part of angle atoms is another vertex
                firstAtom = Cell{c}(row,2);
                secAtom = c;
                thirdAtom = Cell{c}(row,1);
                for i = 1:size(Cell{Cell{c}(row,1)},1)
                    if true(find(Cell{Cell{c}(row,1)}(i,:)==c,1))
                        fourthIDX = find(Cell{Cell{c}(row,1)}(i,:)~=c); % looks into reference
                        fourthAtom = Cell{Cell{c}(row,1)}(i,fourthIDX);
                        di = [firstAtom secAtom thirdAtom fourthAtom];
                        dihedral = [dihedral;di];
                    end
                end
            end
             if isempty(Cell{Cell{c}(row,2)})==0  % check whether one part of angle atoms is another vertex
                firstAtom = Cell{c}(row,1);
                secAtom = c;
                thirdAtom = Cell{c}(row,2);
                for i = 1:size(Cell{Cell{c}(row,2)},1)
                    if true(find(Cell{Cell{c}(row,2)}(i,:)==c,1))
                        fourthIDX = find(Cell{Cell{c}(row,2)}(i,:)~=c); % looks into reference
                        fourthAtom = Cell{Cell{c}(row,2)}(i,fourthIDX);
                        di = [firstAtom secAtom thirdAtom fourthAtom];
                        dihedral = [dihedral;di];
                    end
                end
            end
        end
    end
end
% removing identical dihedrals by first sorting
for row = 1:size(dihedral(:,1),1)
    if dihedral(row,1) > dihedral(row,4)
        dihedral(row,:) = fliplr(dihedral(row,:));
    end
end
dihedral = unique(dihedral,'rows');
disp(append("Found ", num2str(size(dihedral,1))," dihedral angles.")) %print how many bonds were found
% assigning string array
Dstr = [];
for row = 1:size(dihedral(:,1),1)
    Dstrloop = string([Atoms.Atom(dihedral(row,1)),Atoms.Atom(dihedral(row,2)),Atoms.Atom(dihedral(row,3)),Atoms.Atom(dihedral(row,4))]);
    Dstrloop = strcat("D-",Dstrloop(:,1),Dstrloop(:,2),Dstrloop(:,3),Dstrloop(:,4));
    Dstr = [Dstr; Dstrloop];
end
% calculating all dihedrals
Dihedrals = zeros(steps,size(Dstr,1));
for s = 1:steps
    CartCoordSeq = CartCoord(:,:,s);
    count=1;
    for dih = 1:size(Dstr,1) %looping over all dihedrals
        vector1 = CartCoordSeq(dihedral(dih,2),:)-CartCoordSeq(dihedral(dih,1),:);
        vector2 = CartCoordSeq(dihedral(dih,3),:)-CartCoordSeq(dihedral(dih,2),:);
        vector3 = CartCoordSeq(dihedral(dih,4),:)-CartCoordSeq(dihedral(dih,3),:);
        e1 = normr(cross(vector2, vector1));
        e2 = normr(cross(vector3, vector2));
        d = acos(dot(e1, e2, 2));
        signsin = sign(dot(cross(e1, e2, 2), vector2, 2));
        d(signsin < 0) = 2 * pi - d(signsin < 0);
        d = rad2deg(d);
        Dihedrals(s,dih) = d;
        
    end
end
Dihedrals = array2table(Dihedrals,'VariableNames',Dstr);
% in the following, the number of dihedrals is reduced
% only the first appearance of dihedrals with identical center atoms is taken
logicM = [];
for row = 1:size(dihedral(:,1),1)
    logic = repmat(dihedral(row,2),size(dihedral(:,1),1),1)==dihedral(:,2) & repmat(dihedral(row,3),size(dihedral(:,1),1),1)==dihedral(:,3) | repmat(dihedral(row,2),size(dihedral(:,1),1),1)==dihedral(:,3) & repmat(dihedral(row,3),size(dihedral(:,1),1),1)==dihedral(:,2);
    logicM = [logicM; logic'];
end

for row = 1:size(dihedral(:,1),1)
    idxFirst(row) = find(logicM(row,:),1,'first');
end
idxFirst = unique(idxFirst);
% DstrReduced = Dstr(idxFirst);
DihedralsReduced = Dihedrals(:,idxFirst);
disp(append("Found ", num2str(size(idxFirst,2))," reduced dihedral angles.")) 

end

