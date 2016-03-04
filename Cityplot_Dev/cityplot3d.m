function [plotting,nCriteria,pltOpts,dataCursorHandle]=cityplot3d(h,dist, criteria, varargin)
%cityplot3d create cityplot of input distances with input objectives.
%  Average distances are preserved as much as possible while reducing to a 2d
%  ground plane with euclidean distance and the criteria are plotting as a
%  bar graphs ("skyscrapers") at each complete design ("cities"). See Nathan
%  Knerr, Daniel Selva, "Cityplot: Visualization of High-Dimensional Design
%  Spaces with Multiple Criteria" Journal of Mechanical Design (in review)
%  for more information.
%
%   cityplot3d(dist, criteria) :: makes a cityplot with default settings. dist
%      is symetric strictly positive NxN matrix of distances between designs
%      in the original space (equivalently, the dissimilarity matrix between 
%      objects to plot); N is the number of designs. criteria is a NxP matrix where each row is a
%      the criteria upon which one migt judge designs; P is the number of
%      criteria.
%
%   (optional) outputs:
%       plotting :: 2-d locations for cities in the 2-d reduced space
%       nCriteria :: NxP matrix of normalized criteria used for plotting skyscraper heights.
%       pltOpts :: assorted default values used in plot creation. Subject
%                  to change. Current values are: pltOpts.buildingHeight,
%                  pltOpts.campos. which are value used for BuildingHeight
%                  option and camera position respectively. 
%       dataCursorHandle :: a handle to the data cursor object used when
%                  clicking on a design in the cityplot.
%
%   cityplot(h, __) plots onto the axes or figure handle h
%
%   cityplot(dist, criteria, option1command, option1value, ...) :: uses
%   options from the following list:
%      'UseClassic', {true (default) | false} : uses classical multidimensional scaling
%      'DesignLabels', cellArrayOfStrings with N cells : labels used when
%         called with 'spew' or when clicking designs with the data cursor.
%      'CriteriaLabel' : labels used for labelling criteria when clicking
%         designs with the data cursor.
%      'MdscaleOptArgs', cellArrayOfOptions : will use mdscale unless
%         UseClassic is manually set to true. Will feed mdscale all options
%         specified by cellArrayOfOptions as if were inputting into the
%         argument list of mdscale. See help mdscale for options to put into
%         cellArrayOfOptions.
%      'BuildingHeight', realNumber : specifies the maximum height of
%         bars (skyscrapers) in the graph. defaults to a convienent
%         percentage of the ground plane occupied by cities.
%      'BuildingProp', cellArrayOfOptions : specifies patch properties to
%         use when rendering buildings. See doc patch properties for
%         options to put into cellArrayOfOptions
%
%   for examples see included sample problems folder.

%%TODO: add option to 'spew' architecture labels and obsolete the
%%cityplot3dInterpreter function.

%% input parsing and validation.
p=inputParser;
addRequired(p,'dist',@isnumeric)
addRequired(p,'criteria',@isnumeric)
addParameter(p,'DesignLabels',arrayfun(@(num) ['design #',num2str(num)], 1:size(dist,1),'UniformOutput',false))
addParameter(p,'CriteriaLabel',arrayfun(@(num) ['criteria #',num2str(num),': '], 1:size(criteria,2),'UniformOutput',false));
% addRequired(p,'DesignLabels')

% mdscale and cmdscale poke through
addParameter(p,'UseClassic',true);
addParameter(p,'MdscaleOptArgs',[]);

% skyscraper defaults and patch properties poke through
addParameter(p,'BuildingHeight',[]);
addParameter(p,'BuildingProp',[]);

% handle h manually.
if(isempty(h))
    error('1st argument to cityplot3d is empty')
end

if(all(size(h)==[1,1]) && all(isgraphics(h(:)))) % can't handle multiple figure handles (handle is just a selection) and distance are really uninteresting if 1x1
    % must be passed in DesignLabels but not handle.
    switch nargin
        case {0,1}
            error('insufficent number of arguments to cityplot3d');
        case 2
            error('insufficent number of arguments to use cityplot3d with a figure handle call');
        otherwise
            effArgList={dist,criteria,varargin{:}};
    end
    defFig=false;
else
    switch nargin
        case {0,1}
            error('insufficent number of arguments to cityplot3d');
        case 2
            effArgList={h,dist};
        otherwise
            effArgList={h,dist,criteria,varargin{:}};
    end
    
    h=gcf();
    defFig=true;
end
axHandle=figurePlotAxes(h);
parse(p,effArgList{:});

%% normalization
nCriteria=p.Results.criteria-repmat(min(p.Results.criteria,[],1),size(p.Results.criteria,1),1);
nCriteria=nCriteria./repmat(max(nCriteria,[],1),size(nCriteria,1),1);

%% get the city locations with mdscale
set(axHandle,'Visible','off'); %don't render to save time.
if(~isempty(axHandle))
    holdState=ishold(axHandle);
    hold(axHandle,'on');
else % assume new figure or otherwise lacking axis. Set for figure and create axes.
    holdState='off';
    if(~defFig)
        figure(h)
    end
    axHandle=axes();
    hold on
end

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
plotRoads3d(axHandle, p.Results.dist, plotting, 'legendCap', 16);

%% Build Skyscrapers
if(any(strcmp(p.UsingDefaults,'BuildingHeight')))
    BuildingHeight=range(plotting(:,2))/10;
else
    BuildingHeight=p.Results.BuildingHeight;
end

pltOpts.BuildingHeight=BuildingHeight;

if(any(strcmp(p.UsingDefaults,'BuildingProp')))
    nodesWithBarGraph3d(axHandle,plotting,nCriteria,BuildingHeight);
else
    nodesWithBarGraph3d(axHandle,plotting,nCriteria,BuildingHeight,'BuildingProp',p.Results.BuildingProp);
end

%% set default view
pltOpts.campos=[7.2964  -17.4457    8.8248];
campos(pltOpts.campos);
% view([18,85]);

%% standardize labels and set up data cursor
archLbls=regularizeLbls(p.Results.DesignLabels,size(plotting,1));
CriteriaLabel=regularizeLbls(p.Results.CriteriaLabel,size(criteria,2));

dataCursorHandle = datacursormode;
set(dataCursorHandle,'DisplayStyle','window');
set(dataCursorHandle,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,CriteriaLabel,p.Results.criteria});

set(axHandle,'Visible','on');
if(holdState)
    hold(axHandle,'on')
else
    hold(axHandle,'off')
end
end