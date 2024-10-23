# 
# Poisson problem 
#
#  d²u/dx² + d²u/dy² = w 
#
addpath("../src/mfiles/");
addpath("../src/cppfiles/");


lx  = 5; ly  = lx;
ngx = 100; ngy = ngx;
dx = lx/ngx; dy = ly/ngy;

u = zeros(ngy, ngx); 
w = 0.1*ones(ngy, ngx);

relxfac = 1.5; err = 1e-7;
for n=1:5
	[u status] = fdpois2d(w, [dy, dx], "sor", {u, relxfac, err});
end

plot(u(50, :), "-o;SOR;");
[u status] = fdpois2d(w, [dy dx], "direct");

hold on;
plot(u(50,:)-0.1, "-s;Direct;");
hold off

