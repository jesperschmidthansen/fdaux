
classdef fdObstacle2d < fdObstacle

	methods
		
		function this = fdObstacle2d(grids)
			
			this.ngrdx = grids(1); this.ngrdy = grids(2);
			this.value = int64(zeros(this.ngrdy, this.ngrdx));
  
		end

		
		function phi = correct(this, phi)

			[ngrdy, ngrdx] = size(phi);
			[idxi idxj] = find(this.value==true);
			nobjgrds = length(idxi);

			phi = fdcorrectn2d(phi, this.value, idxi, idxj, nobjgrds); 

		end


	end

end
