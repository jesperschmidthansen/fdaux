
classdef fdEuler < fdIntegrator

	methods
			
		function this = fdEuler(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;
			this.ndim = nquant;
			
			this.ncall = nquant; this.ccall = 0; #<- depreciated
		end

		function phi = step(this, phi)
		
			phi.nvalue = phi.value + phi.rhs*this.dt;

			this.update();

		end

		function phi = fstep(this, phi, rhs, funvar)
		
			phi.nvalue = phi.value + feval(rhs, this.tnow, funvar)*this.dt;
			
			this.update();

		end

		function cphi = cstep(this, cphi, param, rhs)
		
			cret = feval(rhs, this.tnow, cphi, param);
			
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.value + cret{n}*this.dt;
			end
			
			this.tnow = this.tnow + this.dt;
			this.niterations = this.niterations + 1;
		end


	end

end





