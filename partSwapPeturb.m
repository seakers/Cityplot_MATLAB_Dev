function fullNeighbor=partSwapPeturb(arch)
    swapPairs=nchoosek(1:length(arch),2);
    
    neIndx=arch(swapPairs(:,1))~=arch(swapPairs(:,2));
    
    fullNeighbor=repmat(arch,sum(neIndx),1); 
    
    swapIndx1=sub2ind(size(fullNeighbor),1:size(fullNeighbor,1),swapPairs(neIndx,1)');
    swapIndx2=sub2ind(size(fullNeighbor),1:size(fullNeighbor,1),swapPairs(neIndx,2)');
    
    fullNeighbor(swapIndx1)=fullNeighbor(swapIndx2);
    fullNeighbor(swapIndx2)=arch(swapPairs(neIndx,1));
    
    fullNeighbor=partRepair(fullNeighbor);
return