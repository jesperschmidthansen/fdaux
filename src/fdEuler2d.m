
classdef fdEuler2d < fdIntegrator

	methods
			
		function this = fdEuler2d(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;

			this.ncall = nquant; this.ccall = 0;
		end

		function phi = step(this, phi)
		
			phi.nvalue = phi.value + phi.rhs*this.dt;

			this.update();

		end

		function phi = fstep(this, phi, rhs, funvar)
			
			phi.nvalue = phi.value + feval(rhs, this.tnow, funvar)*this.dt;
			
			this.update();

		end

	end

end
