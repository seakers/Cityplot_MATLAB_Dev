function cityplot3d(dist, metrics)
%cityplot3d Makes a 3d plot with bar graphs indicating the metrics at each
%architecture and the position of the architecture minimizing the squared
%error distance to the other points as given in dist matrix.
%   dist--distance matrix. An n x n symmetric positive matrix of dstances
%   between architecture i from architecture j.
%   metrics--the scores to bar chart.
figure
hold on

%dist=partMoveDistance(archs(1:30,:));
%met=[results.sciences,results.costs];

plotting=mdscale(dist,2);
colorEdgeByDist3d(dist,plotting,'auto');
nodesWithBarGraph3d(plotting,metrics,range(plotting(:,2))/10)

campos([7.2964  -17.4457    8.8248]);

hold off
end