
classdef fdObstacle2d < fdObstacle

	methods
		
		function this = fdObstacle2d(grids)
			
			this.ngrdx = grids(1); this.ngrdy = grids(2);
			this.value = int64(zeros(this.ngrdy, this.ngrdx));
  
		end

		
		function phi = correct(this, phi)

			[idxi idxj] = find(this.value==true);
			nobjgrds = length(idxi);

			for n=1:nobjgrds
					
				# Get boundary points and set no-flux
				if this.value(idxi(n)-1, idxj(n)) == 0
					phi(idxi(n)-1, idxj(n)) = phi(idxi(n)-2, idxj(n));
				end
				if this.value(idxi(n)+1, idxj(n)) == 0
					phi(idxi(n)+1, idxj(n)) = phi(idxi(n)+2, idxj(n));
				end
				if this.value(idxi(n), idxj(n)-1) == 0
					phi(idxi(n), idxj(n)-1) = phi(idxi(n), idxj(n)-2);
				end
				if this.value(idxi(n), idxj(n)+1)==0
					phi(idxi(n), idxj(n)+1) = phi(idxi(n), idxj(n)+2);
				end

				phi(idxi(n), idxj(n))=0;	
			end					
			
		end


	end

end
