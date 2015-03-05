function cityplot2d(dist, metrics)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure
hold on

%dist=partMoveDistance(archs(1:30,:));
%met=[results.sciences,results.costs];

plotting=mdscale(dist,2);
colorEdgeByDist(dist,plotting,eye(3));
nodesWithBarGraph(plotting,metrics,range(plotting(:,2))/10)

hold off
end