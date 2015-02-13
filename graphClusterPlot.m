function graphClusterPlot(distances, pareto_metrics)
figure
hold on
% hamming=real(~tmp.pareto_archs)*tmp.pareto_archs'+tmp.pareto_archs*real(~tmp.pareto_archs)'; % distances for down select problems

plotting=mdscale(distances,2);

compareIndxs=nchoosek(1:size(plotting,1),2);

% lineColors=[1,0,0; 0,1,1; 0,0,1];
lineColors=[1,0,0; 0,0,1];

for(i=1:size(lineColors,1))
    plot(0,0,'Color',lineColors(i,:));
end
legend(num2str([1:size(lineColors,1)]'));

for(i=1:size(compareIndxs,1))
    for distOrder=2:-1:1
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        if(dist==distOrder)
            pt1=plotting(indx1,:);
            pt2=plotting(indx2,:);
            plot([pt1(1);pt2(1)],[pt1(2);pt2(2)],'Color',lineColors(dist,:));
        end
    end
end

%% duplicate figure for different metrics
%see: http://www.mathworks.com/matlabcentral/newsreader/view_thread/172272
% h1=gcf;
% h2=figure;
% objects=allchild(h1);
% copyobj(get(h1,'children'),h2);

%% plot objects scince first
mask=true(size(pareto_metrics,1),1); % mask(44)=false; % apparently 0,1 point
sciBnds=[min(pareto_metrics(mask,1)),max(pareto_metrics(mask,1))];
caxis(sciBnds);
cmapSci=colormap(jet(15));
lkup=1:size(cmapSci,1);
lkupSci=linspace(sciBnds(1),sciBnds(2),length(lkup));
for(i=1:size(plotting,1))
    cmapIndx=interp1(lkupSci,lkup,pareto_metrics(i,1));
    loIndx=floor(cmapIndx);
    deltIndx=cmapIndx-loIndx;
    ptColor=deltIndx*cmapSci(min(loIndx+1,size(cmapSci,1)),:)+(1-deltIndx)*cmapSci(loIndx,:)
    
    plot(plotting(i,1),plotting(i,2),'MarkerFaceColor',ptColor,'Marker','o');
end
colorbar

%% plot objects cost second