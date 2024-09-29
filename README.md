<h2>Introduction</h2>

The purpose of fdaux is to provide a set of functionalities for finite difference methods 
that can help you to solve partial differential equations (pdes). Currently, only one and two 
dimensional Cartesian systems are supported. In general, the pde must be on the form  

$$
  \partial_t \boldsymbol{\phi}(\mathbf{r},t) = \mathbf{F}(t,\boldsymbol{\phi}; \mathbf{p}) 
$$

where $\mathbf{r}$ is the spatial coordinate, $t$ the time, 
$\boldsymbol{\phi}(\mathbf{r},t) = (\phi_1(\mathbf{r},t) , \phi_2(\mathbf{r},t) , \ldots)$, 
and $\mathbf{p}$ a set of parameters. For example, the diffusion equation 
in two dimensions can be written on this form

$$
\partial_t a = D \left( \partial_x^2 + \partial^2_y\right) a  
$$

Comparing with the general form we identify $\phi=a$ and $p=D$. 

Next, consider the Burgers equation in one dimension

$$
\partial_t u = -u\partial_xu + \nu \partial_x^2 u 
$$

In fdaux the function $u$ is a variable (or quantity) which is specified through 
the object type <code>fdQuant1d</code>. Using fdaux to solve the Burgers equation 
we must provide the right-hand side of the equation using an Octave function. In 
general, this is on the form
<pre>
<code>
  function retval = rhs(time, quantities, parameters)
</code>
</pre>
where 
<ul>
  <li><code>time</code> is the current time (scalar)</li>
  <li><code>quantities</code> is a cell list of quantities on which $\mathbf{F}$ depends </li>
  <li><code>parameters</code> is a vector of problem parameters </li>
  <li><code>retval</code> is a cell list containing the values for the derivatives for each quantity at each point</li>
</ul>
For the Burgers equation this translates to 

```matlab
    function cretval = burgers(timenow, cquantity, nu)
        u = cquantity{1};

        du = -u.value .* u.grad('forward') + nu * u.laplace();

        cretval = {du};
    end  
``` 

Note: <code>u</code> is an instance of object of type <code>fdQuant1d</code>. This has a 
member <code>value</code> which is simply the value of the quantity. Also, the object has 
methods <code>grad</code> and <code>laplace</code> that evaluates the 
gradient and Laplacian.

Below the Burgers equation is solved numerically using the Adams integrator 
and homogenous Dirichlet boundary conditions 
<pre>
<code>
ngrid = 50; dx=1./ngrid; x = linspace(0,1,ngrid);
dt = 5e-4;  nloops = 1e4;
nu = 0.05;

u = fdQuant1d(ngrid, dx, "dd");
u.value = 2 * pi * nu * sin(pi*x)./(2+cos(pi.*x));

intgr = fdAdams(dt);

for n=1:nloops
    intgr.cstep("burgers", {u}, nu);
end

plot(x, u.value, 's-');
</code>
</pre>
Currently you can choose Euler, Adams, and Runge-Kutta 2nd and 4th order.


