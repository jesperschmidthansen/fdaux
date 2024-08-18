
#
# Usage dwdt = fdveq2d(time now, cell array)
#
# Right-hand side of the two dimensional vorticity equation 
#
# input 
# time now: the current time
# cell array: A cell array with five elements 
#            {vorticity field, stream function, u field, v field, viscosity} 
#            
# output
# dwdt: Derivative of vorticity field           
#
# exampe
# dwdt = fdvteq2d(time, {w, psi, u, v, 1.0});
#
function dwdt  = fdvteq2d(time, funvar)

	if nargin!=2
		error("Number of inputs must be 2"); 	
	end
	if length(funvar)!=5
		error("Length of cell array input argument must be 5");
	end	
	
	w = funvar{1}; psi = funvar{2};
	u=funvar{3}; v=funvar{4}; 
	visc = funvar{5};
	
	w.calcddx(); w.calcddy(); 
	dwdt = -u.value.*w.ddx - v.value.*w.ddy + visc*w.laplace();
	
end


