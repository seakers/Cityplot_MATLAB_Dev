%%inverse operation of stdGroups.
%%turns archs {{[1,2], [3], [4]};{[1,2], [3], [4]}} |-> [[1,1,2,3];[1,1,2,3]]
%%where [1,1,2,3] means {[1,2], [3], [4]}
function [archRep]=stdPart(archsCell)
    tmp=archsCell{1};
    numInst=max(cellfun(@max,tmp));
    archRep=NaN(numel(archsCell),numInst);
    
    for archI=1:numel(archsCell)
        thisArch=archsCell{archI};
        
        for partI=1:numel(thisArch)
            archRep(archI,thisArch{partI})=partI;
        end
        
        archRep(archI,:)=partRepair(archRep(archI,:));
    end
return