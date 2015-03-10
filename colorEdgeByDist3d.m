function colorEdgeByDist3d(distances,plotLocs,lineColors)
compareIndxs=nchoosek(1:size(plotLocs,1),2);
%%TODO replace the following hack for the legend with hggroup to group
%%lines by distance and color. give legend by hggroup.
for(i=1:size(lineColors,1))
    plot3(0,0,0,'Color',lineColors(i,:));
end
legend(num2str([1:size(lineColors,1)]'));

%% plot the points in the ground plane z=0.
for(i=1:size(compareIndxs,1))
    for distOrder=size(lineColors,1):-1:1
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        if(dist==distOrder)
            pt1=plotLocs(indx1,:);
            pt2=plotLocs(indx2,:);
            plot3([pt1(1);pt2(1)],[pt1(2);pt2(2)],[0;0],'Color',lineColors(dist,:));
        end
    end
end
return