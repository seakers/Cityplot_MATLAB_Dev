function [labels]=headersAndValuesToLabels(header, values, varargin)
p=inputParser;
addRequired(p, 'header')
addRequired(p, 'values')
addParameter(p, 'headerValSeperator', ': ')
addParameter(p, 'entrySeperator', ', ')
parse(p, header, values, varargin{:})

labels=arrayfun(@(valRow) strjoin(...
           arrayfun(@(i) [p.Results.header{i},p.Results.headerValSeperator,num2str(p.Results.values(valRow,i))],...
                   1:size(p.Results.values,2), 'UniformOutput', false), p.Results.entrySeperator),...
       1:size(values,1), 'UniformOutput', false);
return
    