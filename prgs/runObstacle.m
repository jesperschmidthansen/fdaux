##
## Solution from note by Matthew J. Hancock
##


clear;  addpath("../src/");

function value = correct(value,xcor, ycor)

	[ngy ngx] = size(value);
	
	value(ycor(1):ycor(2), xcor(1):xcor(2)) = 0;

	value(ycor(1):ycor(2), xcor(1)-1) = value(ycor(1):ycor(2), xcor(1)-2);
	value(ycor(1):ycor(2), xcor(2)+1) = value(ycor(1):ycor(2), xcor(2)+2);

	value(ycor(1)-1,xcor(1):xcor(2))=value(ycor(1)-2,xcor(1):xcor(2));
	value(ycor(2)+1,xcor(1):xcor(2))=value(ycor(2)+2,xcor(1):xcor(2));

end

function dadt = rhs(time, a, diffcoef)
	
	dadt = {diffcoef*a{1}.laplace()};

end

##############################################


lx  = 5; ly  = lx;
ngx = 100; ngy = ngx;
dx = lx/ngx; dy = ly/ngy;
dt = 0.1*dx*dx;

a = fdQuant2d([ngx, ngy], [dx, dy], "dddd"); 
a.setvalue(100);

intgr = fdEuler(dt);

obstacle1 = fdObstacle2d([40, 60], [20,40]);
obstacle2 = fdObstacle2d([40, 60], [60,80]);

for n=1:50000
	intgr.cstep({a}, 1.0, "rhs");
	a.applybcs();
	a.value(:, end)=100;
	
	a.value = obstacle1.correct(a.value);
	a.value = obstacle2.correct(a.value);


	if rem(n, 100)==0 
		mesh(a.value);
		axis([0 100 0 100 0 100]);
		pause(0.01);
	end

end


