%%repairs partitioning schemes that violate the max value of 1,2,3...
%%constraint.
%%does not repair non-integer solutions.
function archs=partRepair(archs)
    for(oneArch=1:size(archs,1))
        arch=archs(oneArch,:);
        allowMax=1; tmpVal=length(arch)+1;
        for(indx=1:length(arch))
            if(arch(indx)>allowMax)
                % problem: want to move the current element use allowMax.
                % move all elements using the allowMax to a temporary value well above the maximum allowable
                % this partition will be moved to an acceptable value later
                % when find such an element.
                arch(arch==allowMax)=tmpVal; tmpVal=tmpVal+1; 
                % find the current elements sharing arch(indx) change all to allowMax
                arch(arch==arch(indx))=allowMax;
                % increment allowMax
                allowMax=allowMax+1;
            elseif(arch(indx)==allowMax)
                allowMax=allowMax+1;
            end
        end
        archs(oneArch,:)=arch;
    end
return