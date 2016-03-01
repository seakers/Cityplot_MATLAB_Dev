function nodesWithBarGraph3d(plotting, metrics, heightLim,varargin)
%% parse inputs and error checking.
p=inputParser();
addRequired(p,'plotting',@isnumeric);
addRequired(p,'metrics', @isnumeric);
addRequired(p,'heightLim', @isnumeric);
addParameter(p,'colorCycle',['brgkcy']');
addParameter(p,'buildingProp',cell(0));

parse(p, plotting, metrics, heightLim, varargin{:});

plotting=p.Results.plotting;
metrics=p.Results.metrics;
heightLim=p.Results.heightLim;

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

%% set bar graph parameters and find heights
xrange=range(plotting(:,1));
yrange=range(plotting(:,2));

rectWidthX=xrange/60;
rectWidthY=yrange/60;
n_met=metrics./repmat(max(metrics,[],1),size(metrics,1),1); % shrink all metrics uniformly by largest to insure will get same height.
rectHeight=n_met.*repmat(heightLim,size(metrics,1),1); % scale all buildings so tallest is at height limit for each objective.

%% plot nodes and bar graphs.
for(i=1:size(plotting,1))
	plot3(plotting(i,1),plotting(i,2),0,'MarkerFaceColor',zeros(1,3),'Marker','o'); %city marker
	
	for(metI=1:size(metrics,2)) % skyscrapers
		adjust=rectWidthX*(metI-1);
        barPos=[plotting(i,1)+adjust,plotting(i,2),0];
        barDim=[rectWidthX,rectWidthY,rectHeight(i,metI)];
        drawBox3d(barPos,barDim,'FaceColor',p.Results.colorCycle(mod(metI-1,length(p.Results.colorCycle))+1),p.Results.buildingProp{:});
	end
end
return