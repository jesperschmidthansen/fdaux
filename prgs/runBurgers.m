clear all;

function du = rhs(time, funvar)
	
	u=funvar{1}; prefac = funvar{2};

	du = -u.value.*u.calcddx('forward') + prefac.*u.laplace();
end

function u = solution(x, t)

	tfac = exp(-pi^2*t);
	u = 2*pi.*tfac*sin(pi.*x)./(2+tfac*cos(pi.*x));

end


ngrid = 100; dx=1./ngrid; 
dt = 1e-5;  nloops = 1e4;

u = fdQuant1d(ngrid, dx, "dd");

x = linspace(0, 1, ngrid);

u.value = initu = 2*pi.*sin(pi*x)./(2+cos(pi.*x));

intgr = fdEuler(dt);

for n=1:nloops

	u = intgr.fstep(u, "rhs", {u, 1.0});
	
	u.update();
	u.value(1) = 0; u.value(end)=0;

end	

asol = solution(x, intgr.tnow);

subplot(2,1,1);
plot(x, initu, '--;u(x,0);', x(1:5:end), u.value(1:5:end), 'o;Num.;', x, asol, ";Analytical;");

subplot(2,1,2);
plot(x, u.value-asol);

