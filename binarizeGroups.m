%%turns the standard groups (archGroups) into a binaried set of couplings.
%%ie. turns {[1,2], [3], [4]} into [1=F,2=F,3=T,4=T,12=T,23=F,34=F...]
%%maxGroupNum-the largest group number (to find just type cellfun(@max(),archGroups) for this argument. in the origianl applications, this
%%is the number of instruments.
%%maxCoupleSize-the maximum number of couplings to consider. 2 means
%%[A,B],[A,C]... 3 means all the previous plus [A,B,C]...
%%a value above maxGroupNum will result in using maxGroupNum

% the following is inefficient and slow as heck. I suck at combinatorics.
%WARNING: striling is known to give wrong values for more than 50
%instruments.

function [binaried,numSubsets]=binarizeGroups(archGroups,maxGroupNum,maxCoupleSize)
%% get number of subsets. 
%I'm sure there's a better way, but i don't feel like figuring it out when this isn't the slow operation.
numSubsets=0;
maxCoupleSize=min(maxGroupNum,maxCoupleSize);
for(k=2:maxCoupleSize)
    numSubsets=numSubsets+nchoosek(maxCoupleSize,k);
end

%%binarize
max_indx=0;
binaried=zeros(length(archGroups),numSubsets);
for i=1:length(archGroups) %each architecture
    groups=archGroups{i};
    strtIndx=0;
    for partSize=2:maxCoupleSize % skip the 1 partition as it represents each singleton instruement. For the current application, this would be all ones
        indxSet=nchoosek(1:maxGroupNum,partSize);

        for j=1:length(groups)
            if(length(groups{j})>=partSize) % to make only approriate subset (i.e. ABC->AB=F, BC=F, ABC=T versus all true), replace >= with ==. nchoosek is then redundant.
                lookSet=nchoosek(groups{j},partSize);
                [~,locIndx]=ismember(lookSet,indxSet,'rows');
                binaried(i,strtIndx+locIndx)=1;
                max_indx=max(max_indx,max(strtIndx+locIndx));
            end
        end
        strtIndx=strtIndx+size(indxSet,1);
    end
end
max_indx
