function [] = Hyperfine_Read(DIR) 
% 
% Copyright (c) 2023 Conrad Szczuka
%
% This script automatically creates an csv file with all hfc values
% they are ordered as atom-x-y-z-iso
cd(DIR)

d = dir; 
NumDir = find(vertcat(d.isdir));
for k = 1:NumDir(end)-2 
currDir = d(2+k).name;
cd(currDir)
if isempty(dir('*.out')) == 1 % check if calculation was successful
    disp(currDir)
    cd('..') 
else


filename = dir('*.out');
out = fopen(filename.name);
fname = strread(filename.name,'%s','delimiter','.');

tline = fgetl(out);
Cellatom = cell(1,1);
Cellhfc = cell(1,4);
while ischar(tline) %reading from file
    if contains(string(tline),' Nucleus  ') == 1
        B = regexp(tline,'\w*+','match');
        Cellatom = [Cellatom;B{2}];
    elseif contains(string(tline),'A(Tot)') == 1
        disp(tline)
        A = regexp(tline,'(-|[.]|\d)+','match');
        Cellhfc = [Cellhfc;A];
    end
    tline = fgetl(out);
end


Cell = [Cellatom, Cellhfc];
Cell(1,:) = [];
Cellheader = ["Atom","Ax","Ay","Az","Aiso"];
filecontent = cell2table(Cell,'VariableNames',Cellheader);
csvname = char(append('HFC_',fname(1,1),'.csv'));

cd('..')  
writetable(filecontent,csvname);
end
end
disp('Hyperfine data successfully extracted!')
fclose('all');
cd('..')
end

