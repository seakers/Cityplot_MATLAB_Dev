function nodesWithBarGraph(plotting, metrics, heightLim,varargin)
xrange=range(plotting(:,1));


rectWidth=xrange/30;
rectHeight=metrics.*repmat(heightLim./range(metrics,1),size(metrics,1),1);

colorcycle='ybrgkc'; % notice start at 2nd element by 1 based indexing.

for(i=1:size(plotting,1))

	plot(plotting(i,1),plotting(i,2),'MarkerFaceColor',zeros(1,3),'Marker','o');
	
	for(metI=1:size(metrics,2))
		adjust=rectWidth*(metI-1);
		rectangle('Position',[plotting(i,1)+adjust,plotting(i,2),rectWidth,rectHeight(i,metI)],'FaceColor',colorcycle(mod(metI,length(colorcycle))+1));
	end
end
return
