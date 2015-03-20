function cityplot2d(dist, metrics, archs, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure
hold on

%dist=partMoveDistance(archs(1:30,:));
%met=[results.sciences,results.costs];

plotting=mdscale(dist,2);
colorEdgeByDist(dist,plotting,'auto');
nodesWithBarGraph(plotting,metrics,range(plotting(:,2))/20,varargin{:})


nMet=metrics-repmat(min(metrics,[],1),size(metrics,1),1); 
nMet=nMet./repmat(max(nMet,[],1),size(nMet,1),1);
archLbls=cell(size(archs,1),1);
for(i=1:size(archs,1))
    archLbls{i}=num2str(archs(i,:));
end

hdt = datacursormode;
set(hdt,'DisplayStyle','window');
set(hdt,'UpdateFcn',{@cityplotDataCursor,plotting,archLbls,...
    [metrics(:,1),nMet(:,1),metrics(:,2),nMet(:,2)]});

hold off
end