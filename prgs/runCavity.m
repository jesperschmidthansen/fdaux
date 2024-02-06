clear all;  addpath("../src/");

ngrd = 100; dx = dy = 0.1;
invRe = 1/500;
dt = 5e-3;
nloops = 1e4;

U1=V2=V4=0;
U3 = 1;

w = fdQuant2d([ngrd, ngrd],[dx, dx], "dddd"); 
psi = zeros(ngrd, ngrd);

## Initial conditions
h = 0.5*ngrd*dx; 
x = linspace(-h, h); [X Y] = meshgrid(x,x);
w.value = ones(ngrd, ngrd);

intgr = fdEuler2d(dt);

for n=1:nloops

	[phi u v] = fdsuv2d(w, 'd');

	# Thom's rule 	
	#wall 1
	w.value(1, :) = 2.0/dy^2*(phi.value(1,:)-phi.value(2,:)) + 2/dy*U1;
	#wall 2
	w.value(:,end) = 2.0/dx^2*(phi.value(:,end) - phi.value(:,end-1)) + 2/dx*V2;
	#wall 3
	w.value(end,:) = 2.0/dy^2*(phi.value(end,:) - phi.value(end-1, :)) - 2.0/dy*U3;
	u.value(end,:) = U3;
	#wall 4
	w.value(:,1) = 2.0/dx^2*(phi.value(:,1)-phi.value(:,2)) - 2/dx*V4;

	w = intgr.fstep(w, "fdvteq2d", {w, phi, u, v, invRe});

	w.update();

	if rem(n,100)==0
		figure(1);
		contour(phi.value, 25);
		hold on
		contour(phi.value, [0:0.0001:0.001], 'r');
		contour(phi.value, [0:0.00001:0.0001], 'g');
		hold off
		pause(0.01);
	end
	
end

