
classdef fdObstacle < handle

	properties
		# Grid
		value;

		# Dimension
		ndim; 
		ngrdx; ngrdy; ngrdz;
	end

	methods
					
		function disp(this)
			imagesc(this.value);
		end	

	end

end
