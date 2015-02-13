figure
hold on

% plotMet=tmp.pareto_metrics;
plotArchs=tmp.pareto_archs;

plotMet=mdscale(pdist(tmp.pareto_metrics),2);
% plotMet=tmp.pareto_metrics;

compareIndxs=nchoosek(1:size(tmp.pareto_archs,1),2);
hamming=real(~plotArchs)*plotArchs'+plotArchs*real(~plotArchs)';

numColor=sum(any(hamming(compareIndxs(:,1),compareIndxs(:,2))==1,2));
colCnt=0;

for(i=1:size(compareIndxs,1))
    if(hamming(compareIndxs(i,1),compareIndxs(i,2))==1)
        colCnt=colCnt+1;
        pt1=plotMet(compareIndxs(i,1),:);
        pt2=plotMet(compareIndxs(i,2),:);
        plot([pt1(1);pt2(1)],[pt1(2);pt2(2)],'Color',[sin(pi*colCnt/numColor)^2,cos(pi*colCnt/numColor)^2,colCnt/numColor]);
    end
end

%% unaltered metrics plot
% plot(plotMet(:,1),plotMet(:,2),'ko');
% xlabel('science');
% ylabel('cost');

%% plot markers by science
mask=true(size(tmp.pareto_metrics,1),1); % mask(44)=false; % apparently 0,1 point
sciBnds=[min(tmp.pareto_metrics(mask,1)),max(tmp.pareto_metrics(mask,1))];
caxis(sciBnds);
cmapSci=colormap(jet(15));
lkup=1:size(cmapSci,1);
lkupSci=linspace(sciBnds(1),sciBnds(2),length(lkup));
for(i=1:size(plotMet,1))
    cmapIndx=interp1(lkupSci,lkup,tmp.pareto_metrics(i,1));
    loIndx=floor(cmapIndx);
    deltIndx=cmapIndx-loIndx;
    ptColor=deltIndx*cmapSci(min(loIndx+1,size(cmapSci,1)),:)+(1-deltIndx)*cmapSci(loIndx,:)
    
    plot(plotMet(i,1),plotMet(i,2),'MarkerFaceColor',ptColor,'Marker','o');
end
colorbar