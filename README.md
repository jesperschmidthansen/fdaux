<h2>Introduction</h2>

The purpose of fdaux is to provide a set of functionalties for finite difference methods that can help you to solve (real) partial differential equations. Currently, only one and two dimensional Cartesian systems are supported. 
In general,the equation is on form  

$$
  \partial_t \boldsymbol{\phi}(\mathbf{r},t) = \mathbf{F}(t,\boldsymbol{\phi}; \mathbf{p}) 
$$

where $\mathbf{r}$ is the spatial coordinate vector, $t$ the time, $\boldsymbol{\phi}(\mathbf{r},t) = (\phi_1(\mathbf{r},t) , \phi_2(\mathbf{r},t) , \ldots)$, and $\mathb{p}$ a set of parameter. For example, the simple diffusion equation 
in two dimensions can be written on this form

$$
\partial_t a = D \left( \partial_x^2 + \partial^2_y)a  
$$

Comparing with the general form we identify $\phi=a$ and $p=D$. The user provides the right-hand side (rhs) of the equation.  

<h2>Example I - defining the dynamics </h2>
Consider the Burgers equations in one dimension

$$
\partial_t u = -u\partial_xu + \nu \partial_x^2 u 
$$

$u$ is some quantity we seek the solution for. In fdaux this is then a object type <code>fdQuant1d</code>

<code>
function cretval = burgers(timenow, cquantity, nu)

  u = cquantity{1};
  du = -u.value.*u.calcddx('forward') + nu*u.laplace();
  cretval = {du};

end  
</code>

