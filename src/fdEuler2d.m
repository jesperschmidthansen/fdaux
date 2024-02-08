
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

#{
		function [w, phi, u, v] = vstep(this, w, phi, u, v, invRe)
			w.calcddx(); w.calcddy(); 
			w.calcd2dx2(); w.calcd2dy2();	
		
			w.rhs = -u.value.*w.ddx - v.value.*w.ddy + invRe*(w.d2dx2 + w.d2dy2);
			w.value = w.value + this.dt*w.rhs;
		
			if w.bcs(1) == 'p' 
				phi.value = fdspec2d(-w.value, w.ngrdx, w.dx);
			else
				phi.value = fdsor2d(phi.value, -w.value, [w.dx, w.dy], this.relaxfac, this.errsor);
			endif

			phi.calcddx(); phi.calcddy(); 
			u.value = phi.ddy; v.value = -phi.ddx; 
	
			this.iteration = this.iteration + 1;
			this.tnow = this.tnow + this.dt;
		end
#}
	end

end
