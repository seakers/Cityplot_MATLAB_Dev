function colorEdgeByDist3d(distances,plotLocs,lineColors)
cap=15;
targetMult=3;

compareIndxs=nchoosek(1:size(plotLocs,1),2);
%%TODO replace the following hack for the legend with hggroup to group
%%lines by distance and color. give legend by hggroup.

if(isempty(lineColors) || (ischar(lineColors) && strcmp(lineColors,'auto')));
    useAuto=true;
    targetConn=size(distances,1)*targetMult;
    tmp=triu(distances,1);
    if(max(abs(distances-floor(distances)))<1e-13) % if integer distances
        nonint=false;
        cnts=histc(tmp(:),[0,1:max(max(distances))]);
        willConn=cumsum(cnts(2:end));
        [~,maxDist]=min(abs(willConn-targetConn)); 
        maxDist=maxDist-(willConn(maxDist)>targetConn);
        numDistUsed=sum(cnts(2:maxDist+1)>0);
        distUsed=find(cnts(2:maxDist+1)>0,numDistUsed);
    else
        nonint=true;
        cln=tmp(tmp>0);
        [~,sortI]=sort(cln);
        distUsed=cln(sortI(1:min(targetConn,length(cln))));
        maxDist=max(distUsed);
        numDistUsed=maxDist;
    end
    
    if(numDistUsed>cap || nonint) %won't be able to see entire legend
        useGrouping=true;
        boundingLims=linspace(min(distUsed),max(distUsed),cap);
%         div=floor(range(distUsed)/cap);
%         boundingLims=min(distUsed)+[0:div:div*(cap+1)];
        [~,ind]=histc(distUsed,boundingLims);
    else
        useGrouping=false;
        ind=1:numDistUsed;
    end
    lineColors=hsv2rgb([linspace(0,2/3,max(ind))',ones(max(ind),2)]);   
    
    for(i=1:size(lineColors,1))
        plot3(0,0,0,'Color',lineColors(i,:));
    end
    if(useGrouping)
        if(nonint)
            limsStr=[num2str(boundingLims(1:end-1)','%4.2g'),repmat('-',length(boundingLims)-1,1),num2str(boundingLims(2:end)','%4.2g')];
        else
            limsStr=[num2str(boundingLims(1:end-1)'),repmat('-',length(boundingLims)-1,1),num2str(boundingLims(2:end)')];
        end
        legend(limsStr,'Location','Best');
    else
        legend(num2str(distUsed), 'Location','Best');
    end
    
    for(i=1:size(compareIndxs))
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        
        [~,clrIndx]=ismember(dist,distUsed);
        if(clrIndx>0)
            pt1=plotLocs(indx1,:);
            pt2=plotLocs(indx2,:);
            plot3([pt1(1);pt2(1)],[pt1(2);pt2(2)],[0;0],'Color',lineColors(ind(clrIndx),:));
        end
    end
else

for(i=1:size(lineColors,1))
    plot3(0,0,0,'Color',lineColors(i,:));
end
legend(num2str([1:size(lineColors,1)]'));

%% plot the points in the ground plane z=0.
distBins=(1:size(lineColors,1)+1)-1/2;
for(i=1:size(compareIndxs,1))
    for distOrder=size(lineColors,1):-1:1
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        if(distBins(distOrder)<dist && dist<=distBins(distOrder+1))
            pt1=plotLocs(indx1,:);
            pt2=plotLocs(indx2,:);
            plot3([pt1(1);pt2(1)],[pt1(2);pt2(2)],[0;0],'Color',lineColors(dist,:));
        end
    end
end
end
return