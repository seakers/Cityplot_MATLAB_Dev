function writeCityplotStuff(filebase,paretoArchNames,paretoDistance,paretoMetrics, metricsNames, MdscaleOptArgs)
    fid=fopen([filebase,'_met.csv'],'w');
    fprintf(fid,strjoin(metricsNames,', '));
    fclose(fid);
    dlmwrite([filebase,'_met.csv'],paretoMetrics,'-append','roffset',1);
    
    fid=fopen([filebase,'_paretoArchs.csv'],'w');
    fclose(fid);
    writeCell_R(filebase,paretoArchNames,0);
    
    dlmwrite([filebase,'_trueArchDists.csv'],paretoDistance);
    
    if ~isempty(MdscaleOptArgs)
        plotting=mdscale(paretoDistance,2,MdscaleOptArgs{:});
    else
        plottingAll=cmdscale(paretoDistance);
        plotting=plottingAll(:,1:2);
    end
    fid=fopen([filebase,'_reducedLocations.csv'],'w');
    fprintf(fid,'x,y');
    fclose(fid);
    dlmwrite([filebase,'_reducedLocations.csv'],plotting,'-append','roffset',1);
    
return

function newOffset=writeCell_R(filebase,cell,curOffset)
    if ~iscell(cell)
        if isnumeric(cell)
            dlmwrite([filebase,'_paretoArchs.csv'],cell,'-append');
            newOffset=curOffset+size(cell,1);
        else
            %assume string
            fid=fopen([filebase,'_paretoArchs.csv'],'a');
            fprintf(fid,[cell,'\n']);
            fclose(fid);
            newOffset=curOffset+1;
        end
    else
        fid=fopen([filebase,'_paretoArchs.csv'],'a');
        fprintf(fid,'{\n');
        fclose(fid);
        curOffset=curOffset+1;
        for cellindx=1:numel(cell)
            curOffset=writeCell_R(filebase,cell{cellindx},curOffset);
            if cellindx ~= numel(cell)
                fid=fopen([filebase,'_paretoArchs.csv'],'a');
                fprintf(fid,'|\n');
                fclose(fid);
                curOffset=curOffset+1;
            end
        end
        fid=fopen([filebase,'_paretoArchs.csv'],'a');
        fprintf(fid,'}\n');
        fclose(fid);
    end
return