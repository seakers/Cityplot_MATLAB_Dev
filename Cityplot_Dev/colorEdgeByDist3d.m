function colorEdgeByDist3d(distances,plotLocs,lineColors)
%%plots the edges of the graph by color coding by distance
%%assumes distances is upper triangular or symmetric (i.e. the graph is
%%unidirected)
%%inputs:
%%distances: an NxN adjacency matrix of the distances between corresponding nodes
%%distances <=0 are assumed to correspond to nodes not linked.
%%plotLocs: locations of points in the cube to be plotted. Either Nx2 or
%%Nx3. If given as Nx2 will place all edges/nodes in the z=0 plane
%%lineColors: A colormap that assigns colors to values. alternatively,
%%leave blank or type 'auto' and will attempt to plot something like 15*#ofNodes worth of smallest edges
%%equally space values across the 'jet' colormap.
%%outputs:
%%-none-

%% thoughts
% seems more than one thing is happening here
% (1) choosing which distances to plot
% (2) mapping the distances to plot to the colors to use
% (3) grouping distances to stay within cap.
% really, the architecture here is flawed. Currently there's a big jump
% between input line colors and auto. Really need to divide these tasks.
% suggested action: re-architect entirely.

%% constants
cap=15;
% targetMult=10;
targetMult=3;

%% regularize pointLocs sizes
if(size(plotLocs,2)==1)
    plotLocs=[plotLocs,zeros(size(plotLocs,1),2)];
end
if(size(plotLocs,2)==2)
    plotLocs=[plotLocs,zeros(size(plotLocs,1),1)];
end

if(~all(size(distances)-[1,1]) || size(plotLocs,1)==1)
    warning('trying to plot single vertex graph');
    return
end

%% finding lineColors
% compareIndxs=nchoosek(1:size(plotLocs,1),2);
compareIndxs=genPairs(size(plotLocs,1));
%%TODO replace the following hack for the legend with hggroup to group
%%lines by distance and color. give legend by hggroup.

%% 
% need to set maxDist, numDistUsed, distUsed and distToColorMap
if(isempty(lineColors) || (ischar(lineColors) && strcmp(lineColors,'auto')));
    useAuto=true;
    targetConn=floor(size(distances,1)*log(size(distances,1))); % expected number of edges for a single connected component. See pg 82 of Hopcroft Kannan Foundations of Data Science.
    relevantDist=distances(logical(triu(ones(size(distances)),1)));
    
    if(max(abs(distances-floor(distances)))<1e-13) % if integer distances
        nonint=false;
        cnts=histc(relevantDist(:),[0,1:max(max(distances))]);
        willConn=cumsum(cnts(2:end));
        [~,maxDist]=min(abs(willConn-targetConn)); %max Dist will use
        maxDist=maxDist-(willConn(maxDist)>targetConn); % negative adjustment: removes distances to use to make it so the number of lines does no exceed the target distance
        numDistUsed=sum(cnts(2:maxDist+1)>0);
        if(numDistUsed==0)
            maxDist=find(willConn(2:end),1)+1;
            numDistUsed=willConn(maxDist);
        end
        distUsed=find(cnts(2:maxDist+1)>0,numDistUsed);
    else
        nonint=true;
        [~,sortI]=sort(relevantDist);
        distUsed=relevantDist(sortI(1:min(targetConn,length(relevantDist))));
        maxDist=max(distUsed);
        numDistUsed=sum(distUsed<maxDist);
    end
    
    if(issparse(distUsed))
        distUsed=full(distUsed);
    end
    
    %% check if will need to group to stay within cap
    if(numDistUsed>cap || nonint) %won't be able to see entire legend
        useGrouping=true;
        boundingLims=linspace(min(distUsed),max(distUsed),cap);
        [~,distToColorMap]=histc(distUsed,boundingLims);
    else
        useGrouping=false;
        distToColorMap=1:numDistUsed;
    end
    lineColors=hsv2rgb([linspace(0,2/3,max(distToColorMap))',ones(max(distToColorMap),2)]);  % default color mapping.
    
else
    useAuto=false;
    %% TODO bug: assumes integer inputs starting at 1. Also only goes up to size(lineColors,1)+.5
    %% plot the lines in the ground plane z=0.
    distUsed=distances(0<distances & distances<=size(lineColors,1)+.5);
    numDistUsed=length(distUsed);
    useGrouping=true;
    nonint=false;
    boundingLims=(1:size(lineColors,1)+1)-1/2;
    distToColorMap=1:numDistUsed;
end
    
    %% legend hack. by placing a set of points at somewhere insignificant can get legend to show up.
    for(i=1:size(lineColors,1))
        plot3(0,0,0,'Color',lineColors(i,:));
    end
    
    if(useGrouping)
        if(nonint)
            limsStr=[num2str(boundingLims(1:end-1)','%4.2g'),repmat('-',length(boundingLims)-1,1),num2str(boundingLims(2:end)','%4.2g')];
        else
            limsStr=[num2str(floor(boundingLims(1:end-1))'),repmat('-',length(boundingLims)-1,1),num2str(floor(boundingLims(2:end)')-1)]; % bins are inclusive on lower limit.
        end
        legend(limsStr,'Location','Best');
    else
        legend(num2str(distUsed), 'Location','Best');
    end
    
    %% plot lines in the ground plane (z=0)
    for(i=1:size(compareIndxs))
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        
        [~,clrIndx]=ismember(dist,distUsed);
        if(clrIndx>0)
            pt1=plotLocs(indx1,:);
            pt2=plotLocs(indx2,:);
            plot3([pt1(1);pt2(1)],[pt1(2);pt2(2)],[pt1(3);pt2(3)],'Color',lineColors(distToColorMap(clrIndx),:));
        end
    end

return