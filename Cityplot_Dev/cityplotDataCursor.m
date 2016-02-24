function output_txt=cityplotDataCursor(~,event_obj, plotting, archLbls, metLbls, metrics)
pos=get(event_obj,'Position');

[~,archI]=min(sum((plotting-repmat(pos,size(plotting,1),1)).^2,2));

output_txt=cell(size(metrics,2)+2,1);
output_txt{1}=archLbls{archI};
output_txt{2}='-----------';
for(i=1:size(metrics,2))
    output_txt{i+1}=[metLbls{i},num2str(metrics(archI,i))];
end
return