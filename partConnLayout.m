function [layout]=partConnLayout(connect,archs)
inc=1;


[~,fulldisjoint]=ismember(1:size(archs,2),archs,'rows');

layout=NaN(size(archs,1),2);
layout(fulldisjoint,:)=[0,0];

indxr=1:size(archs,1);

%% layout x axis so connections done in layers
frontier=indxr(logical(connect(fulldisjoint,:)));
past=fulldisjoint;
pos=1;
while(~isempty(frontier))
    layout(frontier,1)=pos;
    
    past=union(past,frontier);
    frontier=setdiff(indxr(any(connect(frontier,:),1)),past);
    
    pos=pos+inc;
end

%% layout y axis to try and minimize crossings greedily
frontier=indxr(logical(connect(fulldisjoint,:)));
past=fulldisjoint;
prevFront=fulldisjoint;
while(~isempty(frontier))
    initGuess=[1:numel(frontier)]'; initGuess=initGuess-mean(initGuess);
    layout(frontier,2)=fminsearch(@(y) numCross(connect,[layout([prevFront,frontier],1),[layout(prevFront,2);y]])...
                                    ,initGuess);
    prevFront=frontier;
    past=union(past,frontier);
    frontier=setdiff(indxr(any(connect(frontier,:),1)),past);
end

return

% final step is: 
% [conn,archs]=getPartConnect(6);
% xy=partConnLayout(conn,archs); 
% gplot(conn,xy);