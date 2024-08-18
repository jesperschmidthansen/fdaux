clear all; addpath("../src/");

function creturn = rhs(time, cvariable, param)
	
	a = cvariable{1}; b = cvariable{2};
	alpha = param(1); beta = param(2); diffcoef = param(3);

	reaction1 = a.value - a.value.^3 - b.value + alpha;
	reaction2 = beta.*(a.value - b.value);

	dadt = reaction1 + a.laplace();
	dbdt = reaction2 + diffcoef.*b.laplace();

	creturn = {dadt, dbdt};

end


lbox = 100; ngrd = 100; dx =lbox/ngrd; dt = 0.1*dx^2/100.0; nloops = 1e0;
alpha = 0.01; beta = 0.5; diffcoef = 100;

a = fdQuant2d([ngrd, ngrd],[dx, dx], "nnnn"); 
b = fdQuant2d([ngrd, ngrd],[dx, dx], "nnnn"); 

a.value = 0.2*(rand(ngrd)-0.5) + alpha^(1/3);
b.value = 0.2*(rand(ngrd)-0.5) + alpha^(1/3);

intgr = fdEuler(dt, 2);

for n=1:nloops
	
	intgr.cstep({a, b}, [alpha, beta, diffcoef], "rhs")

	if rem(n,100)==0
		imagesc(a.value);
		pause(0.01);
	end

end




