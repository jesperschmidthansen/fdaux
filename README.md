<h2>Introduction</h2>

The purpose of fdaux is to provide a set of functionalties for finite difference methods that can help you to solve (real) partial differential equations. Currently, only one and two dimensional Cartesian systems are supported. 
In general,the equation is on form  

$$
  \partial_t \boldsymbol{\phi}(\mathbf{r},t) = \mathbf{F}(t,\boldsymbol{\phi}; \mathbf{p}) 
$$

where $\mathbf{r}$ is the spatial coordinate vector, $t$ the time, $\boldsymbol{\phi}(\mathbf{r},t) = (\phi_1(\mathbf{r},t) , \phi_2(\mathbf{r},t) , \ldots)$, and $\mathbf{p}$ a set of parameter. For example, the simple diffusion equation 
in two dimensions can be written on this form

$$
\partial_t a = D \left( \partial_x^2 + \partial^2_y\right) a  
$$

Comparing with the general form we identify $\phi=a$ and $p=D$. The user provides the right-hand side (rhs) of the equation.  

<h2>Example I - defining the dynamics </h2>
Consider the Burgers equations in one dimension

$$
\partial_t u = -u\partial_xu + \nu \partial_x^2 u 
$$

$u$ is some quantity we seek the solution for. In fdaux the variable $u$ is a quantity in a one dimensional system which is specified through the object type <code>fdQuant1d</code>. The function that defines the rhs of the dynamical equation must be on the form 

<pre>
<code>
  function retval = rhs(time, quantities, parameters)
</code>
</pre>
where 
<ul>
  <li><code>time</code> is the current time (scalar)</li>
  <li><code>qunatities</code> is a cell list of quantities on which $\mathbf{F}$ depends </li>
  <li><code>parameters</code> is a vector of problem parameters </li>
  <li><code>retval</code> is a cell list containing the values for the derivatives for each quantity at each point</li>
</ul>
For the Burgers equation this translates to 
<pre>
<code>
  function cretval = burgers(timenow, cquantity, nu)
    # cquantity is the cell list of fdQuant1d types - here only u
    u = cquantity{1};
  
    # The derivative - the gradient is calculated using forward differencing
    # and the Laplacian is calculated with the default central difference
    du = -u.value.*u.grad('forward') + nu*u.laplace();
  
    # Return as a cell list
    cretval = {du};
  end  
</code>
</pre>
Note: <code>u</code> is an instance of object of type <code>fdQuant1d</code>. This has a member <code>value</code> which is simply the value of the quantity. Also, the object has methods <code>grad</code> and <code>laplace</code> that evaluates the gradient and Laplacian using the current value.

<h2>Example II - integration </h2>
Below the Burgers equation is solved numerically using the Adams integrator and homogenous Dirichlet boundary conditions 
<pre>
<code>
  # System parameters
  ngrid = 50; dx=1./ngrid; x = linspace(0,1,ngrid);
  dt = 5e-4;  nloops = 1e4;
  nu = 0.05;
  # Instance of fdQuant1d
  u = fdQuant1d(ngrid, dx, "dd");
  u.value = 2 * pi * nu * sin(pi*x)./(2+cos(pi.*x));
  # Integrator
  intgr = fdAdams(dt);

  for n=1:nloops
    intgr.cstep({u}, nu, "burgers");
  end
  
  plot(x, u.value, 's-');
</code>
</pre>


