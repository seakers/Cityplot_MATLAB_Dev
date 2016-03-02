function [plotting,nMet,pltOpts,dataCursorHandle]=cityplot3d(h,dist, metrics, varargin)
%cityplot3d Makes a 3d plot with bar graphs indicating the metrics at each
%architecture and the position of the architecture minimizing the squared
%error distance to the other points as given in dist matrix.
%   dist--distance matrix. An n x n symmetric positive matrix of dstances
%   between architecture i from architecture j.
%   metrics--the scores to bar chart.

% TODO: add options to obsolete interpreter.

%% input parsing and validation.
p=inputParser;
addRequired(p,'dist',@isnumeric)
addRequired(p,'metrics',@isnumeric)
addOptional(p,'archs',arrayfun(@(num) ['design #',num2str(num)], 1:size(dist,1),'UniformOutput',false))
addOptional(p,'metLbls',arrayfun(@(num) ['objective #',num2str(num),': '], 1:size(metrics,2),'UniformOutput',false));
% addRequired(p,'archs')

% mdscale and cmdscale poke through
addParameter(p,'UseClassic',true);
addParameter(p,'MdscaleOptArgs',[]);
% addParameter(p,'Criterion','stress'); % manually code all possible parameters. decided against this for being hard to maintain in future edtitions of MATLAB
% addParameter(p,'Weights', []);
% addParameter(p,'Start','cmdscale');
% addParameter(p,'Replicates',1);
% addParameter(p,'MdscaleOpt',[]);

% skyscraper defaults and patch properties poke through
addParameter(p,'BuildingHeight',[]);
addParameter(p,'BuildingProp',[]);

% handle h manually.
if(all(size(h)==[1,1]) && all(isgraphics(h(:)))) % can't handle multiple figure handles (handle is just a selection) and distance are really uninteresting if 1x1
    % must be passed in archs but not handle.
    figHandle=h;
    
    switch nargin
        case {0,1}
            error('insufficent number of arguments to cityplot3d');
        case 2
            error('insufficent number of arguments to use cityplot3d with a figure handle call');
        otherwise
            effArgList={dist,metrics,varargin{:}};
    end
else
    figHandle=figure;
    
    switch nargin
        case {0,1}
            error('insufficent number of arguments to cityplot3d');
        case 2
            effArgList={h,dist};
        otherwise
            effArgList={h,dist,metrics,varargin{:}};
    end
end

parse(p,effArgList{:});

%% normalization
nMet=p.Results.metrics-repmat(min(p.Results.metrics,[],1),size(p.Results.metrics,1),1);
nMet=nMet./repmat(max(nMet,[],1),size(nMet,1),1);

%% get the city locations with mdscale
figure(figHandle);
hold on
if(any(strcmp(p.UsingDefaults,'UseClassic')))
    if(any(strcmp(p.UsingDefaults,'MdscaleOptArgs'))) %default to classic.
        plotting=cmdscale(p.Results.dist,2);
    else %default to mdscale if given arguments
        plotting=mdscale(p.Results.dist,2,p.Results.MdscaleOptArgs{:});
    end
else
    if(p.Results.UseClassic)
        plotting=cmdscale(p.Results.dist,2); % use classic if directly called for
    else
        if(any(strcmp(p.UsingDefaults,'MdscaleOptArgs'))) %use mdscale with defaults if directly told not to use cmdscale.
            plotting=mdscale(p.Results.dist,2);
        else %pass through args if given.
            plotting=mdscale(p.Results.dist,2,p.Results.MdscaleOptArgs{:});
        end
    end
end

%% Build Roads
plotRoads3d(figHandle, p.Results.dist, plotting, 'legendCap', 16);

%% Build Skyscrapers
if(any(strcmp(p.UsingDefaults,'BuildingHeight')))
    BuildingHeight=range(plotting(:,2))/10;
else
    BuildingHeight=p.Results.BuildingHeight;
end

pltOpts.BuildingHeight=BuildingHeight;

if(any(strcmp(p.UsingDefaults,'BuildingProp')))
    nodesWithBarGraph3d(plotting,nMet,BuildingHeight);
else
    nodesWithBarGraph3d(plotting,nMet,BuildingHeight,'BuildingProp',p.Results.BuildingProp);
end

%% set default view
pltOpts.campos=[7.2964  -17.4457    8.8248];
campos(pltOpts.campos);
% view([18,85]);

%% standardize labels and set up data cursor
archLbls=regularizeLbls(p.Results.archs,size(plotting,1));
metLbls=regularizeLbls(p.Results.metLbls,size(metrics,2));

dataCursorHandle = datacursormode;
set(dataCursorHandle,'DisplayStyle','window');
set(dataCursorHandle,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,metLbls,p.Results.metrics});

hold off
end