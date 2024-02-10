
classdef fdQuantity < handle

	properties
		# quantity value
		value; 

		# quantity values for integrator: 
		# new value, previous value, right-hand side, prev. right-hand side
		nvalue; pvalue; rhs; prhs; 
		
		# Boundary values
		bcs;
	end

	methods

		function disp(this)
			printf("You can access class properties directly, e.g. this.value\n"); 
		end

	end


end
