function [info, redund1, redund2, compareMat] = mcs_isContained(mcs1,mcs2,dispval)
% is mcs2 contained in mcs1? (each column is one mcs)
% information are given on mcs2.
% 0: no
% 1: a subset of this exists in mcs2
% 2: a superset of this exists in mcs2
% 3: yes
% Philipp Schneider 2018
if nargin < 3
    dispval = 0;
end
if size(mcs1,1) ~= size(mcs2,1)
    error('The compared sets don''t have the same number of reactions');
end
redund1 = zeros(size(mcs1,2));
% check internally
for i = 1:size(mcs1,2)
    c = nan(1,size(mcs1,2)-i);
    for j = i+1:size(mcs1,2)
        c(j-i) = ispartof(mcs1(:,j),mcs1(:,i)) + 2*ispartof(mcs1(:,i),mcs1(:,j));
    end
    if any(c)
        redund1(i,(i+1):size(mcs1,2)) = c;
    end
end
if any(any(redund1))
    if dispval, warning('mcs set 1 has redundancies');
    end
    a = rot90(fliplr(redund1)); % mirror matrix along diagonal
    a(a==1 | a==2) = 3-a(a==1 | a==2);
    redund1 = a+redund1;
end
redund2 = zeros(size(mcs2,2));
for i = 1:size(mcs2,2)
    c = nan(1,size(mcs2,2)-i);
    for j = i+1:size(mcs2,2)
        c(j-i) = ispartof(mcs2(:,j),mcs2(:,i)) + 2*ispartof(mcs2(:,i),mcs2(:,j));
    end
    if any(c)
        redund2(i,(i+1):size(mcs2,2)) = c;
    end
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
    for j = 1:size(mcs1,2)
        compareMat(j,i) = ispartof(mcs1(:,j),mcs2(:,i)) + 2*ispartof(mcs2(:,i),mcs1(:,j));
    end
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

function p = ispartof(s1,s2)
    s1_nonzero = ~isnan(s1) & s1 ~=0;
    s2(isnan(s2)) = 0;
    p = all(s1(s1_nonzero) == s2(s1_nonzero));
end
end
