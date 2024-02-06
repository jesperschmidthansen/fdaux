
function dwdt = fdpveq2d(time, funvar)

	w = funvar{1}; 
	visc = funvar{2};	
	sorfac = funvar{3};
	_err = funvar{4};	

	ngrdx = w.ngrdx; ngrdy = w.ngrdy;
	dx = w.dx; dy = w.dy;

	u = fdQuant2d([ngrdx, ngrdy], [dx, dy], "dddd"); 
	v = fdQuant2d([ngrdx, ngrdy], [dx, dy], "dddd"); 
	psi = fdQuant2d([ngrdx, ngrdy], [dx, dy], "dddd"); 

	psi.value = fdsor2d(phi.value, -w.value, [dx, dy], sorfac, _err);

	psi.calcddx(); psi.calcddy(); 
	u.value = psi.ddy; v.value = -psi.ddx; 

	w.calcddx(); w.calcddy(); 
	dwdt = -u.value.*w.ddx - v.value.*w.ddy + visc*w.laplace();
	
end


