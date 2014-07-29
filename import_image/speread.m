function [ImMat, Xdim, Ydim, Zdim, exptime] = speread(filename)
% function [ImMat, Xdim, Ydim, Zdim, exptime] = speread(file)
% put together by Tom Zangle, with pieces from Roper_ascii_to_mat_bin.m by 
% Igal Brener from Roper Scientific, and speread.m by Haiou Shen
% 8/8/06. Minor edits by Lewis A. Marshall, 2013. 
% inputs: file, the name (with path) of the .spe file to read in
% outputs: ImMat, the image data; Xdim, the Xdimension of the image data; Ydim, 
% the Y dimension; Zdim, the number of frames; exptime, the exposure time
% of the images.


% Check whether the filename exists.
if ~ exist('filename', 'var')==1
	% If it does not, open a dialogue to select a file. 
    [filename,pathname]=uigetfile('*.*', 'Select an SPE file.', '.', 'MultiSelect', 'off');
    filename=fullfile(pathname, filename);
else
	% If there is a filename variable, see what it is. 
    switch_var=exist(filename, 'file');
    switch switch_var
        case 2
            % If the filename is a file, go on. 
        case 7
			% If the filename is a folder, open a dialogue to select the file in the folder. 
            [filename,pathname]=uigetfile('*.*', 'Select an SPE file.', filename, 'MultiSelect', 'off');
		    filename=fullfile(pathname, filename);
        case 0
			%If there is no file, throw an error. 
            error('File not found.')
        otherwise
    end    
end

fid = fopen(filename, 'r', 'l'); %'r' = read only, 'l' = little endian

% read in integer header information
header = fread(fid,2050,'uint16=>uint16'); % 2050 uint16 = 4100 bytes = 32800 bits
Xdim = header(22);
Ydim = header(329);
Zdim = header(724);
DataType = header(55);

%read float header info
fseek(fid,10,'bof');
exptime = fread(fid,1,'float');
fseek(fid, 4100, 'bof');

%read in image data
switch DataType
    case 0	% FLOATING POINT (4 bytes / 32 bits)
        ImMat = fread(fid,inf,'float32=>float32');
    case 1	% LONG INTEGER (4 bytes / 32 bits)
        ImMat = fread(fid,inf,'int32=>int32');
    case 2	% INTEGER (2 bytes / 16 bits)
        ImMat = fread(fid,inf,'int16=>int16');
    case 3	% UNSIGNED INTEGER (2 bytes / 16 bits)
        ImMat = fread(fid,inf,'uint16=>uint16');
end

fclose(fid);

ImMat = reshape(ImMat,Xdim,Ydim,Zdim);

%permute the X and Y dimensions so that an image looks like in Winview
ImMat = permute(ImMat,[2,1,3]);
