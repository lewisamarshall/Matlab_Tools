function [IM]=tiff_import(filename)
	%TIFF_IMPORT Takes a tiff filename, and outputs the image.
	%   Imports a tiff file, which can be multiframe, from 'filename'.
	%   Outputs an [m,n,p] matrix where m and n are the size of the frame and z
	%   is the number of frames.

	% Check whether the filename exists.
	if ~ exist('filename', 'var')==1
		% If it does not, open a dialogue to select a file. 
	    [filename,pathname]=uigetfile('*.*', 'Select a TIF file.', '.', 'MultiSelect', 'off');
	    filename=fullfile(pathname, filename);
	else
		% If there is a filename variable, see what it is. 
	    switch_var=exist(filename, 'file');
	    switch switch_var
	        case 2
	            % If the filename is a file, go on. 
	        case 7
				% If the filename is a folder, open a dialogue to select the file in the folder. 
	            [filename,pathname]=uigetfile('*.*', 'Select a TIF file.', filename, 'MultiSelect', 'off');
			    filename=fullfile(pathname, filename);
	        case 0
				%If there is no file, throw an error. 
	            error('File not found.')
	        otherwise
	    end    
	end
	% Get the info about the file. 
	info = imfinfo(filename);

	if ~strcmp(info(1).ColorType, 'grayscale')
		error('Expecting a grayscale image. Sorry.')
	end

	% Initialize a variable of the correct size. 
	switch info(1).BitDepth
	case 1
		IM=logical(zeros(info(1).Height, info(1).Width, numel(info)));
	case 8
		IM=uint8(zeros(info(1).Height, info(1).Width, numel(info)));
	
	case {12, 16}
		IM=uint16(zeros(info(1).Height, info(1).Width, numel(info)));
	case {24, 32}
		IM=uint32(zeros(info(1).Height, info(1).Width, numel(info)));
	case{36, 48, 64}
		IM=uint64(zeros(info(1).Height, info(1).Width, numel(info)));
	otherwise
	    warning('Unexpected bit depth. Returning a 32-bit image.');
		IM=uint32(zeros(info(1).Height, info(1).Width, numel(info)));
	end

	% Iterate over the frames. Add each frame for the image. 
	for k = 1:numel(info)
	    IM(:,:,k) = imread(filename, k, 'Info', info);
	end

end