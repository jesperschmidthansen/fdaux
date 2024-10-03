
classdef fdAdams < fdIntegrator

	methods 
	
		function this = fdAdams(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.nnow = 0;
			this.ndim = nquant;
		end

		function phi = step(this, phi)
			
			if this.nnow == 0
				phi.nvalue = phi.value + this.dt*this.rhs;
			else	
				phi.nvalue = phi.value + 0.5*this.dt*(3*phi.rhs - phi.prhs);
			end
			
			phi.prhs = phi.rhs;
			
			this.update();	
		end
		
		function cphi = cstep(this, rhs, cphi, params)
			
			cret = feval(rhs, this.tnow, cphi, params);

			if this.nnow == 0 	
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

			this.update();
		end


	end

end

