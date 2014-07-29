function [ files ] = get_files( folder, ext )
	% GET_FILES takes a folder and an extension and outputs a structure 
	% containing all the names of the files of that type in that folder.

	% If the folder does not exist, return an error.
	if isdir(folder)==0
	    error('Directory does not exist.')
	end

	% Pull all of the files in the folder.
	files=dir(folder);

	% Initially assume all of the files in the folder
	% are not of the type specified.
	isType=false(length(files), 1);

	% For each file, 
	for i=1:length(files)
		% Pull the file extension. 
	    [pathstr, name, file_ext]=fileparts(fullfile(folder, files(i).name));
		% If the file extension is the correct extension, add to list. 
	    isType(i)=strcmpi(file_ext, ext);
	end

	% Only retain files that are of the correct type. 
	files=files(isType);

	% If the set of files is empty, return a warning. 
	if isempty(files)
	    warning(['No files of type "', ext, '".'])
	end

end