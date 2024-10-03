
classdef fdIntegrator < handle

	properties
		# Time step, maximum allowed time step, and current time
		dt; dtmax; tnow;

		# System dimensions
		ndim;		

		# Current no. of iterations, total number of iterations
		nnow; ntotal;
	end

	methods

		function disp(this)
			printf("Time step: %e, current time: %f, iteration number: %d\n", ...
					this.dt, this.tnow, this.nnow);
		end		

		function update(this)
	
			this.tnow = this.tnow + this.dt;
			this.nnow = this.nnow + 1;
		end

		function setdt(this, dtmax, maxcourant, u, v)

			if nargin==2
				this.dt = dtmax;
			elseif nargin==5
				courant = fdcourant(this.dt, u, v);
				this.dt = this.dt*min([maxcourant/courant, 1.01]);
				
				if this.dt > dtmax
					this.dt = dtmax;
				end	
			end

		end 

	end

end

