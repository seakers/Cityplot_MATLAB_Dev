function rotateInXYPlane(fig,filename)
%open the figure manually assume current figure

figure(fig);
[startAz,startEl]=view;
axis manual
aziRot=startAz+[0:1:360];
frames=length(aziRot);
movieDat(frames)=struct('cdata',[],'colormap',[]);

for(indx=1:frames)
    view([aziRot(indx),startEl]);
    drawnow
    movieDat(indx)=getframe(fig);
end

movie2avi(movieDat,[filename,'.avi']);