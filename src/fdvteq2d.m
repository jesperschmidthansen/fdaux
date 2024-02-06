# 
# Vorticity transport equation
#
function [dwdt psi u v] = fdvteq2d(time, funvar)

	w = funvar{1}; psi = funvar{2};
	u=funvar{3}; v=funvar{4}; 
	visc = funvar{5};
	
	w.calcddx(); w.calcddy(); 
	dwdt = -u.value.*w.ddx - v.value.*w.ddy + visc*w.laplace();
	
end


