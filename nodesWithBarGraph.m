function nodesWithBarGraph(plotting, metrics, heightLim,varargin)
xrange=range(plotting(:,1));

if nargin>=4
    chkAnnotate=1;
    haveText=varargin{1};
    textContent=varargin{2};
    if(isempty(haveText) || isempty(textContent))
        chkAnnotate=0;
    end
else
    chkAnnotate=0;
end
if nargin==6
    legend2lbls=varargin{3};
else
    legend2lbls=[];
end

rectWidth=xrange/60;
n_met=metrics-repmat(min(metrics,[],1),size(metrics,1),1); 
n_met=n_met./repmat(max(n_met,[],1),size(n_met,1),1);
rectHeight=n_met.*repmat(heightLim,size(n_met,1),1);

colorcycle='ybrgkc'; % notice start at 2nd element by 1 based indexing.

% ax2=axes('Position',get(gca(),'Position'),'xlim',get(gca(),'xlim'),'ylim',get(gca(),'ylim'),'Visible','off','Color','none');
RH=zeros(size(metrics,2),1);
% hold on
for(i=1:size(plotting,1))

	MH=plot(plotting(i,1),plotting(i,2),'MarkerFaceColor',zeros(1,3),'Marker','o');
    set(get(get(MH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    for(metI=1:size(metrics,2))
        if(rectHeight(i,metI)>0)
            adjust=rectWidth*(metI-1);
%             RH(metI)=rectangle('Position',[plotting(i,1)+adjust,plotting(i,2),rectWidth,rectHeight(i,metI)],'FaceColor',colorcycle(mod(metI,length(colorcycle))+1),'Parent',ax2);
              RH(metI)=rectangle('Position',[plotting(i,1)+adjust,plotting(i,2),rectWidth,rectHeight(i,metI)],'FaceColor',colorcycle(mod(metI,length(colorcycle))+1));
        end
    end
    if(chkAnnotate && haveText(i)>0 && ~isnan(haveText(i)) && ~isempty(textContent{haveText(i)}))
        text(plotting(i,1),plotting(i,2)-range(plotting(:,2))/60,textContent{haveText(i)})
%         text(plotting(i,1),plotting(i,2)-range(plotting(:,2))/60,textContent{haveText(i)},'Parent',ax2)
    end
end

if(~isempty(legend2lbls))
    ax1=gca();
    ax2=axes('Position',get(gca(),'Position'),'xlim',get(gca(),'xlim'),'ylim',get(gca(),'ylim'),'Visible','off','Color','none');
    hold on
    % for(i=1:size(metrics,2))
    %     plot(0,0,'s','markeredgecolor',get(RH(i),'edgecolor'),'markerfacecolor',get(RH(i),'facecolor'));
    % end
    placeLine=min(get(ax1,'ylim'));
    bh=bar(placeLine*ones(size(metrics,2)),'BaseValue',placeLine);
    for(i=1:size(metrics,2))
        set(bh(i),'FaceColor',colorcycle(mod(i,length(colorcycle))+1));
    end

    lh=legend(legend2lbls,'Location','SouthEast');
    set(lh,'Color','w');
end
return
