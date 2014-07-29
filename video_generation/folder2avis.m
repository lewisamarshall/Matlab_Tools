function [  ] = folder2avis( folder)
	% FOLDER2AVIS Takes a folder containing SPE and/or TIF files and makes AVIs.

	[ spe_files ] = get_files( folder, '.spe');


	for i=1:length(spe_files)
		try
	    	IM=speread(fullfile(folder, spe_files(i).name));
	    	filename=fullfile(folder, [spe_files(i).name(1:end-4),'', '.avi']);
	    	generate_movie(IM, filename);
		catch
			warning(['Generating a movie from ', spe_files(i), ' failed.']);
		end
	end

	[ tif_files ] = get_files( folder, '.tif');

	for i=1:length(tif_files)
		try
	    	IM=tiff_import(fullfile(folder, tif_files(i).name));
	    	filename=fullfile(folder, [tif_files(i).name(1:end-4),'', '.avi']);
	    	generate_movie(IM, filename);
		catch
			warning(['Generating a movie from ', tif_files(i), ' failed.']);
		end
	end

end

