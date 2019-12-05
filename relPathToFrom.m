function relPath = relPathToFrom( to, from )
% generates relative path from a directory to another
% example:
% to = '/scratch/CNA_SVN/_StrainBooster/_My_Simulations/../_My_Simulations/IBOH_Pathway.png'
% from = pwd
% ./ and ../ in input are simplified if possible
p = [{to};{from}];
%% shorten paths (if there are /..)
for j=1:2
    pt = p{j};
    if length(split(pt,'/..'))>1
        pt = split(pt,'/..');
        for i = 1:(length(pt)-1)
            [~,r] = strtok(fliplr(char(pt(i))),'/');
            pt(i) = {fliplr(r(2:end))};
        end
        pt = strjoin(pt,'');
    end
    p(j) = {pt};
end
%% erase identical parts in paths
pSplit1 = strsplit(p{1},'/');
pSplit2 = strsplit(p{2},'/');
for i = 1:min(length(pSplit1),length(pSplit2))
    identicalParts(i) = strcmp(pSplit1(i),pSplit2(i));
end
%% if relative path starts from top directory add ./, for each non-common path, add ../
StartOfNonCommonPath = find(~identicalParts,1,'first');
if isempty(StartOfNonCommonPath)
    StartOfNonCommonPath = min(length(pSplit1),length(pSplit2))+1;
end
pSplit1 = pSplit1(StartOfNonCommonPath:end);
pSplit2 = pSplit2(StartOfNonCommonPath:end);
if isempty(pSplit2)
    relPath = ['./' strjoin(pSplit1,'/')];
else
	relPath = [repmat('../',1,length(pSplit2)) strjoin(pSplit1,'/')];
end
end

