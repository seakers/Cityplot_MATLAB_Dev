function colorEdgeWithinDist(distances,plotMet,distanceToConnect)
compareIndxs=nchoosek(1:size(distances,1),2);
% hamming=real(~plotArchs)*plotArchs'+plotArchs*real(~plotArchs)';
numColor=sum(any(distances(compareIndxs(:,1),compareIndxs(:,2))<=1,2));
colCnt=0;

for(i=1:size(compareIndxs,1))
    if(distances(compareIndxs(i,1),compareIndxs(i,2))==distanceToConnect)
        colCnt=colCnt+1;
        pt1=plotMet(compareIndxs(i,1),:);
        pt2=plotMet(compareIndxs(i,2),:);
        plot([pt1(1);pt2(1)],[pt1(2);pt2(2)],'Color',[sin(pi*colCnt/numColor)^2,cos(pi*colCnt/numColor)^2,colCnt/numColor]);
    end
end
return
