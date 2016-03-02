function [handle]=plotRoads3d(handle, distances, plotLocs, varargin)
%% input parsing and checking
defClrMap=get(0, 'DefaultFigureColormap');

p=inputParser();
addRequired(p, 'distances')
addRequired(p, 'plotLocs')
addParameter(p, 'lineColors', defClrMap);
addParameter(p, 'legendCap', 0);
addParameter(p, 'targetConn', floor(size(distances,1)*log(size(distances,1))), @isnumeric);

switch nargin
    case 1
        error('too few inputs to plotInGroundPlane');
    case {2, 4, 6, 8}
        parse(p,handle,distances);
        handle=figure();
    case {3, 5, 7, 9}
        parse(p,distances, plotLocs, varargin{:});
    otherwise
        error('too many inputs to plotInGroundPlane');
end
if(~(all(size(handle)==[1,1]) && isgraphics(handle)))
    error('figure handle is not a figure handle')
end

%% filter distances to plot
filterDist=distToTargetConn(distances, p.Results.targetConn);

%% find if want to use a color map or bin into groups and give as legend
if(p.Results.legendCap>0) % will group, bin and use roads
    if(size(filterDist,1)>p.Results.legendCap)
        upper=max(filterDist(:,3));
        binBndry=linspace(min(filterDist(:,3)), upper+3*eps(upper), p.Results.legendCap);
        if(isequal(fix(distances),distances)) % for integer distances round to integer values for legend
            legendStr=[num2str(floor(binBndry(1:end-1))','%i'),repmat('-',length(binBndry)-1,1),num2str(floor(binBndry(2:end))','%i')];
        else
            legendStr=[num2str(binBndry(1:end-1)','%4.2g'),repmat('-',length(binBndry)-1,1),num2str(binBndry(2:end)','%4.2g')];
        end
    else % no need to cap
        binBndry=filterDist;
        legendStr=num2str(binBndry');
    end
    
    if(size(p.Results.lineColors,1)>p.Results.legendCap)
        lineColorsToUse=interp1([1:size(p.Results.lineColors,1)]/size(p.Results.lineColors,1), p.Results.lineColors,[1:(p.Results.legendCap)]/p.Results.legendCap, 'pchip'); % downscale linecolors
    else
        lineColorsToUse=p.Results.lineColors;
    end
    
    interp='previous';
    hackLegend(handle, p.Results.plotLocs, filterDist,lineColorsToUse); % overrrides first several lines so can present legend correctly later.
else % do as continuous mapping with linear interpolation.
    plotDist=filterDist;
    lineColorsToUse=p.Results.lineColors;
    interp='linear';
end

%% plotting and labeling.
[~, sortIndx]=sort(filterDist(:,3),'descend');
handle=plotInGroundPlane(handle, p.Results.plotLocs, filterDist(sortIndx,:), lineColorsToUse, 'interpMethod', interp);

if(p.Results.legendCap>0)
    legend(legendStr, 'Location', 'Best');
else
    colorbar();
end