function V_p = stokes(r_p,rho_p,rho_f,mu_f)
% Stokes Law
% Calculate the settling velocity of an idealized spherical particle
%
%Inputs (all inputs must be numeric scalars!)
% r_p   :: Particle radius (in m)
% rho_p :: Particle density (in kg/m^3)
% rho_f :: Fluid density (in kg/m^3)
% mu_f  :: Dynamic viscosity of fluid (in Pa/s)
%
%Output
% V_p   :: Settling velocity of the particle (in m/s)
%

% Copyright 2026 Austin M. Weber

settling_veloctity = @(r,dp,df,mf) (2 .* r.^2 .* (dp - df) .* 9.81) ./ (9 .* mf);

V_p = settling_velocity(r_p, rho_p, rho_f, mu_f);

end