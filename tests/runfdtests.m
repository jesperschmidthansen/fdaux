
clear

addpath("../src/");

# Num. derivatives, Poisson solvers
tests = [false, true];


if tests(1) 
	x = linspace(-1,1,500);
	y = linspace(-2,2, 100);
	[X Y] = meshgrid(x,y);
	Z = X.^2 - Y.^2;
	dx = 2/length(x); dy = 4/length(y);

	## 1st order derivative
	dzdx1 = fdcds2d(Z, dx, 'x');
	dzdy1 = fdcds2d(Z, dy, 'y');

	dzdx2 = fdfrwd2d(Z, dx, 'x');
	dzdy2 = fdfrwd2d(Z, dy, 'y');

	dzdx3 = fdbckwd2d(Z, dx, 'x');
	dzdy3 = fdbckwd2d(Z, dy, 'y');
	
	figure(1);
	subplot(2,1,1);
	plot(x(2:end-1), dzdx1(50, 2:end-1), 'o', 
		x(2:end-1), dzdx2(50, 2:end-1), 's',
		x(2:end-1), dzdx3(50, 2:end-1), '*',
		x, 2*x, '-');
	subplot(2,1,2);
	plot(y(2:end-1), dzdy1(2:end-1, 50), 'o', 
			y(2:end-1), dzdy2(2:end-1, 50), 's', 
			y(2:end-1), dzdy3(2:end-1, 50), '*', 
			y, -2*y, '-');

	## 2nd order derivative
	d2zdx2 = fdscnd2d(Z, dx, 'x');
	d2zdy2 = fdscnd2d(Z, dy, 'y');

	printf("%f %f \n", d2zdx2(10,10), d2zdy2(10,10));
	
endif

if tests(2)
	
	ngx = 25; ngy = 50;
	dx = 2./ngx; dy = 5./ngy;

	x = linspace(0, ngx*dx, ngx);
	y = linspace(0, ngy*dy, ngy);

	phi = zeros(ngy, ngx); 
	Q = zeros(ngy, ngx); Q(2:end-1,2:end-1)=1.0;

	# Succesive overelaxing
	[phiSOR1, niter1, status1]=fdsor2d(phi, Q, [dx dy], 1.75, 1.0e-4);
	[phiSOR2, niter2, status2]=fdsor2d(phi, Q, [dx dy], 1.75, 1.0e-5);
	[phiSOR3, niter3, status3]=fdsor2d(phi, Q, [dx dy], 1.75, 1.0e-6);

	# Direct method
	cmat = fdcmat2d([ngx, ngy], [dx dy]);
	Qvec = fdm2v2d(Q);
	phiDIRvec = cmat\Qvec; 
	phiDIR = fdv2m2d(phiDIRvec, [ngx, ngy]);

	%figure(1); clf;
	rowid = int64(ngy/2);
	plot(x, (phiSOR1(rowid,:)-phiDIR(rowid,:))./phiDIR(rowid,:), "-o;err 1e-4;", ...
		x, (phiSOR2(rowid,:)-phiDIR(rowid,:))./phiDIR(rowid,:), "-s;err 1e-5;", ...
		x, (phiSOR3(rowid,:)-phiDIR(rowid,:))./phiDIR(rowid,:), "-*;err 1e-6;");

	printf("Error level 1: %d %d\n", niter1, status1);
	printf("Error level 2: %d %d\n", niter2, status2);
	printf("Error level 3: %d %d\n", niter3, status3);

endif
