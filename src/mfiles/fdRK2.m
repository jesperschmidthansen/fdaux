
classdef fdRK2 < fdIntegrator

	methods
			
		function this = fdRK2(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.nnow = 0;
			this.ndim = nquant;
		end

		function cphi = cstep(this, rhs, cphi, param)
		
			cretval = feval(rhs, this.tnow, cphi, param);
			
			for n=1:this.ndim
				cphi{n}.pvalue = cphi{n}.value;
				cphi{n}.value = cphi{n}.value + 0.5*this.dt.*cretval{n}; 	
			end
		
			cretval = feval(rhs, this.tnow + 0.5*this.dt, cphi, param);
			
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.pvalue + this.dt*cretval{n};
			end
		
			this.update();
		end

	end

end
