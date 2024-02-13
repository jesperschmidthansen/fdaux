clear all;

function dphi = rhs(time, funvar)
	
	phi = funvar{1}; u=funvar{2}; prefac = funvar{3};

	dphi = -u.*phi.calcddx() + prefac.*phi.calcd2dx2();

end

ngrid = 100; dx=0.01; 
dt = 1e-5;  nloops = 1e4;

phi = fdQuant1d(ngrid, dx, "dd");

intgr = fdAdams(dt);

for n=1:nloops

	phi = intgr.fstep(phi, "rhs", {phi, 1.0, 0.1});
	
	phi.update();
	phi.value(1) = 0; phi.value(end)=1;

end	

