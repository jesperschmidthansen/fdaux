
classdef fdQuantity < handle

	properties
		# quantity value
		value; 

		# quantity values for integrator: 
		# new value, previous value
		nvalue; pvalue; 
		
		# Boundary values
		bcs;

		# Right-hand side of dynamical equation
		rhs; prhs;
	end

	methods

		function disp(this)
			printf("From fdQuantity: you can access class properties directly\n"); 
		end

	end


end
