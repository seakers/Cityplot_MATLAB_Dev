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

%% plot markers by science
mask=true(size(pareto_metrics,1),1); % mask(44)=false; % apparently 0,1 point
sciBnds=[min(pareto_metrics(mask,1)),max(pareto_metrics(mask,1))];
caxis(sciBnds);
cmapSci=colormap(jet(15));
lkup=1:size(cmapSci,1);
lkupSci=linspace(sciBnds(1),sciBnds(2),length(lkup));
for(i=1:size(plotMet,1))
    cmapIndx=interp1(lkupSci,lkup,pareto_metrics(i,1));
    loIndx=floor(cmapIndx);
    deltIndx=cmapIndx-loIndx;
    ptColor=deltIndx*cmapSci(min(loIndx+1,size(cmapSci,1)),:)+(1-deltIndx)*cmapSci(loIndx,:)
    
    plot(plotMet(i,1),plotMet(i,2),'MarkerFaceColor',ptColor,'Marker','o');
end
colorbar

return

function colorEdgeByDist(distances,plotLocs,lineColors)
compareIndxs=nchoosek(1:size(plotLocs,1),2);
for(i=1:size(lineColors,1))
    plot(0,0,'Color',lineColors(i,:));
end
legend(num2str([1:size(lineColors,1)]'));

for(i=1:size(compareIndxs,1))
    for distOrder=size(lineColors,1):-1:1
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        if(dist==distOrder)
            pt1=plotLocs(indx1,:);
            pt2=plotLocs(indx2,:);
            plot([pt1(1);pt2(1)],[pt1(2);pt2(2)],'Color',lineColors(dist,:));
        end
    end
end
return

function colorEdgeWithinDist(distances,plotMet,distanceToConnect)
compareIndxs=nchoosek(1:size(distances,1),2);
% hamming=real(~plotArchs)*plotArchs'+plotArchs*real(~plotArchs)';
numColor=sum(any(distances(compareIndxs(:,1),compareIndxs(:,2))<=1,2));
colCnt=0;

for(i=1:size(compareIndxs,1))
    if(distances(compareIndxs(i,1),compareIndxs(i,2))==distanceToConnect)
        colCnt=colCnt+1;
        pt1=plotMet(compareIndxs(i,1),:);
        pt2=plotMet(compareIndxs(i,2),:);
        plot([pt1(1);pt2(1)],[pt1(2);pt2(2)],'Color',[sin(pi*colCnt/numColor)^2,cos(pi*colCnt/numColor)^2,colCnt/numColor]);
    end
end
return