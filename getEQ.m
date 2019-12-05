% 
% find(iJO1366.stoichMat(strcmp(cellstr(iJO1366.specID),'succ_c'),:))
function [ output_args ] = getEQ( cnap, reacnr, spec )
if nargin == 1
    reacnr = 1:cnap.numr;
end
if exist('spec','var')
    if spec
        if ischar(reacnr)
            [~,reacnr] = find(cnap.stoichMat(strcmp(cellstr(cnap.specID),reacnr),:));
        elseif ismatrix(reacnr)
            [~,reacnr] = find(cnap.stoichMat(reacnr,:));
        end
    end
end
if ischar(reacnr)
    reacnr = find(strcmp(cellstr(cnap.reacID),reacnr),1);
end
for i = 1:length(reacnr)
    zw=find(cnap.stoichMat(:,reacnr(i))<0);
    if(~isempty(zw))
            str=[num2str(-cnap.stoichMat(zw(1),reacnr(i))),' ',deblank(cnap.specID(zw(1),:))];
            for j=2:length(zw)
                    str=[str,' + ',num2str(-cnap.stoichMat(zw(j),reacnr(i))),' ',deblank(cnap.specID(zw(j),:))];
            end
    else
        str = '';
    end            

    if(~strcmp('mue',deblank(cnap.reacID(reacnr(i),:))))
        str=[str,' = '];
    end
    zw=find(cnap.stoichMat(:,reacnr(i))>0);
    if(~isempty(zw))
            str=[str,num2str(cnap.stoichMat(zw(1),reacnr(i))),' ',deblank(cnap.specID(zw(1),:))];
            for j=2:length(zw)
                str=[str,' + ',num2str(cnap.stoichMat(zw(j),reacnr(i))),' ',deblank(cnap.specID(zw(j),:))];
            end                                                  
    end            
    disp([strtrim(cnap.reacID(reacnr(i),:)) '   ' char(9613) '   ' ...
        str '   ' char(9613) '   ' num2str(cnap.reacMin(reacnr(i))) '  ,  ' num2str(cnap.reacMax(reacnr(i)))]);
end
end

