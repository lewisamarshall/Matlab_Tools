function [map]=custom_colormap(levels, colors, lab_flag)
	
	% CUSTOM_COLORMAP generates a colormap in custom colors
	% Takes LEVELS and COLORS, and interpolates a colormap
	% with the specified number of levels between the 
	% colors chosen. 
	
	%LEVELS should be an integer.
	
	% COLORS is a set of colors that in an n x 3 matrix, 
	% Each row, COLORS(i,:), is an RGB color. 
	
	% New feature: LAB_FLAG. If the flag is set to 1, interpolation 
	% is performed in LAB color space instead of in RGB space. 
	
	% Returns a map.
	
	% Complete rewrite, Lewis Marshall, 2013

	%% Correct empty variables
	% if LEVELS is empty, use 256 levels.
	if ~exist('levels', 'var')
	    levels=256;
	else
		if levels~=uint16(levels)
			error('LEVELS must be a positive integer.')
		end
	end
	
	% if COLORS is empty, use [white;black]
	if ~exist('colors', 'var')
		colors=[1,1,1; 0,0,0];
	else
		if size(colors, 2)~=3
			error('COLORS must be an n x 3 matrix with values between 0 and 1.')
		end
	end
	
	%if there is no LAB_FLAG, set it to zero.
	if ~exist('lab_flag', 'var')
	    lab_flag=0;
	elseif lab_flag~=0 && lab_flag~=1
		warning('Unexpected LAB_FLAG variable. Should be 0 or 1. Ignoring.')
	end
	
	% If LAB_FLAG is equal to one, convert the color to lab space.
	% This script uses the RGB2LAB and LAB2RGB functions. 
	% To use them, the colors need to be reshaped.
	if lab_flag==1
		colors=reshape(colors, [1, size(colors)]);
		colors=RGB2Lab(colors);
		colors=reshape(colors, [size(colors,2), size(colors,3)]);
	end

	%Each color in the input list of colors is a node.
	nodes=size(colors,1);
	node_location=round(linspace(1, levels, nodes));
	map=zeros(levels,3);				%Initialize the output custom colormap

	% fill the map using the interp1 function. 
	for i=1:3
		map(:,i)=interp1(node_location, colors(:,i), 1:levels);
	end
	
	% Convert the map in lab space back to RGB space. 
	if lab_flag==1
		map=reshape(map, [1, size(map)]);
		map=Lab2RGB(map);
		map=reshape(map, [size(map,2), size(map,3)]);
		% The map should be in range 0-1. range of Lab script, 256
		map=double(map)/256;
	end
	
end