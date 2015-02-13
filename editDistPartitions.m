% 
function [dist]=editDistPartitions(part)
pairwise=nchoosek(1:size(part,2),2);
moveDist=abs(max(part(pairwise(:,1),:),[],2)-max(part(pairwise(:,2),:),[],2));
hamming=sum(part(pairwise(:,1),:)~=part(pairwise(:,2),:),2);
swapDist=floor((hamming-moveDist)/2);

dist=NaN(size(part,2));
for(i=1:size(pairwise,1))
    dist(pairwise(i,1),pairwise(i,2))=swapDist(i)+moveDist(i);
    dist(pairwise(i,2),pairwise(i,1))=dist(pairwise(i,1),pairwise(i,2));
end
dist(logical(eye(size(dist))))=0;

%% trash. old attempt. reained in case the current one doesn't actually work.
%     [partSize1,pS1Lkup]=sort(cellfun('length',part));
%     [partSize2,pS2Lkup]=sort(cellfun('length',part2));
%     
%     %% begin calculating distance. Will transform part into part 2 and count number of steps needed
%     dist=0;
%     
%     % adjust to same size partitions.
% %     while(partSize1~=partSize2)
% %         % among those of different sizes
% %         % find the two most similar and one more that has a different character
% %         % move a different character from one to the other
% %         % adjust the partSizes -- both the numeric values and the lookup (pS#lkup)
% %     end
%     % equivalent to the sum total of different sizes divided by 2?
%     
%     
%     % swap to same
% %     notSame=true;
% %     while(notSame)
% %         % check each subset for different characters.
% %         if([part{:}~=part2{:}])
% %             % find two most similiar
% %             % swap a different character
% %         else
% %             notSame=false;
% %         end
% %     end
%     % equivalent to the hamming distance of the full character strings divided by 2 after groups are same sizes?
%     sortPart1=cellfun('sort',part,'uniformOutput',false);
%     sortPart2=cellfun('sort',part2,'uniformOutput',false);
%     
%     
return