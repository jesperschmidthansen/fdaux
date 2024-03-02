##
## Solution from note by Matthew J. Hancock
##


clear;  addpath("../src/");

function phi = solution(t, lx, ly, nterms, ngrid)

  x = linspace(0, lx, ngrid);
  y = linspace(0, ly, ngrid);

  [X,Y] = meshgrid(x,y);

  phi = zeros(ngrid, ngrid);
  for n=1:nterms
    for m=1:nterms
      a = 1600/((2*n-1)*(2*m-1)*pi^2);
      b = sin((2*n-1)*pi/lx.*X).*sin((2*m-1)*pi/(2*ly).*Y);
      c = exp(-( (2*m-1)^2/(4*ly^2) + (2*n-1)^2/lx^2 ).*pi*pi*t);
      phi += a*c*b;
    endfor
  endfor

endfunction

##############################################


compare = true;

lx  = 5; ly  = lx;
ngx = 50; ngy = ngx;

dx = lx/ngx; dy = ly/ngy;

a = fdQuant2d([ngx, ngy], [dx, dy], "ddnd"); 

a.setvalue(100);

dt = 0.1*dx*dx;

intgr = fdEuler2d(dt);

tic
for n=1:5000
  	a.calcd2dx2(); a.calcd2dy2();
	a.rhs = a.d2dx2 + a.d2dy2;
	
	intgr.step(a);
	a.applybcs();
end
toc


if compare

	phiSol = solution(n*dt, lx, ly, 10, ngx);
	
	x = linspace(0, lx, ngx); y = x;
	[X Y]= meshgrid(x,y);

	figure(1);
	subplot(2,1,1);
	surf(X,Y, a.value); xlabel('x'); ylabel('y'); zlabel('Num. solution');
	
	subplot(2,1,2);
	surf(X,Y, phiSol); xlabel('x'); ylabel('y'); zlabel('Analytical solution');

	figure(2);
	plot(a.value(
B
endif
