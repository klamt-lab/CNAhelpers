function redund = find_redundant_mcs(mcs)
% are there redundancies in a set of mcs
% return value is an integer vector that indicates whether the mcs is
% redundant in the set
% 0: true mcs
% 1: another mcs contains a subset of this mcs (smallest subset indicated)
% or the same mcs already occurred earlier
if isempty(mcs)
    redund = [];
    return;
end
mcs = mcs ~= 0 & ~isnan(mcs);
mcs = sparse(mcs(sum(mcs,2)~=0,:));
redund = nan(1,size(mcs,2));
% check internally
next = false(1,size(mcs,2));
next(1) = true;
while true
    i = next;
    unclear = find(isnan(redund) & ~i);
    s = relation(mcs(:,i),mcs(:,unclear));
    redund(unclear( s>=2 )) = 1; % superset or identical set
    if any(s == 1) % subset exists
        redund(i) = 1;
    else
        redund(i) = 0;
    end
    next(i) = false;
    next(find(isnan(redund),1)) = true;
    if ~any(next), break; end
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