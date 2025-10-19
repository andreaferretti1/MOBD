function str = value_to_string(val)
% Questa funzione riceve un valore in input e lo converte in stringa
% Inpu:
% - val è il valore da convertire in stringa
% Output:
% - str è la stringa

if isnumeric(val)
    if isscalar(val)
        str = num2str(val);
    else
        str = mat2str(val);
    end
elseif ischar(val)
    str = val;
elseif isstring(val)
    if ~isscalar(val)
        % FIXED: Correctly handle arrays of strings
        parts = cellfun(@value_to_string, cellstr(val), 'UniformOutput', false);
        str = sprintf("{%s}", strjoin(parts, ", "));
    else
        % It's a single string, just convert to char
        str = char(val);
    end
elseif iscell(val)
    parts = cellfun(@value_to_string, val, 'UniformOutput', false);
    str = sprintf("{%s}", strjoin(parts, ", "));
elseif isstruct(val)
    if numel(val) > 1
        % Caso: array di struct
        parts = cell(numel(val), 1);
        for idx = 1:numel(val)
            parts{idx} = value_to_string(val(idx)); % ricorsione
        end
        str = sprintf("[%s]", strjoin(parts, ", "));
    else
        % Caso: struct singola
        fields = fieldnames(val);
        parts = cell(numel(fields), 1);
        for k = 1:numel(fields)
            parts{k} = sprintf('%s:%s', fields{k}, value_to_string(val.(fields{k})));
        end
        str = sprintf("{%s}", strjoin(parts, ", "));
    end
else
    str = "unsupported type";
end

end