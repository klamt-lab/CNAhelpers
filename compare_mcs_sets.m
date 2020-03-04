function [info, redund1, redund2, compareMat] = compare_mcs_sets(mcs1,mcs2,dispval)
% is mcs2 somehow contained in mcs1? (each column is one mcs)
% information are given on mcs2.
% 0: no
% 1: a subset of this exists in mcs1
% 2: a superset of this exists in mcs1
% 3: yes
if nargin < 3
    dispval = 0;
end
if size(mcs1,1) ~= size(mcs2,1)
    error('The compared sets don''t have the same number of reactions');
end
mcs1 = mcs1 ~= 0 & ~isnan(mcs1);
mcs2 = mcs2 ~= 0 & ~isnan(mcs2);
relevant_cols = sum([mcs1 mcs2],2)~=0;
mcs1 = sparse(mcs1(relevant_cols,:));
mcs2 = sparse(mcs2(relevant_cols,:));

% check internally (1)
redund1 = zeros(size(mcs1,2));
for i = 1:size(mcs1,2)
    redund1(i,(i+1):end) = relation(mcs1(:,i),mcs1(:,(i+1):end));
end
if any(any(redund1))
    if dispval, warning('mcs set 1 has redundancies');
    end
    a = rot90(fliplr(redund1)); % mirror matrix along diagonal
    a(a==1 | a==2) = 3-a(a==1 | a==2);
    redund1 = a+redund1;
end

% check internally (2)
redund2 = zeros(size(mcs2,2));
for i = 1:size(mcs2,2)
    redund2(i,(i+1):end) = relation(mcs2(:,i),mcs2(:,(i+1):end));
end
if any(any(redund2))
    if dispval, warning('mcs set 2 has redundancies');
    end
    a = rot90(fliplr(redund2)); % mirror matrix along diagonal
    a(a==1 | a==2) = 3-a(a==1 | a==2);
    redund2 = a+redund2;
end

% compare
compareMat = nan(size(mcs1,2),size(mcs2,2));
for i = 1:size(mcs2,2)
    compareMat(:,i) = relation(mcs2(:,i),mcs1);
end
info = max(compareMat,[],1);
num_related_mcs = sum(~~compareMat,1);
if any(num_related_mcs>1)
    if dispval, warning([num2str(sum(num_related_mcs>1)) ...
            ' mcs from set 2 has/have more than one relative in mcs set 1. Check ''compareMat'' (return variable 4)']);
    end
end

if dispval
    if all(info == 3) && size(mcs1,2) == size(mcs2,2)
        disp('MCS sets are identical');
    else
        if any(info == 1)
            disp('Set 2 has supersets of MCS from set 1');
        end
        if any(info == 2)
            disp('Set 2 has subsets of MCS from set 1');
        end
        if sum(info == 3)
            disp(['The sets have ' num2str(sum(info == 3)) ' overlappings']);
        end
    end
end
end

function s = relation(mcs_ref,mcs_compare)
    contnset = all(mcs_compare( mcs_ref,:),1); % contained in the set
    diffset  = any(mcs_compare(~mcs_ref,:),1); %�have nonzero values outside the set
    s = zeros(size(mcs_compare,2),1);
    s(~contnset & ~diffset) = 1; % subset
    s( contnset &  diffset) = 2; % superset
    s( contnset & ~diffset) = 3; % identical set
end