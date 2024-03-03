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

$u$ is some quantity we seek the solution for. In fdaux $u$ is an object type <code>fdQuant1d</code> - that is, a one dimensional quantity. The function that defines the rhs of the dynamical equation, ie. $\mathbf{F}$, must be on the form 

<pre>
<code>
  function retval = rhs(time, quantities, parameters)
</code>
</pre>
where 
<ul>
  <li><code>time</code> is the current time (scalar)</li>
  <li><code>qunatities</code>code> is a cell list of quantities on which $\mathbf{F}$ depends </li>
  <li><code>parameters</code> is the problem parameters (scalar or vector)</li>
  <li><code>retval</code> is a cell list with matrices (with the values for the derivatives for each quantity)</li>
</ul>
For the Burgers equation this translates to 
<pre>
<code>
  function cretval = burgers(timenow, cquantity, nu)
    # cquantity is the cell list with relevant quantities - here u
    u = cquantity{1};
    # The derivative 
    du = -u.value.*u.grad('forward') + nu*u.laplace();
    # Return as a cell list
    cretval = {du};
  end  
</code>
</pre>
Notice: <code>u</code> is an instance of object of type <code>fdQuant1d</code>. This has a member <code>value</code> which is simply the value of the quantity. Also, the object has methods <code>grad</code> and <code>laplace</code> that evaluates the gradient and Laplacian using the current value.

