clear all; addpath("../src/");


function dadt = rhsa(time, funvar)
	
	a = funvar{1}; b = funvar{2}; alpha = funvar{3};
	
	reaction = a.value - a.value.^3 - b.value + alpha;

	dadt = reaction + a.laplace();
end

function dbdt = rhsb(time, funvar)
	
	a = funvar{1}; b = funvar{2};
	beta = funvar{3}; diffcoef = funvar{4};

	reaction = beta.*(a.value - b.value);

	dbdt = reaction + diffcoef.*b.laplace();

end

lbox = 100; ngrd = 100; dx =lbox/ngrd; dt = 0.1*dx^2/100.0; nloops = 1e4;
alpha = 0.01; beta = 0.5; diffcoef = 100;

a = fdQuant2d([ngrd, ngrd],[dx, dx], "nnnn"); 
b = fdQuant2d([ngrd, ngrd],[dx, dx], "nnnn"); 

a.value = 0.2*(rand(ngrd)-0.5) + alpha^(1/3);
b.value = 0.2*(rand(ngrd)-0.5) + alpha^(1/3);

intgr = fdAdams2d(dt, 2);

for n=1:nloops
	
	a = intgr.fstep(a, "rhsa", {a,b, alpha});
	b = intgr.fstep(b, "rhsb", {a,b, beta, diffcoef});

	a.update(); b.update();

	if rem(n,100)==0
		imagesc(a.value);
		pause(0.01);
	end

end




