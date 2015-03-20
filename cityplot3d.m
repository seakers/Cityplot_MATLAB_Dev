function cityplot3d(dist, metrics, archs)
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

nMet=metrics-repmat(min(metrics,[],1),size(metrics,1),1); 
nMet=nMet./repmat(max(nMet,[],1),size(nMet,1),1);

plotting=mdscale(dist,2);
colorEdgeByDist3d(dist,plotting,'auto');
nodesWithBarGraph3d(plotting,nMet,range(plotting(:,2))/10)
campos([7.2964  -17.4457    8.8248]);

archLbls=cell(size(archs,1),1);
for(i=1:size(archs,1))
    archLbls{i}=num2str(archs(i,:));
end

hdt = datacursormode;
set(hdt,'DisplayStyle','window');
set(hdt,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,...
    [metrics(:,1),nMet(:,1),metrics(:,2),nMet(:,2)]});

hold off
end