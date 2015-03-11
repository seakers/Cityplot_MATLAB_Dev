function nodesWithBarGraph3d(plotting, metrics, heightLim,varargin)
xrange=range(plotting(:,1));


rectWidth=xrange/30;
rectHeight=metrics.*repmat(heightLim./range(metrics,1),size(metrics,1),1);

colorcycle='ybrgkc'; % notice start at 2nd element by 1 based indexing.

for(i=1:size(plotting,1))

	plot3(plotting(i,1),plotting(i,2),0,'MarkerFaceColor',zeros(1,3),'Marker','o');
	
	for(metI=1:size(metrics,2))
		adjust=rectWidth*(metI-1);
        barPos=[plotting(i,1)+adjust,plotting(i,2),0];
        barDim=[rectWidth,rectWidth,rectHeight(i,metI)];
        drawBox3d(barPos,barDim,'FaceColor',colorcycle(mod(metI,length(colorcycle))+1));
	end
end
return