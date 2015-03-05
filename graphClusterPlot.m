function graphClusterPlot(distances, metric, varargin)
figure
hold on
% hamming=real(~tmp.pareto_archs)*tmp.pareto_archs'+tmp.pareto_archs*real(~tmp.pareto_archs)'; % distances for down select problems
if(nargin>3)
    error('too many input arguments to graphClusterPlot');
elseif(nargin<2)
    error('too few input aruments to graphClusterPlot');
end

if(size(metric,1)~=size(distances,1))
    error('metrics don''t correspond to points');
end

plotting=mdscale(distances,2);

if(nargin==3)
    lineColors=varargin{1};
else
    % lineColors=[1,0,0; 0,1,1; 0,0,1];
    lineColors=[1,0,0; 0,0,1];
end

colorEdgeByDist(distances,plotting,lineColors)

%% duplicate figure for different metrics
%see: http://www.mathworks.com/matlabcentral/newsreader/view_thread/172272
% h1=gcf;
% h2=figure;
% objects=allchild(h1);
% copyobj(get(h1,'children'),h2);

%% plot objects scince first
colorNodeByValue(plotting,metric);
return
