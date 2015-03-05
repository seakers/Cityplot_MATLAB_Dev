function graphParetoPlot(distances,pareto_metrics)
figure
hold on

% plotMet=tmp.pareto_metrics;
% plotArchs=tmp.pareto_archs;

% plotMet=mdscale(pdist(pareto_metrics),2);
plotMet=pareto_metrics;

% colorEdgeWithinDist(distances,plotMet,3);
colorEdgeByDist(distances,plotMet,[eye(3);[0,0,0]]);
%% unaltered metrics plot
% plot(plotMet(:,1),plotMet(:,2),'ko');
% xlabel('science');
% ylabel('cost');

colorNodeByValue(plotMet,pareto_metrics(:,1));
return


