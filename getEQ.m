function [ output_args ] = getEQ( cnap, idx, spec )
% This function displays the stoichiometry of one or a set of queried reactions together with their bounds.
% cnap: CNA project variable
% idx: reaction index (vector) OR species index
%   case reaction index (standard): Dispay the reactions
%   case species index: Display all reactions in which this species occurs
%                       This requires the 'spec' variable to be set to 1
% spec: Treat passed index as species index instead of reaction index
%
% in particular useful together with findStrPos:
% getEQ(cnap,findStrPos(cnap.reacID,'EX_','regex')); % to display all exchange reactions with bounds
%
% Philipp Schneider 2018
if nargin == 1
    idx = 1:cnap.numr;
end
if exist('spec','var')
    if spec
        if ischar(idx)
            [~,idx] = find(cnap.stoichMat(strcmp(cellstr(cnap.specID),idx),:));
        elseif ismatrix(idx)
            [~,idx] = find(cnap.stoichMat(idx,:));
        end
    end
end
if ischar(idx)
    idx = find(strcmp(cellstr(cnap.reacID),idx),1);
end
for i = 1:length(idx)
    zw=find(cnap.stoichMat(:,idx(i))<0);
    if(~isempty(zw))
            str=[num2str(-cnap.stoichMat(zw(1),idx(i))),' ',deblank(cnap.specID(zw(1),:))];
            for j=2:length(zw)
                    str=[str,' + ',num2str(-cnap.stoichMat(zw(j),idx(i))),' ',deblank(cnap.specID(zw(j),:))];
            end
    else
        str = '';
    end            

    if(~strcmp('mue',deblank(cnap.reacID(idx(i),:))))
        str=[str,' = '];
    end
    zw=find(cnap.stoichMat(:,idx(i))>0);
    if(~isempty(zw))
            str=[str,num2str(cnap.stoichMat(zw(1),idx(i))),' ',deblank(cnap.specID(zw(1),:))];
            for j=2:length(zw)
                str=[str,' + ',num2str(cnap.stoichMat(zw(j),idx(i))),' ',deblank(cnap.specID(zw(j),:))];
            end                                                  
    end            
    disp([strtrim(cnap.reacID(idx(i),:)) '   ' char(9613) '   ' ...
        str '   ' char(9613) '   ' num2str(cnap.reacMin(idx(i))) '  ,  ' num2str(cnap.reacMax(idx(i)))]);
end
end
