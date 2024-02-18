
classdef fdRK2 < fdIntegrator

	methods
			
		function this = fdRK2(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;

			this.ncall = nquant; this.ccall = 0;
		end

		function phi = fstep(this, phi, rhs, funvar)
		
			value_half = phi.value +  feval(rhs, this.tnow, funvar)*0.5*this.dt;

			phi.nvalue = phi.value + feval(rhs, this.tnow, funvar)*this.dt;
			
			this.update();

		end

	end

end
