
addpath("../src/cppfiles/");
addpath("../src/mfiles/");

function w=gvort(ux, uy)

	duxdy = fdcds2d(ux, 1, 'y');
	duydx = fdcds2d(uy, 1, 'x');

	w = duydx - duxdy;
end

F0 = 1.5;
ngrdx = 800; ngrdy = 100;
nloops = 2000 ;

obstacle_type = "cylinder";

f = fdQuant2d();
f.lbset([ngrdx, ngrdy]); 

# Advective flow in the x-direction
f.value(:,:,4) = f.value(:,:,4) + F0; 

# Normalizing with density
rho = sum(f.value,3);
f.value(:,:,[1:1:9]) = f.value(:,:,[1:1:9])./rho;

# Def. of cylinder (1 cylinder grid, 0 not)
obstacle = zeros(ngrdy, ngrdx);

if strcmp(obstacle_type, "cylinder")
	[X, Y] = meshgrid([1:1:ngrdx], [1:1:ngrdy]);
	obstacle = (X - ngrdx/4).^2 + (Y - ngrdy/2).^2 < (ngrdy/4).^2;
elseif strcmp(obstacle_type, "squares")
	obstacle(40:60,40:60) = 1;
	obstacle(20:40, 200:260)=1;
	obstacle(60:80, 120:160)=1;
	obstacle(40:60, 300:360)=1;
elseif strcmp(obstacle_type, "poiseuille")
	obstacle(1:5,:)=1; obstacle(end-5:end,:)=1;
end

# Integrator
intgr = fdlb();

# Simulation Main Loop
for n=1:nloops
	
    [ux, uy, rho] = intgr.step(f, obstacle);
	
	if rem(n, 20)==0
		ux_red = ux(1:4:end, 1:10:end);
		uy_red = uy(1:4:end, 1:10:end);
		x = linspace(1, ngrdx, columns(ux_red));
		y = linspace(1, ngrdy, rows(ux_red));
		vorticity = gvort(ux, uy);
		
		colormap('hsv'); 
		imagesc(vorticity, [-0.05, 0.05]);
		colorbar;
		axis([1 ngrdx 1 ngrdy]);
		[X, Y] = meshgrid(x,y);
		hold on;
		quiver(X, Y, ux_red, uy_red);
	
		hold off
		pause(0.001);
	end
	
end 


