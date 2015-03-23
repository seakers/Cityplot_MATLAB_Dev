function fullNeighbor=partMovePeturb(arch)

maxBin=max(arch)+1;
if(maxBin==length(arch)+1)
    maxBin=maxBin-1;
end

fullNeighbor=repmat(arch,(maxBin-1)*length(arch),1);
indxReps=repmat(1:maxBin,1,length(arch)); 
indxReps([0:(length(arch)-1)]*maxBin+arch)=[];
%         fullNeighbor(logical(toeplitz([ones(1,length(arch)-1),zeros(1,maxBin*(length(arch)-1))],[1,zeros(1,length(arch)-1)])))=indxReps;
fullNeighbor(logical(kron(eye(length(arch)),ones(maxBin-1,1))))=indxReps;
fullNeighbor=partRepair(fullNeighbor);

unique(fullNeighbor,'rows');
end