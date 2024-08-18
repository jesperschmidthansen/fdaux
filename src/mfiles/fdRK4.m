
classdef fdRK4 < fdIntegrator

	methods
			
		function this = fdRK4(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.niterations = 0;
			this.ndim = nquant;

			this.ncall = nquant; this.ccall = 0;
		end

		function cphi = cstep(this, cphi, param, rhs)
		
			crhs_1 = feval(rhs, this.tnow, cphi, param);
			for n=1:this.ndim
				cphi{n}.pvalue = cphi{n}.value;
				cphi{n}.value = cphi{n}.pvalue + 0.5*this.dt.*crhs_1{n}; 	
			end
		
			crhs_2 = feval(rhs, this.tnow + 0.5*this.dt, cphi, param);
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.pvalue + 0.5*this.dt*crhs_2{n};
			end
		
			crhs_3 = feval(rhs, this.tnow + 0.5*this.dt, cphi, param);
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.pvalue + this.dt*crhs_3{n};
			end
		
			crhs_4 = feval(rhs, this.dt+this.tnow, cphi, param);
			
			for n=1:this.ndim
				cphi{n}.value = cphi{n}.pvalue  + this.dt/6.*(crhs_1{n} + 2*crhs_2{n} + 2*crhs_3{n} + crhs_4{n});
			end
			
			this.tnow = this.tnow + this.dt;
			this.niterations = this.niterations + 1;
		end

	end

end
