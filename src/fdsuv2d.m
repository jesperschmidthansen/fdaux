#
# Calculate the stream function and velocity fields from the vorticity
#
function [psi, u, v] = fdsuv2d(w, bc='p', sorfac=1.5, _error=1.0e-5)
		
	ngrdx = w.ngrdx; ngrdy = w.ngrdy;
	dx = w.dx; dy = w.dy;
   
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
