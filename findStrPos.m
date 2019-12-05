function indices = findStrPos( str , pattern , opts )
% str       the space that is seached
% pattern   the search keyword or pattern
% opts      options: 0 - normal search ||| 'regex' - regex search
if nargin == 2
    opts = 0;
end
% convert str type to cell
switch class(str)
    case 'string'
        str = cellstr(strtrim(str));
    case 'char'
        str = cellstr(str);
    case 'cell'
        
    otherwise
        error('input 1 of findStrPos doesn''t correct type');
end
% convert pattern type to cell
switch class(pattern)
    case 'string'
        pattern = char(pattern);
    case 'char'
        pattern = cellstr(pattern);
    case 'cell'

    otherwise
        error('input 2 of findStrPos doesn''t correct type');
end
[rows,cols] = size(pattern);

switch opts
    case 0
        for i = 1:(rows*cols)
            ind                      = find(strcmp(str, pattern(i)));
            indices(1:length(ind),i) = ind;
        end
    case 'regex'
        if opts
            for i = 1:(rows*cols)
                match = regexp(str, pattern(i), 'match');
                ind = find(~cellfun(@isempty,match));
                indices(1:length(ind),i) = ind;
            end
        end
    otherwise
        error('define correct option. 0 for basic search or ''regex''');
end
if any( size(pattern) == 0) || (any(size(indices)==0))
    indices = [];
end
end

