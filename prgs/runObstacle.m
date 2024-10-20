##
## Solution from note by Matthew J. Hancock
##

addpath("../src/mfiles");
addpath("../src/cppfiles");
#{
function value = correct(value,xcor, ycor)

	[ngy ngx] = size(value);
	
	value(ycor(1):ycor(2), xcor(1):xcor(2)) = 0;

	value(ycor(1):ycor(2), xcor(1)-1) = value(ycor(1):ycor(2), xcor(1)-2);
	value(ycor(1):ycor(2), xcor(2)+1) = value(ycor(1):ycor(2), xcor(2)+2);

	value(ycor(1)-1,xcor(1):xcor(2))=value(ycor(1)-2,xcor(1):xcor(2));
	value(ycor(2)+1,xcor(1):xcor(2))=value(ycor(2)+2,xcor(1):xcor(2));

end
#}

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

obstacles = fdObstacle2d([ngx, ngy]);
obstacles.value(20:80, 70:80) = true;

for n=1:5000

	intgr.cstep("rhs", {a}, 1.0);
	a.applybcs();
	a.value(:, end)=100;
	
	a.value = obstacles.correct(a.value);


	if rem(n, 100)==0 
		mesh(a.value);
		axis([0 100 0 100 0 100]);
		pause(0.01);
	end

end


