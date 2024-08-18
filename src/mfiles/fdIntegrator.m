
classdef fdIntegrator < handle

	properties
		# Time step, maximum allowed time step, and current time
		dt; dtmax, tnow;

		# System dimensions
		ndim;		

		# No. of iteration performed
		niterations;
		
		# Calls to be perfored within same loop and call counter
		ncall; ccall; 
	end

	methods

		function disp(this)
			printf("Time step: %e, current time: %f, iteration number: %d\n", ...
					this.dt, this.tnow, this.niterations);
			printf("Call in this loop is %d of no. of calls per loop %d\n", this.ccall, this.ncall);
		end		

		function update(this)

			this.ccall = this.ccall + 1;
			
			if this.ccall == this.ncall
				this.ccall = 0; 
				this.niterations = this.niterations + 1;
				this.tnow = this.dt + this.tnow;
			end	 	

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
			endif

		endfunction 

	end

end

