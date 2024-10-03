
classdef fdEuler < fdIntegrator

	methods
			
		function this = fdEuler(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;
			this.ndim = nquant;
		end

		function phi = step(this, phi)
			phi.nvalue = phi.value + phi.rhs*this.dt;
			this.update();
		end

		function cphi = cstep(this, rhs, cphi, params)
		
			cret = feval(rhs, this.tnow, cphi, params);
			
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.value + cret{n}*this.dt;
			end
			
			this.update();
		end


	end

end





