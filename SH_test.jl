using SphericalFunctions
using Plots

T = SSHT(0, 10)

function gaussian(pix)
    theta, phi = pix
    return exp(-theta^2/10)
end

pix = pixels(T)

plot(first.(pix), last.(pix), marker=(:circle,5))

f = convert.(Complex, gaussian.(pix))

F = T \ f

f2 = T * F

f2
f