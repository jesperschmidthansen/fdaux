clear all;  

addpath("../src/mfiles");
addpath("../src/cppfiles");


ngrd = 100; dx = 0.1; dt = 5e-3;

w = fdQuant2d([ngrd, ngrd],[dx, dx], "pppp"); 
intgr = fdAdams(dt);

#### Initial condition ####
h = 0.5*ngrd*dx; 
x = linspace(-h, h); [X Y] = meshgrid(x,x);
x1 = -1.0; x2 = 1.0; sigma = 10;
w1 = exp(-sigma*(X-x1).^2 - sigma*Y.^2);
w2 = exp(-sigma*(X-x2).^2 - sigma*Y.^2);
w.value  = w1 + w2;
wm  = sum(sum(w.value)); fac = 2./(dx^2)/wm; w.value = w.value*fac;

# NOTICE: The total production term (rhs) must be zero to have a well defined problem in periodic systems
wm  = sum(sum(w.value))/(ngrd*ngrd); w.value   = w.value - wm;

for n=1:20000
		
	[psi u v] = fdsuv2d(w);
	w = intgr.fstep(w, "fdvteq2d", {w, psi, u, v, 1/1000.0});

	w.update();

	if rem(n,100) == 0
		contour(w.value);
		pause(0.01);
	endif 
		
endfor

printf("\n");


