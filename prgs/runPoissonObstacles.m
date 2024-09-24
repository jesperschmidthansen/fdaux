# 
# Poisson problem with obstacles
#

clear all

addpath("../src/mfiles");
addpath("../src/cppfiles");


lx  = 5; ly  = lx;
ngx = 100; ngy = ngx;
dx = lx/ngx; dy = ly/ngy;

u = zeros(ngy, ngx); 
force = 0.05*ones(ngy, ngx);

c_idx = zeros(ngx, ngx); c_idx(45:55, 45:55)=1; c_idx(20:30, 20:30)=1;
c_val = zeros(ngx, ngx);

for n=1:10
	[u, niter, status] = ofdsor(u, -force, [dx dy], 1.5, 1e-8, c_idx, c_val);
	printf("%d\n", niter);
end

surf(u)

