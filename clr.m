handles = double(findall(0,'type','figure'));
if ~isempty(handles)
    delete(handles(~strcmp(get(handles,'Tag'),'CellNetAnalyzer')));
end
cnan = rmfield(cnan,'open_projects');
cnan.open_projects = struct;
a=[setdiff(who,'cnan');{'a'}];
clear(a{:});
clc;