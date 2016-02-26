function nodesWithBarGraph3d(plotting, metrics, heightLim,varargin)
%% parse inputs and error checking.
[m,n]=size(heightLim);
if(m==1 && n==1)
    heightLim=ones(1,size(metrics,2))*heightLim;
elseif(n==1)
    if(m==size(metrics,2))
        heightLim=heightLim';
    else
        error('height limit must be a vector or scalar corresponding to metrics');
    end
elseif(m~=1) % neither is 1
    error('height limit must be a vector or scalar corresponding to metrics');
elseif(n~=size(metrics,2))
    error('height limit must be a vector or scalar corresponding to metrics');
else
    error('how''d we get here?!?!');
end
if(nargin==5)
    buildingProp=varargin{2};
elseif(nargin>5)
    error('too many inputs to nodesWithBarGraph3d');
end

%% set bar graph parameters and find heights
xrange=range(plotting(:,1));
yrange=range(plotting(:,2));

rectWidthX=xrange/60;
rectWidthY=yrange/60;
n_met=metrics./repmat(max(metrics,[],1),size(metrics,1),1); % shrink all metrics uniformly by largest to insure will get same height.
rectHeight=n_met.*repmat(heightLim,size(metrics,1),1); % scale all buildings so tallest is at height limit for each objective.

colorcycle='brgkcy'; % notice start at 2nd element by 1 based indexing.

%% plot nodes and bar graphs.
for(i=1:size(plotting,1))
	plot3(plotting(i,1),plotting(i,2),0,'MarkerFaceColor',zeros(1,3),'Marker','o'); %city marker
	
	for(metI=1:size(metrics,2)) % skyscrapers
		adjust=rectWidthX*(metI-1);
        barPos=[plotting(i,1)+adjust,plotting(i,2),0];
        barDim=[rectWidthX,rectWidthY,rectHeight(i,metI)];
        drawBox3d(barPos,barDim,'FaceColor',colorcycle(mod(metI-1,length(colorcycle))+1),buildingProp{:});
	end
end
return