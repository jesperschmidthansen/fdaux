
classdef fdIntegrator < handle

	properties
		# Time step and current time
		dt; tnow;

		# No. of iteration performed
		niterations;
		
		# Calls to be perfored within same loop
		# and call counter
		ncall; ccall; 
	end

	methods

		function disp(this)
			printf("Time step %e, current time %f and iteration number %d\n", ...
					this.dt, this.tnow, this.niterations);
			printf("Call in this loop %d of no. of calls %d\n", this.ccall, this.ncall);
		end		

		function update(this)
			this.ccall = this.ccall + 1;
			if this.ccall == this.ncall
				this.ccall = 0;
				this.niterations = this.niterations + 1;
				this.tnow = this.dt + this.tnow;
			end	 	
		end

	end

end

