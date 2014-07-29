function []=generate_movie(M, filename, fps, framesize)
	% Takes a 3-dimensional image matrix and converts it to an avi movie. 
	
	% The matrix M must be an A x B x C matrix, where A x B is 
	% the frame size and C is the number of frames. 
	
    % Movie is saved to file specified by "filename". If no filename
	% is specified the file is saved to "movie.avi". 
	
    % Optionally takes "fps" as the frame rate. Default frame rate is 6 fps.
	
    % Optionally takes a colormap. Default colormap is the map specified by
	% custom_colormap. 
	
	% The function can also optionally take a framesize, which is the number
	% of pixels in the final movie. This framesize defaults to the dimensions
	% of M(:,:,1).
	
    % The video is compressed in Cinepak format if available. If not, the
    % video is uncompressed.
    
if (~exist('fps', 'var'))
    fps=6;
end

if (~exist('filename', 'var'))
    filename='movie.avi';
end

if (exist('framesize', 'var'))
    if length(framesize)~=2
        framesize=[512,512];
        warning('Framesize should be a length 2 vector. Defaulting to 512 x 512')
    end
else
    framesize=[size(M,2),size(M,1)];
end

tic;
    
h=figure('Position',[1 1 framesize(1) framesize(2)]);
	
%create frames
try
    aviobj = avifile(filename,'compression','Cinepak', 'fps', fps);
catch
    aviobj = avifile(filename,'compression','none', 'fps', fps);
    disp('Compression unavailable. Writing uncompressed.')
end

try
	for j=1:size(M,4)
        image(M(:,:,:, j))
        axis equal; axis off; set(gca, 'Position', [0 0 1 1]); axis equal;
        drawnow
        FRAME=getframe(h);
        aviobj = addframe(aviobj,FRAME);     
    end
    
    close(h)
    
catch
    aviobj=close(aviobj);
    error('Failed to complete avi file.')
end
	
aviobj = close(aviobj);

disp([filename, ' written.'])

toc

