# Mathematical treatment 

We are interested in the evolution trough time $t$ of a scalar field $\Phi$ defined on the sphere. We take $\phi$ to be smooth and therefore fully specified in a spherical coordinate chart $\theta, \phi$ (the zero measure subset of the sphere not reached by this coordinate chart can be described by a smooth extension of the function defined on the coordinate chart). The PDE giving the evolution of $\Phi$ is the wave equation $\partial_t^2 \Phi = \Delta \Phi$ where $\Delta$ is the Laplace operator on the sphere. To solve it, we decompose $\Phi$ in the basis of spherical harmonics $Y_l^{m}(\theta, \phi)$ defined by 
$$
-i\frac{\partial}{\partial \phi} Y_l^{m}(\theta, \phi) = m  Y_l^{m}(\theta, \phi), \quad \Delta Y_l^{m}(\theta, \phi) = -l(l+1) Y_l^{m}(\theta, \phi)
$$
with $m \in \{-l, \cdots, +l\}$ and $l \in \mathbb{N}$. 
The decomposition reads 
$$
\Phi = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} c^{lm}(t) Y_l^{m}(\theta, \phi).
$$
and the time dependance is fully contained in $c^{lm}$ by separation of variables. Since the coefficients $c^{lm}$ can specify any smooth $\phi, \theta$ dependence, their time dependence contains every evolution of the field. Making use of the linearity of the Laplace operator, we can act it on the expansion of $\Phi$ as follows
$$
\Delta \Phi = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} c^{lm}(t) \Delta Y_l^{m}(\theta, \phi) = -\sum_{l=0}^{\infty} \sum_{m=-l}^{l} c^{lm}(t) l(l+1) Y_l^{m}(\theta, \phi).
$$
Using the linearity of the time derivative, we can express the left-hand side of our wave equation as
$$
\frac{\partial^2 \Phi}{\partial t^2}  = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} \frac{\partial^2 c^{lm}(t)}{\partial t^2} Y_l^{m}(\theta, \phi).  
$$
Since the spherical harmonics form a basis on the space of fields on the spherical coordinate chart, the vanishing of $\partial_t^2 \Phi - \Delta \Phi$ implies (by linear independence) that all coefficients of spherical harmonics must vanish. This gives us the set of equations 
$$
\frac{\partial^2 c^{lm}(t)}{\partial t^2} = -l(l+1) c^{lm}(t).  
$$
This is the differential for a harmonic oscillator and has the general solution $c^{lm}(t) = \alpha^{lm} \cos(\sqrt{l(l+1)} t) + \beta^{lm} \sin(\sqrt{l(l+1)} t)$. We aim to find the solution to the Laplace equation with the initial condition:
$$
\begin{cases}
\Phi(0, \phi, \theta) = f(\phi, \theta),\\
\frac{\partial \Phi}{\partial t} = g(\phi, \theta).
\end{cases}
$$
To solve this initial value problem, we first decompose $f, g$ in the basis of spherical harmonics to get 
$$
f = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} f^{lm} Y_l^{m}(\theta, \phi), \quad g = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} g^{lm} Y_l^{m}(\theta, \phi).
$$
Then we extract the coefficients in these decompositions with the orthogonality property of spherical harmonics. We have the relation
$$
\int_0^\pi \text{d}\theta \ \int_0^{2\pi} \ \text{d}\phi \sin(\theta) \  Y_l^{m}(\theta, \phi) Y_{l'}^{m'}(\theta, \phi)  = \delta_{ll'}\delta_{mm'} 
$$
and we use it to write (commuting the sums and integrals)
$$
\begin{align*}
\int_0^\pi \text{d}\theta \ \int_0^{2\pi} \text{d}\phi \ \sin(\theta) \ Y_{l'}^{m'}(\theta, \phi) \begin{cases}f\\ g\end{cases} &= \sum_{l=0}^{\infty} \sum_{m=-l}^{l} \begin{cases}f^{lm}\\ g^{lm}\end{cases} \int_0^\pi \text{d}\theta \ \int_0^{2\pi}  \text{d}\phi \ \sin(\theta) \ Y_{l'}^{m'}(\theta, \phi) Y_l^{m}(\theta, \phi)\\
& = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} \begin{cases}f^{lm}\\ g^{lm}\end{cases} \delta_{ll'}\delta_{mm'} = \begin{cases}f^{l'm'}\\ g^{l'm'}\end{cases}.
\end{align*}
$$
The next step is to relate the $f$ and $g$ coefficients to $\alpha^{lm}$ and $\beta^{lm}$. Starting from $c^{lm}(0) = f^{lm}$ and $\frac{\partial c^{lm}}{\partial t} (0) = g^{lm}$, we have $\alpha^{lm} = f^{lm}$ and $\sqrt{l(l+1)} \beta^{lm} = g^{lm}$ leading to the solution expansion 
$$
\Phi = \sum_{l=0}^{\infty} \sum_{m=-l}^{l} \left(f^{lm}\cos(\sqrt{l(l+1)}t) + \frac{g^{lm}}{\sqrt{l(l+1)}} \sin(\sqrt{l(l+1)}t)\right)Y_l^{m}(\theta, \phi)
$$
To numerically implement this solution we need to find $f^{lm}$ and $g^{lm}$, integrate the harmonic oscillator (we showed the exact solution here, but numerically we use an ODE solver), and sum the solution up to a cutoff $l_{\text{max}}$. The coefficients are stored in one-dimensional arrays of length
$$
L = \sum_{l=0}^{l_\text{max}} \sum_{m=-l}^{l}1 = \sum_{l=0}^{l_\text{max}} (2 l + 1) = 2\frac{l_\text{max} (l_\text{max} + 1)}{2} + l_\text{max} + 1 = (l_\text{max} + 1)^2.
$$
Form the results of the simulation, we see that the $l_\text{max} = 4$ truncation fails to represent the solution of the equation, but that we converge to a solution for higher $l_\text{max}$ values (we tested $l_\text{max} = 4$). A key indicator that the $l_\text{max} = 4$ simulation has not converged is the fact it does not respect the symmetry of the initial condition (rotation around the vertical axis).

Note: The output of the simulations are surfaces created by associated $\Phi + \text{cste}$ to the radius value on a spherical parametrization.