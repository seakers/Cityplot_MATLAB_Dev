function toColor=regularizeColorMap(input, numToColor, colorMap, varargin)
%% parse inputs
p=inputParser;

defColorMap=hsv2rgb([sin(2*pi/3*(linspace(0,1,20)))',ones(20,2)]);
addRequired(p,'input')
addRequired(p,'numToColor')
addOptional(p,'colorMap',defColorMap)
addParameter(p,'defaultColor','k',@(def) (isnumeric(def) && (size(def)==[1,3] || size(def)==[3,1])) || validatestring(def,{'y','m','c','r','g','b','w','k'}));
addParameter(p,'defaultValue',[]);

parse(p,input,numToColor,colorMap,varargin{:})

pInput=p.Results.input;
pNumToColor=p.Results.numToColor;
if(isgraphics(p.Results.colorMap))
    pColorsMap=colormap(p.Results.colorMap);
else
    pColorsMap=p.Results.colorMap;
    [~,n]=size(pColorsMap);
    if(n~=3)
        error('failed to parse colormap for regularizeColorMap');
    end 
end

%% make output
if(isempty(pInput))
    toColor=repmat(p.Results.defaultColor,pNumToColor,1);
else
    [m,n]=size(pInput);
    if(m==1 || n==1)
        uChk=unique(pInput);
        if(length(uChk)>=2)
            refDists=linspace(min(pInput),max(pInput),size(pColorsMap,1));
            toColor=interp1(refDists,pColorsMap,pInput);
        else
            toColor=repmat(p.Results.defaultColor,max(m,n),1);
        end
    elseif(m==3 && n==pNumToColor) % assume it's a colorcode
        toColor=pInput';
    elseif(n==3 && m==pNumToColor)
        toColor=pInput;
    else
        if(any(strcmp(p.UsingDefaults,'defaultValue')))
            error('inputs are insuitable size to regularize color mapping and not given a default value')
        else
            varin=find(strcmp(varargin{:},'defaultValue'));
            filterOut=[varin,varin+1];
            mask=true(numel(varrgin),1);
            mask(filterOut)=false; % this will prevent inifinite looping if the default value fails to comply.
            regularizeColorMap(pColorsMap,p.Results.defaultValue,numToColor,varargin{mask});
        end
    end
end