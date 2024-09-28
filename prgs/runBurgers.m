
addpath("../src/mfiles");
addpath("../src/cppfiles");


function cretval = rhs(time, cvar, prefac)

	u = cvar{1};
	du = -u.value.*u.grad('forward') + prefac*u.laplace();
	cretval = {du};

end

function u = solution(x, t, nu)

	tfac = exp(-nu*pi^2*t);
	u = 2*pi*nu.*tfac*sin(pi.*x)./(2+tfac*cos(pi.*x));

end

# Parameters
ngrid = 50; dx=1./ngrid; 
dt = 8e-4;  nloops = 1e3;
nu = 0.05;

# Quantities
u_Euler = fdQuant1d(ngrid, dx, "dd");
u_Adams = fdQuant1d(ngrid, dx, "dd");
u_RK2 = fdQuant1d(ngrid, dx, "dd");
u_RK4 = fdQuant1d(ngrid, dx, "dd");

# Spatial coordinate
x = linspace(0, 1, ngrid);

# Initial conditions
u_Euler.value = u_Adams.value = u_RK2.value = u_RK4.value = initu = 2*pi*nu*sin(pi*x)./(2+cos(pi.*x));

# Integrators
intgrEuler = fdEuler(dt); intgrAdams = fdAdams(dt); intgrRK2 = fdRK2(dt); intgrRK4 = fdRK4(dt);


for n=1:nloops

	intgrEuler.cstep("rhs", {u_Euler}, nu); u_Euler.value(1) = 0; u_Euler.value(end)=0;
	intgrAdams.cstep("rhs", {u_Adams}, nu);	u_Adams.value(1) = 0; u_Adams.value(end)=0;
	intgrRK2.cstep("rhs", {u_RK2}, nu);	u_RK2.value(1) = 0; u_RK2.value(end)=0;
	intgrRK4.cstep("rhs", {u_RK4}, nu);	u_RK4.value(1) = 0; u_RK4.value(end)=0;

end	

# Analytical solution
asol = solution(x, intgrEuler.tnow, nu);

# Plots
figure(1);
plot(x, initu, '--;u(x,0);', ...
	x(1:5:end), u_Euler.value(1:5:end), 'o;Euler;', ...
	x(1:5:end),u_Adams.value(1:5:end), 's;Adams;', ...
	x(1:5:end), u_RK2.value(1:5:end), '*;RK2;', ...
	x(1:5:end), u_RK4.value(1:5:end), 'v;RK4;', ...
	x, asol, ";Analytical;");
xlabel('x'); ylabel('value');

figure(2);
plot(x, u_Euler.value - asol, 'o-;Err Euler;', 
	x, u_Adams.value - asol, 's-;Err Adams;', ...
	x, u_RK2.value - asol, '*-;Err RK2;', ...
	x, u_RK4.value - asol, 'v-;Err RK4;');
xlabel('x'); ylabel('error');

