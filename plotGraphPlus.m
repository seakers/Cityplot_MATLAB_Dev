%plots the edges input. Assumes vectors are row vectors (that is, components are index 2) (for historical
%reason relating to graph applications)
%the only truly required inputs are edgeEndpoints, the others can be left
%as [] to either ignore, create a new instance or find an automatic coloring rule.
function handle=plotGraphPlus(handle,pointLocs,edges,edgeColors, nodeColors ,edgeStrs,nodeStrs)
%% set up figure for plotting.
if(isempty(handle))
    handle=figure();
end

wasHeld=ishold(handle);
oldGCF=gcf();
hold on
set(handle,'Visible','off');

%% defaults and input checking
nodeColors=regularizeColorMap(nodeColors, size(pointLocs,1),handle);

if(~isempty(edges))
    [m,n]=size(edges);
    if(m ~=2 && n~=2)
        error('edges do not connect 2 elements. neither dimension is size 2');
    elseif(n~=2 && m==2) % input as columns
        edges=edges';
    end
    if(isempty(edgeStrs))
        edgeStrs=cell(size(edges,1),1);
    end
    
    edgeEndpoint1=pointLocs(edges(:,1),:);
    edgeEndpoint2=pointLocs(edges(:,2),:);
    dists=sqrt(sum((edgeEndpoint1-edgeEndpoint2).^2,2));
    
    edgeColors=regularizeColorMap(edgeColors,size(edgeEndpoint1,1),colormap(handle),'defaultColor','r', 'defaultValue',dists);
    
    for(indx=1:size(edgeEndpoint1,1)) %plot edges individually
        pltX=[edgeEndpoint1(indx,1),edgeEndpoint2(indx,1)];
        pltY=[edgeEndpoint1(indx,2),edgeEndpoint2(indx,2)];
        
        plot(pltX,pltY,'-','Color',edgeColors(indx,:));
    end
end

for(indx=1:size(pointLocs,1)) %plot nodes individually
    plot(pointLocs(indx,1),pointLocs(indx,2),'s','MarkerFaceColor',nodeColors(indx,:));
end

%% add text
Xlim=get(gca(),'XLim'); Ylim=get(gca(),'YLim');
rngX=range(Xlim); rngY=range(Ylim);
offset=0.03;
if(~isempty(nodeStrs))
    nodeStrs=regularizeLbls(nodeStrs,size(pointLocs,1)); %TODO, enable and trim and check before plotting
    for(indx=1:size(pointLocs,1))
        toWrite=strtrim(nodeStrs{indx});
        if(~isempty(toWrite))
            pltX=pointLocs(indx,1);
            pltY=pointLocs(indx,2);
            txtX=mean(pltX)+offset*rngX;
            txtY=mean(pltY)+offset*rngY;

            text(txtX,txtY,toWrite);
        end
    end
end
    
if(~isempty(edges) && ~isempty(edgeStrs))
    edgeStrs=regularizeLbls(edgeStrs,size(edges,1)); % TODO, enable and trim and check before plotting
    for(indx=1:size(edges,1))
        toWrite=strtrim(edgeStrs{indx});
        if(~isempty(toWrite))
            pltX=[edgeEndpoint1(indx,1),edgeEndpoint2(indx,1)];
            pltY=[edgeEndpoint1(indx,2),edgeEndpoint2(indx,2)];
            txtX=mean(pltX)+offset*rngX;
            txtY=mean(pltY)+offset*rngY;

            text(txtX,txtY,edgeStrs{indx});
        end
    end
end
    
%% reset hold state and make small adjustments
if(wasHeld)
    hold(gca(),'on');
else
    hold(gca(),'off');
end
figure(oldGCF);

colorbar('WestOutside');
set(handle,'Visible','on');