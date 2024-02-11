using Plots
using SphericalFunctions
#using Pkg


#Pkg.add("Interpolations")

# https://stackoverflow.com/questions/68556256/2d-interpolation-in-julia

#Pkg.add("PlotlyJS")
#default(show=true)


function f(pix)::ComplexF64
    theta, phi = pix
    sigma = pi/4
    return theta^2
end

function g(pix)::ComplexF64
    theta, phi = pix
    return 0.
end

dt = 0.02
lmax = 20

llist = [l*(l+1) for l in 0:lmax for _ in 1:2*l + 1]
T = SSHT(0, lmax)
pix = pixels(T)

fpix = f.(pix)
gpix = g.(pix)

flm = T \ fpix
glm = T \ gpix

Phi = real.(f.(pix))

function evolve(flm, glm, T=T, llist=llist, dt=dt)
    midf = flm + glm * dt/2 
    midg = glm - llist .* flm * dt/2

    next_flm = flm + midg * dt
    next_glm = glm - llist .* midf * dt

    Phi = real.(T * copy(next_flm))
    return next_flm, next_glm, Phi
end 


function sphere_wrap(Phi, pix)
    thetas, phis = first.(pix), last.(pix)
    
    X = (Phi.+1) .* sin.(thetas) .* cos.(phis)
    Y = (Phi.+1) .* sin.(thetas) .* sin.(phis)
    Z = (Phi.+1) .* cos.(thetas)
    
    return X, Y, Z
end


#_, _, Phi = evolve(flm, glm, T, llist, dt)
X, Y, Z = sphere_wrap(Phi, pix)

scatter(
    X, Y, Z,
    showaxis = false,
    grid = false,
    camera=(0,45),
    marker=(:circle,4)
    )

@gif for i=1:1500
    flm, glm, Phi = evolve(flm, glm)
    X, Y, Z = sphere_wrap(Phi, pix)
    push!(plt, X, Y, Z)
#end every 10
