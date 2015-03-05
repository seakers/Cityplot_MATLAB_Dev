function colorNodeByValue(plotting,metric)
sciBnds=[min(metric),max(metric)];
caxis(sciBnds);
cmapSci=colormap(jet(15));
lkup=1:size(cmapSci,1);
lkupSci=linspace(sciBnds(1),sciBnds(2),length(lkup));
for(i=1:size(plotting,1))
    cmapIndx=interp1(lkupSci,lkup,metric(i,1));
    loIndx=floor(cmapIndx);
    deltIndx=cmapIndx-loIndx;
    ptColor=deltIndx*cmapSci(min(loIndx+1,size(cmapSci,1)),:)+(1-deltIndx)*cmapSci(loIndx,:);
    
    plot(plotting(i,1),plotting(i,2),'MarkerFaceColor',ptColor,'Marker','o');
end
colorbar
return
