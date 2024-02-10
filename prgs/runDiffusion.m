
clear all;  addpath("../src/");

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


function dadt = rhs(time, funvar)

	a = funvar{1};
	diffcoef = funvar{2};
 
	dadt = diffcoef.*a.laplace();

end 

lx  = 5; ly  = lx;
ngx = 50; ngy = ngx;
dx = lx/ngx; dy = ly/ngy;

tend = 1.0; dt = 0.1*dx*dx; 
nloops = int32(tend/dt);

compare = true;

a = fdQuant2d([ngx, ngy], [dx, dy], "ddnd"); 
a.setvalue(100);

intgr = fdAdams2d(dt);

tic
for n=1:nloops
	a = intgr.fstep(a, "rhs", {a, 1.0});
	a.update();
end
toc

surf(a.value); xlabel('x'); ylabel('y'); zlabel('Num. solution');

if compare

	phiSol = solution(tend, lx, ly, 10, ngx);
	
	x = linspace(0, lx, ngx); y = x;
	[X Y]= meshgrid(x,y);

	figure(1);
	subplot(2,1,1);
	surf(X,Y, a.value); xlabel('x'); ylabel('y'); zlabel('Num. solution');
	
	subplot(2,1,2);
	surf(X,Y, phiSol); xlabel('x'); ylabel('y'); zlabel('Analytical solution');

	figure(2);
	plot(a.value(ngx/2, :), 'ks', phiSol(ngx/2,:), 'b-');

	printf("Max. error %f\n", max(max(abs(phiSol - a.value))));

endif
