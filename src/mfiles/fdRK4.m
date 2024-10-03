
classdef fdRK4 < fdIntegrator

	methods
			
		function this = fdRK4(dt, nquant=1)
			this.dt = dt;
			this.tnow = 0; 
			this.nnow = 0;
			this.ndim = nquant;
		end

		function cphi = cstep(this, rhs, cphi, param)
		
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
		
			this.update();
	
		end

	end

end
