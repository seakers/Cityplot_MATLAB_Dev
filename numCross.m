function crossings=numCross(connect,xy)
    %%counts the number of crossings of nodes in a graph given by connect
    %%matrix and positions xy=[x1,y1;x2,y2;...]
    
%     %% get the lines drawn between points
%     pointPairs=nchoosek(1:size(xy,1),2);
%     linesI=NaN(size(pointPairs));
%     for i=1:size(pointPairs)
%         if(connect(pointPairs(i,1),pointPairs(i,2)))
%             linesI(i,:)=pointPairs(i,:);
%         end
%     end
%     linesI(isnan(linesI(:,1)),:)=[];
%     
% %     lines=[(xy(linesI(:,1),2)-xy(linesI(:,2),2))/(xy(linesI(:,1),1)-xy(linesI(:,2),1)),xy(linesI(:,1),:)]; % BAD
% %     slopes=(xy(linesI(:,1),2)-xy(linesI(:,2),2))./(xy(linesI(:,1),1)-xy(linesI(:,2),1)); %BAD, can divide by zero when have vertical lines.
%     deltX=(xy(linesI(:,1),1)-xy(linesI(:,2),1));
%     deltY=(xy(linesI(:,1),2)-xy(linesI(:,2),2));
%     % intercepts=xy(linesI(:,1),1);
%     
%     %% get line pairs that don't share common verticies. Might intersect in an interesting way
%     linePairs=nchoosek(1:size(linesI),2);
%     lineSel=NaN(size(linePairs));
%     for i=1:size(linePairs,1)
%         if(length(unique([linesI(linePairs(i,1),:),linesI(linePairs(i,2),:)]))==4)
%             lineSel(i,:)=linePairs(i,:);
%         end
%     end
%     lineSel(isnan(lineSel))=[];
%     
%     %% count crossings
%     crossings= sum(abs(diff(slopes(lineSel)))>1e-12); % notice that if lines are parallel then either bad inputs (same line) or not intersecting.

%% get all quadruples
    pointQuad=nchoosek(1:size(xy,1),4);
    for i=1:size(pointQuad,1)
        centroids(i)=mean(xy(pointQuad(i),:))
        
        ordering
    end
return