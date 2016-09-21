function [labels]=headersAndValuesToLabels(header, values, varargin)
    p=inputParser;
    addRequired(p, 'header')
    addRequired(p, 'values')
    addParameter(p, 'headerValSeperator', ': ')
    addParameter(p, 'entrySeperator', ', ')
    parse(p, header, values, varargin{:})

    if iscell(values)
        labels=cellfun(@(cellVal) strjoin(...
                   arrayfun(@(i) [p.Results.header{i},p.Results.headerValSeperator,cellArrayToDoubles(cellVal{i})],...
                        1:length(p.Results.header),'UniformOutput',false), p.Results.entrySeperator),...
               p.Results.values, 'UniformOutput',false);
    else
        labels=arrayfun(@(valRow) strjoin(...
                   arrayfun(@(i) [p.Results.header{i},p.Results.headerValSeperator,num2str(p.Results.values(valRow,i))],...
                           1:size(p.Results.values,2), 'UniformOutput', false), p.Results.entrySeperator),...
               1:size(values,1), 'UniformOutput', false);
    end
return
    
function [cellsStr]=cellArrayToDoubles(cellArr)
    if iscell(cellArr)
        cellsStr=['{ ', strjoin(cellfun(@cellArrayToDoubles,cellArr,'UniformOutput',false),'; '),' }'];
    else
        cellsStr=strjoin(arrayfun(@num2str,cellArr,'UniformOutput',false),', ');
    end
return