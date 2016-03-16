function [stdStr]=stdGroupsToStr(stdPart)
%returns a cell array of strings which denote partitions in the stdPart
%double cell array (see stdGroups).
stdStr=cellfun(@(grouping) strjoin(cellfun(@(part) ['(',num2str(part),')'], grouping,'UniformOutput', false)'), stdPart, 'UniformOutput', false);
