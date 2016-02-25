function [plotting,nMet,pltOpts,hdt]=cityplot3d(h,dist, metrics, archs, varargin)
%cityplot3d Makes a 3d plot with bar graphs indicating the metrics at each
%architecture and the position of the architecture minimizing the squared
%error distance to the other points as given in dist matrix.
%   dist--distance matrix. An n x n symmetric positive matrix of dstances
%   between architecture i from architecture j.
%   metrics--the scores to bar chart.

dummyFig=figure;
%% set up for input parse
p=inputParser;
addOptional(p,'handle',dummyFig,@isgraphics)
addRequired(p,'dist',@isnumeric)
addRequired(p,'metrics',@isnumeric)
addRequired(p,'archs')

% mdscale and cmdscale poke through
addParameter(p,'UseClassic',true);
addParameter(p,'MdscaleOptArgs',[]);
% addParameter(p,'Criterion','stress');
% addParameter(p,'Weights', []);
% addParameter(p,'Start','cmdscale');
% addParameter(p,'Replicates',1);
% addParameter(p,'MdscaleOpt',[]);

% skyscraper defaults and patch properties poke through
addParameter(p,'BuildingHeight',[]);
addParameter(p,'BuildingProp',[]);

if(nargin<3)
    error('not enough input arguments to cityplot3d');
elseif(nargin==3)
    parse(p,h,dist,metrics);
else
    parse(p,h,dist, metrics, archs,varargin{:});
end

%% normailization
nMet=p.Results.metrics-repmat(min(p.Results.metrics,[],1),size(p.Results.metrics,1),1); 
nMet=nMet./repmat(max(nMet,[],1),size(nMet,1),1);

%% get the city locations with mdscale
figure(p.Results.handle);
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
% plotting=mdscale(p.Results.dist,2,'Criterion',p.Results.Criterion,'Weights',p.Results.Weights,'Start',p.Results.Start,'Replicates',p.Results.Replicates,'Options',p.Results.MdscaleOpt);
% plotting=mdscale(p.Results.dist,2,'Criterion','sammon'); %seems to fix when wild variations in distance
% plotting=mdscale(p.Results.dist,2); %Kruskal's Normalized Stress. "Classic"
% plotting=cmdscale(p.Results.dist); plotting=plotting(:,1:min(2,size(plotting,2)));

%% Build Roads
colorEdgeByDist3d(p.Results.dist,plotting,'auto');

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
    nodesWithBarGraph3d(plotting,nMet,BuildingHeight,p.Results.BuildingProp{:});
end

%% set default view
campos([7.2964  -17.4457    8.8248]);
% view([18,85]);

%% standardize archLbls into a cell array of strings
if(isnumeric(p.Results.archs))
    archLbls=cell(size(p.Results.archs,1),1);
    for(i=1:size(p.Results.archs,1))
        archLbls{i}=num2str(p.Results.archs(i,:));
    end
else
    if(iscell(p.Results.archs))
        archLbls=p.Results.archs;
    else
        archLbls=cell(size(p.Results.archs,1),1);
        for(i=1:size(p.Results.archs,1))
            archLbls{i}=p.Results.archs(i,:);
        end
    end
end

%% create data cursor window
% base_metLbls={'science','cost','programmatic risk','fairness'};
% metLbls=mat2cell(base_metLbls(1:size(p.Results.metrics,2)));
% aug_metLbls=cell(numel(metLbls)*2,1);
% for(i=1:size(metLbls,2))
%     aug_metLbls{i}=metLbls{i};
%     aug_metLbls{(i-1)*2+1}=['normalized ',metLbls{i}];
% end
% 
% hdt = datacursormode;
% set(hdt,'DisplayStyle','window');
% set(hdt,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,...
%     aug_metLbls,[p.Results.metrics,nMet]});
metLblsStr=num2str([1:size(p.Results.metrics,2)]');
metLbls=cell(size(p.Results.metrics,2),1);
for(i=1:size(metLbls,1))
    metLbls{i}=['objective', metLblsStr(i,:),': '];
end
hdt = datacursormode;
set(hdt,'DisplayStyle','window');
set(hdt,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,metLbls,p.Results.metrics});

hold off
end