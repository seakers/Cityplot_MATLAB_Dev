function colorEdgeByDist3d(distances,plotLocs,lineColors)
compareIndxs=nchoosek(1:size(plotLocs,1),2);
%%TODO replace the following hack for the legend with hggroup to group
%%lines by distance and color. give legend by hggroup.

if(isempty(lineColors) || (ischar(lineColors) && strcmp(lineColors,'auto')));
    targetConn=size(distances,1)*3;
    tmp=triu(distances,1);
    cnts=histc(tmp(:),[0,(1:max(max(distances)))-1/2]);
    [~,maxDist]=min(abs(cnts-targetConn)); 
    maxDist=maxDist-1-(cnts(maxDist)>targetConn);
    lineColors=hsv2rgb([linspace(0,2/3,maxDist)',ones(maxDist,2)]);
end

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
return