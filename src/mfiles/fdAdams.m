
classdef fdAdams < fdIntegrator

	methods 
	
		function this = fdAdams(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;
			this.ndim = nquant;

			this.ncall = nquant; this.ccall = 0; #<- depriciated
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

		function cphi = cstep(this, rhs, cphi, params)
			
			cret = feval(rhs, this.tnow, cphi, params);

			if this.niterations == 0 	
				for n=1:this.ndim
					cphi{n}.value = cphi{n}.value + cret{n}*this.dt;
				end
			else 
				for n=1:this.ndim
					cphi{n}.value = cphi{n}.value + 0.5*this.dt*(3*cret{n}-cphi{n}.prhs); 
				end
			end

			for n=1:this.ndim
				cphi{n}.prhs = cret{n};
			end

			this.tnow = this.tnow + this.dt;
			this.niterations = this.niterations + 1;
		end


	end

end

