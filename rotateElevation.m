function rotateElevation(fig,filename)
figure(fig);
[startAz,startEl]=view;
axis manual
eleRot=startEl+[0:1:90];
frames=length(eleRot);
movieDat(frames)=struct('cdata',[],'colormap',[]);

for(indx=1:frames)
    view([startAz,eleRot(indx)]);
    drawnow
    movieDat(indx)=getframe(fig);
end

movie2avi(movieDat,[filename,'.avi']);