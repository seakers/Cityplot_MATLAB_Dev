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

plotting=mdscale(dist,2,'Criterion','sammon'); %seems to fix when wild variations in distance
% plotting=mdscale(dist,2); %Kruskal's Normalized Stress. "Classic"
% plotting=cmdscale(dist); plotting=plotting(:,1:min(2,size(plotting,2)));
colorEdgeByDist3d(dist,plotting,'auto');
nodesWithBarGraph3d(plotting,nMet,range(plotting(:,2))/10)
campos([7.2964  -17.4457    8.8248]);
% view([18,85]);

if(isnumeric(archs))
    archLbls=cell(size(archs,1),1);
    for(i=1:size(archs,1))
        archLbls{i}=num2str(archs(i,:));
    end
else
    if(iscell(archs))
        archLbls=archs;
    else
        archLbls=cell(size(archs,1),1);
        for(i=1:size(archs,1))
            archLbls{i}=archs(i,:);
        end
    end
end

%%create data cursor window
% base_metLbls={'science','cost','programmatic risk','fairness'};
% metLbls=mat2cell(base_metLbls(1:size(metrics,2)));
% aug_metLbls=cell(numel(metLbls)*2,1);
% for(i=1:size(metLbls,2))
%     aug_metLbls{i}=metLbls{i};
%     aug_metLbls{(i-1)*2+1}=['normalized ',metLbls{i}];
% end
% 
% hdt = datacursormode;
% set(hdt,'DisplayStyle','window');
% set(hdt,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,...
%     aug_metLbls,[metrics,nMet]});
metLblsStr=num2str([1:size(metrics,2)]');
metLbls=cell(size(metrics,2),1);
for(i=1:size(metLbls,1))
    metLbls{i}=['objective', metLblsStr(i,:),': '];
end
hdt = datacursormode;
set(hdt,'DisplayStyle','window');
set(hdt,'UpdateFcn',{@cityplotDataCursor,[plotting,zeros(size(plotting,1),1)],archLbls,metLbls,metrics});

hold off
end