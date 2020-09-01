handles = double(findall(0,'type','figure'));
if ~isempty(handles)
    delete(handles(~strcmp(get(handles,'Tag'),'CellNetAnalyzer')));
end
if exist('cnan','var')
    cnan = rmfield(cnan,'open_projects');
    cnan.open_projects = struct;
end
a=[setdiff(who,'cnan');{'a'}];
clear(a{:});
clc;