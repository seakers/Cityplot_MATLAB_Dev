%%turns the grouping indicies (archs) into a cellarray of actual indicies
%%ie. [1,1,2,3] |-> {[1,2], [3], [4]}
%%and [[1,1,2,3];[1,1,2,3]] |-> {{[1,2], [3], [4]};{[1,2], [3], [4]}}
function [archGroups]=stdGroups(archs)
archGroups=cell(size(archs,1),1);
for i=1:size(archs,1)
    groups=cell(max(archs(i,:)),1); % groups for one architecture
    for j=1:length(groups) % set indicies of archs with label j
        groups{j}=find(~logical(archs(i,:)-j)); 
    end
    archGroups{i}=groups;
end
return