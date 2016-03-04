function handle=nodesWithBarGraph3d(handle, plotting, metrics, heightLim,varargin)
% nodesWithBarGraph3d plots cities and the associated buildings.
%
% nodesWithBarGraph3d(plotting, metrics, heightLim) plots the cities with
%   locations given as rows in plotting with corresponding values for
%   criteria (metrics) and limits buildings to have height heightLim.
%   plotting should be an Nx2 matrix and metrics should be NxP where P is the
%   number of criteria. heightLim should be either a scalar or a vector
%   with length P corresponding to the limits in the height of each
%   criteria.
%
% nodesWithBarGraph3d(h, ___) plots on the input figure handle.
% 
% h=nodesWithBarGraph3d(___) returns the handle used for plotting.
% 
% nodesWithBarGraph3d(___, option1Str, option1Val, ...) inputs options
%   'colorCycle', colors : is a vector of color characters (see help plot) or a
%      colormap (Cx3 matrix) which determines the colors used for plotting
%      each building which represents a given criteria. default: [brgkcy]'
%      if C<P will wrap around and reuse the first color for the buildings. 
%      Colors are used in the order listed in metrics.
%   'BuildingProp', cellArrayOfOptions : specifies patch properties to use 
%      when rendering buildings. See doc patch properties for options to 
%      put into cellArrayOfOptions

%% parse inputs and error checking.
p=inputParser();
addRequired(p,'plotting',@isnumeric);
addRequired(p,'metrics', @isnumeric);
addRequired(p,'heightLim', @isnumeric);
addParameter(p,'colorCycle',['brgkcy']');
addParameter(p,'buildingProp',cell(0));

switch nargin
    case {0,1,2}
        error('too few input arguments to nodesWithBarGraph3d')
    case 3
        parse(p, handle, plotting, metrics);
        handle=figure();
    case {4,6,8}
        parse(p, plotting, metrics, heightLim, varargin{:});
    case {5,7}
        parse(p, handle, plotting, metrics, heightLim, varargin{:});
        handle=figure();
    otherwise
        error('too many input arguments to nodes WithBarGraph3d')
end

plotting=p.Results.plotting;
metrics=p.Results.metrics;
heightLim=p.Results.heightLim;

[m,n]=size(heightLim);
if(m==1 && n==1)
    heightLim=ones(1,size(metrics,2))*heightLim;
elseif(n==1)
    if(m==size(metrics,2))
        heightLim=heightLim';
    else
        error('height limit must be a vector or scalar corresponding to metrics');
    end
elseif(m~=1) % neither is 1
    error('height limit must be a vector or scalar corresponding to metrics');
elseif(n~=size(metrics,2))
    error('height limit must be a vector or scalar corresponding to metrics');
else
    error('how''d we get here?!?!');
end

%% set bar graph parameters and find heights
xrange=range(plotting(:,1));
yrange=range(plotting(:,2));

rectWidthX=xrange/60;
rectWidthY=yrange/60;
n_met=metrics./repmat(max(metrics,[],1),size(metrics,1),1); % shrink all metrics uniformly by largest to insure will get same height.
rectHeight=n_met.*repmat(heightLim,size(metrics,1),1); % scale all buildings so tallest is at height limit for each objective.

%% plot nodes and bar graphs.
figure(handle);
for(i=1:size(plotting,1))
	plot3(p.Results.handle, plotting(i,1),plotting(i,2),0,'MarkerFaceColor',zeros(1,3),'Marker','o'); %city marker
	
	for(metI=1:size(metrics,2)) % skyscrapers
		adjust=rectWidthX*(metI-1);
        barPos=[plotting(i,1)+adjust,plotting(i,2),0];
        barDim=[rectWidthX,rectWidthY,rectHeight(i,metI)];
        drawBox3d(barPos,barDim,'FaceColor',p.Results.colorCycle(mod(metI-1,length(p.Results.colorCycle))+1),p.Results.buildingProp{:});
	end
end
return