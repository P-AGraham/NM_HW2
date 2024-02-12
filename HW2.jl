using Plots
using SphericalFunctions

dt = 0.025
lmax = 10

llist = [l*(l+1) for l in 0:lmax for _ in 1:2*l + 1]

llist
T = SSHT(0, lmax)

function evolve(flm, glm, T=T, llist=llist, dt=dt)
    midf = flm + glm * dt/2 
    midg = glm - llist .* flm * dt/2

    next_flm = flm + midg * dt
    next_glm = glm - llist .* midf * dt

    return next_flm, next_glm
end 



function sphere_wrap(flm, thetas, phis, N, lmax=lmax)

    X = zeros(N, N)
    Y = zeros(N, N)
    Z = zeros(N, N)

    for i in 1:N
        for j in 1:N
            t, p = thetas[i], phis[j]
            Phi = real(flm'*sYlm_values(t, p, lmax, 0))
            X[i,j] = (Phi) * cos(p) * sin(t)
            Y[i,j] = (Phi) * sin(p) * sin(t)
            Z[i,j] = (Phi) * cos(t)
        end
    end

    return X, Y, Z
end

N = 100


thetas = LinRange(0, pi, N)
phis   = LinRange(0, 2*pi, N)




function f(pix)::ComplexF64
    theta, phi = pix
    sigma = 1
    return 4 * exp(-(pi-theta)^2/sigma^2)/sqrt(sigma^2 * 2 * pi)+2
end

function g(pix)::ComplexF64
    theta, phi = pix
    return 0.
end

pix = pixels(T)

fpix = f.(pix)
gpix = g.(pix)

flm = T \ fpix
glm = T \ gpix
Flm = [flm]
Glm = [glm]

X, Y, Z = sphere_wrap(flm, thetas, phis, N)

surface(
    X, Y, Z,
    showaxis = false,
    #grid = false,
    camera=(0,0),
    #marker=(:circle,4),
    aspect_ratio=:equal, 
    legend=:none, 
)


@gif for i=1:400
    flm_next, glm_next = evolve(Flm[end], Glm[end])
    X, Y, Z = sphere_wrap(flm_next, thetas, phis, N)
    println("Completed frames ", i)
    surface(
        X, Y, Z,
        showaxis = false,
        grid = false,
        camera=(0,45),
        #marker=(:circle,4),
        legend =:none, 
    )
    plot!(size=(500,500))
    push!(Flm, flm_next)
    push!(Glm, glm_next)
end every 2


