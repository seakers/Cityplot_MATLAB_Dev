function archs=genPartArchs(archLen)
if(archLen>10)
    disp('you REALLY don''t want to do this');
    return
end

archs=genPartArchs_R(archLen,1);
return

function archs=genPartArchs_R(archLen,tail)
bellsNum=[1,1,2,5,15,52,203,877,4140,21147]; % 1st element is B0
if(archLen<=1)
    archs=[1];
    return
end

if(tail==archLen)
    archs=1:tail;
    return
end

archs=NaN(bellsNum(archLen+1),archLen);
cnt=0;

for(i=1:archLen)
    subArchs=genPartArchs_R(archLen-1,i);
    numSub=size(subArchs,1);
    archs(cnt+1:cnt+numSub,:)=[subArchs,i*ones(numSub,1)];
    cnt=cnt+numSub;
end
return
% function archs=genPartArchs_R(archLen,curVal,curPos)
%     bellsNum=[1,1,2,5,15,52,203,877,4140,21147]; % 1st element is B0
%     
%     if(archLen==1)
%         archs=1;
%         return
%     end
% 
%     archs=NaN(bellsNum(archLen+1),archLen);
%     cnt=0;
%     
%     for(i=1:curPos)
%         subArchs=genPartArchs_R(archLen-1,i,curPos+1);
%         numSub=size(subArchs,1);
%         archs(cnt+1:cnt+numSub,:)=[curVal*ones(numSub,1),subArchs];
%         cnt=cnt+numSub;
%     end
% return