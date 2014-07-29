function RGB=demosaic_movie(IM, sensorAlignment)
	if ~exist('sensorAlignment', 'var')==1'
		sensorAlignment='rggb';
	end
	
	RGB=zeros(size(IM,1), size(IM,2), 3, size(IM,3), 'uint8');
	
	for i=1:size(IM,3)
		RGB(:,:,:,i)=demosaic(IM(:,:,i), sensorAlignment);
	end
end

	