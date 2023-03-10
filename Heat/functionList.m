%% Paramters

v = 2.317*10^-5; % (kinematic viscosity) m^2/s
k = 3.186*10^-2; % (thermal conductivity) W/(mK)
p = 0.9413; % (density) kg/m^3
c = 1010.6; % (heat capacity) J/(kgK)
L = 9 / 1000; % (length) m
A = 3.723*10^-3; % (disk area) m^2

%% Eperiment

function P = pow(v, i)
    P = v * i;
end

function flux = heatFlux(p, a)
    flux = p / a;
end

function Re = reynolds(u, l, v)
    Re = (u * l) / v;
end

function Pr = prandtl(u, c, k)
    Pr = y * c / k;
end

function h = heatTransCoeff(q, t1, t2)
    h = q/ (t1-t2);
end

function n = nusselt(q, l, k, t1, t2)
    n = q * l / k / (t1-t2);
end

%% Theory

function n = nusseltTheory(Re, Pr)
    if Pr == 0.7
        n = 0.763 * sqrt(Re) * Pr^0.4;
    else
        n = 0.66 * sqrt(Re);
    end
end

function n = nusseltNumerical(Re, Pr)
    
    x = log(Pr);
    s = @(x) 0.09456*x^3 + 0.26266*x^2 + 0.63615*x + 0.75253;
    
    n = s(x) * Pr * sqrt(Re);
end