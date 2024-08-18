#
# Usage: [psi, u, v] = fdsuv2d(w, bcs, sorfac, error)
#
# Calculate the stream function and velocity field from the vorticity.  
#
# input
# w: The vorticity field
# bcs: Boundary conditions. Valid values are 'p' (periodic) or 'd' (zero Dirichelt). Default is 'p'
# sorfac: Factor for the SOR algorithm. Value between 1 and 2 - default is 1.5. Ignored for bcs='p'
# error: Maximum allowed error for the SOR algorithm. Default 1e-5. Ignored for bcs='p'   
#
# output
# pst: Stream function
# u: Velocity x-component
# v: velocity y-component
#
# example
# [psi, u, v] = fdsuv2d(w, 'd', 1.75, 1.0e-6);
#
function [psi, u, v] = fdsuv2d(w, bc='p', sorfac=1.5, _error=1.0e-5)
		
	ngrdx = w.ngrdx; ngrdy = w.ngrdy;
	dx = w.dx; dy = w.dy;
   
	if nargin > 4 
		error("Number of input arguments cannot exceed 4");
	end
	
	if bc=='p'
		bcs = "pppp";
	elseif bc=='d';
		bcs = "dddd";
	else
		error("Boundary condition can only be 'p' or 'd'");
	end

	u = fdQuant2d([ngrdx, ngrdy], [dx, dy], bcs); 
	v = fdQuant2d([ngrdx, ngrdy], [dx, dy], bcs); 
	psi = fdQuant2d([ngrdx, ngrdy], [dx, dy], bcs); 

	if bc=='p'
		psi.value = fdspec2d(-w.value, ngrdx, dx);
	else 
		psi.value = fdsor2d(psi.value, -w.value, [dx, dy], sorfac, _error);
	end

	psi.calcddx(); psi.calcddy(); 
	u.value = psi.ddy; v.value = -psi.ddx; 
	
end
