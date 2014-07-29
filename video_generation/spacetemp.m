function ST=spacetemp(IM, rot_angle, ROI)
	% SPACETEMP produces a spaciotemporal plot from an image set.
	% SPACETEMP(IM) takes the 3D image matrix IM of size NxMxP, 
	% where NxM is the size of the individual image frame, and P is the number
	% of frames, and converts it into a spaceiotemporal plot. The function 
	% requires human input to determine rotation angle and the region of
	% interest. To avoid requests for human intervention, 
	% use SPACETEMP(IM, ROT_ANGLE, ROI)
	
	
	% Calculate the median and the maximum values.
 	BG=median(IM,3);
	MAX=max(IM,[],3);
	
	%Background correct each frame by the median.
	for i=1:size(IM,3)
		IM(:,:,i)=IM(:,:,i)-BG;
	end
	
	% If the rotation angle was not input, ask for it through graphical input.
	if ~exist('rot_angle', 'var')
		imagesc(MAX); axis equal;colormap(custom_colormap())
		disp('Choose two points on a horizontal line to specify the rotation angle.')
		[x,y] = ginput(2);
		rot_angle=atan((y(2)-y(1))/(x(2)-x(1)))*365/2/pi;
	end
	
	%Rotate the images by the rotation angle. 
	IM=imrotate(IM, rot_angle);
	
	% If a region of interest is not specified, ask for one. 
	if ~exist('ROI', 'var')
		MAX=max(IM,[],3);
		imagesc(MAX); axis equal;colormap(custom_colormap())
		disp('Specify two corners of the region of interest.')
		[x,y] = ginput(2);
		%process it to the correct format.
		x=min(x, size(IM,2));y=min(y, size(IM,1));
		x=max(x,1); y=max(y,1);	
		ROI=floor([min(x), max(x), min(y), max(y)]);
	end
	
	%Produce spacetemp data.
	ST=mean(IM(ROI(3):ROI(4), ROI(1):ROI(2),:),1);
	ST=reshape(ST, size(ST,2),size(ST,3),1)';
	imagesc(ST);set(gca,'YDir','normal')	
end