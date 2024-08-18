
classdef fdRK2 < fdIntegrator

	methods
			
		function this = fdRK2(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;
			this.ndim = nquant;

			this.ncall = nquant; this.ccall = 0;
		end

		function cphi = cstep(this, cphi, param, rhs)
		
			cretval = feval(rhs, this.tnow, cphi, param);
			
			for n=1:this.ndim
				cphi{n}.pvalue = cphi{n}.value;
				cphi{n}.value = cphi{n}.value + 0.5*this.dt.*cretval{n}; 	
			end
		
			cretval = feval(rhs, this.tnow + 0.5*this.dt, cphi, param);
			
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.pvalue + this.dt*cretval{n};
			end
		
			this.tnow = this.tnow + this.dt;
			this.niterations = this.niterations + 1;
		end

	end

end
