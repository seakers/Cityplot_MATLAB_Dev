function [handle]=hackLegend(handle,plotLocs, distances, lineColors)
somewhereDiscrete=plotLocs(1,:);
for i=1:size(lineColors,1)
    plot3(somewhereDiscrete(1), somewhereDiscrete(2), 0, 'Color',lineColors(i,:));
end