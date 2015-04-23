function nodesWithBarGraph3d(plotting, metrics, heightLim,varargin)
%% set bar graph parameters and normalize metrics
if(numel(heightLim)==1)
    heightLim=ones(1,size(metrics,2))*heightLim;
end
xrange=range(plotting(:,1));
yrange=range(plotting(:,2));

rectWidthX=xrange/60;
rectWidthY=yrange/60;
n_met=metrics-repmat(min(metrics,[],1),size(metrics,1),1); 
n_met=n_met./repmat(max(n_met,[],1),size(n_met,1),1);
rectHeight=n_met.*repmat(heightLim,size(metrics,1),1);

colorcycle='brgkcy'; % notice start at 2nd element by 1 based indexing.

%% plot nodes and bar graphs.
for(i=1:size(plotting,1))

	plot3(plotting(i,1),plotting(i,2),0,'MarkerFaceColor',zeros(1,3),'Marker','o');
	
	for(metI=1:size(metrics,2))
		adjust=rectWidthX*(metI-1);
        barPos=[plotting(i,1)+adjust,plotting(i,2),0];
        barDim=[rectWidthX,rectWidthY,rectHeight(i,metI)];
        drawBox3d(barPos,barDim,'FaceColor',colorcycle(mod(metI-1,length(colorcycle))+1));
	end
end
return