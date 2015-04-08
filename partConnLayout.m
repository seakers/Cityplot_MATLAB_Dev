function [layout]=partConnLayout(connect,archs)
inc=1;


[~,fulldisjoint]=ismember(1:size(archs,2),archs,'rows');

layout=NaN(size(archs,1),2);
layout(fulldisjoint,:)=[0,0];

indxr=1:size(archs,1);

%% layout x axis so connections done in layers
frontier=indxr(connect(fulldisjoint,:));
past=fulldisjoint;
while(~isempty(frontier))
    layout(frontier,1)=pos;
    
    past=union(past,frontier,'rows');
    frontier=setdiff(indxr(connect(frontier,:)),past,'rows');
    
    inc=inc+1;
end

%% layout y axis to try and minimize crossings greedily
frontier=indxr(connect(fulldisjoint,:));
past=fulldisjoint;
while(~isempty(frontier))
    layout(frontier,2)=fminsearch(@(y) numCross(connect,[layout([prevFront;frontier],1),[layout(prevFront,2);y]]),zeros(size(frontier,1),1));
    prevFront=frontier;
    past=union(past,frontier,'rows');
    frontier=setdiff(indxr(connect(frontier,:)),past,'rows');
end

return

% final step is: 
%[conn,archs]=getPartConnect(4);
% xy=partConnLayout(conn,archs); 
% gplot(conn,xy);