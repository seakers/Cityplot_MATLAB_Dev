function colorEdgeByDist(distances,plotLocs,lineColors)
compareIndxs=nchoosek(1:size(plotLocs,1),2);
for(i=1:size(lineColors,1))
    plot(0,0,'Color',lineColors(i,:));
end
legend(num2str([1:size(lineColors,1)]'));

for(i=1:size(compareIndxs,1))
    for distOrder=size(lineColors,1):-1:1
        indx1=compareIndxs(i,1);
        indx2=compareIndxs(i,2);
        dist=distances(indx1,indx2);
        if(dist==distOrder)
            pt1=plotLocs(indx1,:);
            pt2=plotLocs(indx2,:);
            plot([pt1(1);pt2(1)],[pt1(2);pt2(2)],'Color',lineColors(dist,:));
        end
    end
end
return
