function [filterDist]=distToTargetConn(distances, targetConn)
p=inputParser();
addRequired(p, 'distances', @isnumeric);
addOptional(p, 'targetConn', floor(size(distances,1)*log(size(distances,1))), @isnumeric);

parse(p,distances, targetConn);

dist=p.Results.distances;
relevant=triu(dist,1)>0;
relevantDist=dist(relevant);

[sortRDist]=sort(relevantDist,'ascend');

maxDist=sortRDist(min(length(sortRDist),p.Results.targetConn+1));

filter=dist<maxDist;
andFilter=filter & relevant;

indx=1:numel(dist);
[indx1,indx2]=ind2sub(size(dist),indx(andFilter(:)));
distLine=dist(:);
filterDist=[indx1',indx2',distLine(andFilter(:))];