function cityplot2d(dist, metrics,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure
hold on

%dist=partMoveDistance(archs(1:30,:));
%met=[results.sciences,results.costs];

plotting=mdscale(dist,2);
colorEdgeByDist(dist,plotting,eye(3));
nodesWithBarGraph(plotting,metrics,range(plotting,1)/5,varargin{:})

hold off
end