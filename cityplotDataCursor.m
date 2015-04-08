function output_txt=cityplotDataCursor(~,event_obj, plotting, archLbls, metrics)
pos=get(event_obj,'Position');

[~,archI]=min(sum((plotting-repmat(pos,size(plotting,1),1)).^2,2));

output_txt={archLbls{archI}; ...
    ['science: ',num2str(metrics(archI,1))];...
    ['normalized science: ', num2str(metrics(archI,2))];...
    ['costs: ', num2str(metrics(archI,3))];...
    ['normalized costs: ',num2str(metrics(archI,4))]};
return