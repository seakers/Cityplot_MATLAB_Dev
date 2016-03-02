%%plots edges in the ground plane with
function [handle]=plotInGroundPlane(handle, plotLocs, distances, lineColors, varargin)
%% input parsing and checking
p=inputParser();

addRequired(p,'plotLocs', @(in) isnumeric(in));
addRequired(p,'distances', @(in) isnumeric(in) && size(in,2)==3);
addOptional(p,'lineColors',hsv2rgb([sin(4/3*pi*linspace(0,1,16))',ones(16,2)]), @(in) isnumeric(in) && size(in,2)==3);
addParameter(p,'interpMethod','linear', @(x) any(validatestring(x, {'linear','nearest','next','previous','pchip','cubic','v5cubic','spline'})));

if(~exist('varargin'))
    varargin=cell(0);
end

switch nargin
    case 1
        error('too few inputs to plotInGroundPlane');
    case 2
        parse(p,handle,plotLocs);
        handle=figure();
    case {3,5} % one optional.
        if(all(size(handle)==[1,1]) && isgraphics(handle))
            parse(p,plotLocs, distances, varargin{:});
        else
            parse(p,handle,plotLocs, distances, varargin{:})
            handle=figure();
        end
    case 4
        if(all(size(handle)==[1,1]) && isgraphics(handle))
            parse(p,plotLocs,distances,lineColors);
        else
            parse(p,handle,plotLocs,distances,lineColors)
        end
    case 6
        parse(p,plotLocs,distances, lineColors, varargin{:});
    otherwise
        error('too many inputs to plotInGroundPlane');
end
if(~(all(size(handle)==[1,1]) && isgraphics(handle)))
    error('figure handle is not a figure handle')
end

%% plot edges edge-by-edge
dist=p.Results.distances;
pointLocs=p.Results.plotLocs;
if(min(dist(:,3))==max(dist(:,3)))
    colorToUse=repmat(p.Results.lineColors(1,:),size(dist,1),1);
else
    colorToUse=interp1(linspace(min(dist(:,3)), max(dist(:,3)),size(p.Results.lineColors,1)), p.Results.lineColors, dist(:,3), p.Results.interpMethod);
end
for(i=1:size(dist,1))
    indx1=dist(i,1);
    indx2=dist(i,2);
    pt1=pointLocs(indx1,:);
    pt2=pointLocs(indx2,:);
    
    plot3([pt1(1); pt2(1)], [pt1(2); pt2(2)], zeros(2,1), 'Color', colorToUse(i,:));
end
return