#
# Usage: co = fdcourant(dt, u, v)
# 
# Calculates the Courant number 
#
# input
# dt: Current integrator time step
# u : Velocity field x-direction (Object of fdQuant2d or fdQuant1d)
# v : Velccity field y-direction (Object of fdQuant2d - optional)
#
# example
# courant = fdcourant(dtnow, u, v); 
#

function co = fdcourant(dt, u, v)

	if nargin==2
		mindx = min([u.dx, u.dy]); 
		maxu = max(max(abs(u.value)));
	elseif nargin==3
		mindx = min([min([u.dx, u.dy]), min([v.dx, v.dy])]);
		maxu = max([max(max(abs(u.value))), max(max(abs(v.value)))]); 
	end
		
	co = dt*maxu/mindx;
end


