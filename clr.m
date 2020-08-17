handles = double(findall(0,'type','figure'));
delete(handles(~strcmp(get(handles,'Tag'),'CellNetAnalyzer')));
cnan = rmfield(cnan,'open_projects');
cnan.open_projects = struct;
a=[setdiff(who,'cnan');{'a'}];
clear(a{:});
clc;