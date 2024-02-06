
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
			
			if this.niterations == 0
				phi.nvalue = phi.value + feval(rhsfun, this.tnow, funvar)*this.dt; 
			else
				phi.rhs = feval(rhsfun, this.tnow, funvar);
				phi.nvalue = phi.value + 0.5*this.dt*(3*phi.rhs - phi.prhs);
			end
			
			phi.prhs = phi.rhs;
			
			this.update();	
		end


		function [w, phi, u, v]  = vstep(this, w, phi, u, v, invRe)
			
			w.calcddx(); w.calcddy(); 
			w.calcd2dx2(); w.calcd2dy2();	

			w.rhs = -u.value.*w.ddx - v.value.*w.ddy + invRe*(w.d2dx2 + w.d2dy2);

			if this.iteration == 0
				w.value = w.value + this.dt*w.rhs;
			else	
				w.value = w.value + 0.5*this.dt*(3*w.rhs - w.prhs);
			end
			
			if w.bcs(1)=='p'
				phi.value = fdspec2d(-w.value, w.ngrdx, w.dx);
			else	
				phi.value = fdsor2d(phi.value, -w.value, [w.dx, w.dy], this.relaxfac, this.errsor);
			end

			w.prhs = w.rhs;
			
			phi.calcddx(); phi.calcddy(); 
			u.value = phi.ddy; v.value = -phi.ddx; 
	
			this.tnow = this.tnow + this.dt;
			this.iteration = this.iteration + 1;

		end

	end	


end

