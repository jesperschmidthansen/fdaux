
#
# Usage dwdt = fdveq2d(time now, variable cell array, nu0)
#
# Right-hand side of the two dimensional vorticity equation 
#
# input 
# time now: the current time
# cell array: A cell array with five elements 
#            {vorticity field, u field, v field} 
# nu0: The kinetimatic viscosity
#
# output
# dwdt: Derivative of vorticity field           
#
# exampe
# dwdt = fdvteq2d(time, {w, u, v}, 1.0);
#
function dwdt  = fdvteq2d(time, cvar, nu0)

	if nargin!=3
		error("Number of inputs must be 3"); 	
	end
	if length(cvar)!=3
		error("Length of cell array input argument must be 5");
	end	
	
	w = cvar{1}; u=cvar{2}; v=cvar{3}; 
	
	w.calcddx(); w.calcddy(); 

	dwdt = {-u.value.*w.ddx - v.value.*w.ddy + nu0*w.laplace()};		
end


