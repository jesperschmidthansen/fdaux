
classdef fdAdams2d < fdIntegrator

	methods 
	
		function this = fdAdams2d(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;

			this.ncall = nquant; this.ccall = 0;

			this.dt = dt;
		end

		function phi = step(this, phi)
			
			if this.niterations == 0
				phi.nvalue = phi.value + this.dt*this.rhs;
			else	
				phi.nvalue = phi.value + 0.5*this.dt*(3*phi.rhs - phi.prhs);
			end
			
			phi.prhs = phi.rhs;
			
			this.update();	
		end

		function phi = fstep(this, phi, rhsfun, funvar)
			
			phi.rhs = feval(rhsfun, this.tnow, funvar);

			if this.niterations == 0
				phi.nvalue = phi.value + phi.rhs.*this.dt; 
			else
				phi.nvalue = phi.value + 0.5*this.dt*(3*phi.rhs - phi.prhs);
			end
			
			phi.prhs = phi.rhs;
			
			this.update();	
		end

	end

end

