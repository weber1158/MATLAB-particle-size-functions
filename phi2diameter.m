function grainsize = phi2diameter(phi,varargin)
%grainsize = phi2diameter(phi) 
%
%SUMMARY
% Converts grain diameters in "phi" units to millimeters [mm] by the form:
% 2^(-φ) = diameter[mm]
%
%SYNTAX
% phi2diameter(phi) - converts diameter(s) in "phi" units to mm
% phi2diameter(phi,units) - converts "phi" units to a specified unit
%
%EXAMPLE
% load diameters.mat
% cms = phi2diameter(diameters_phi,'cm') %convert from phi to centimeters
% 
%See also
%diameter2phi
%grainsizeterm

%(C) 2024 Austin M Weber

%
% BEGIN FUNCTION BODY
%
defaultunits = 'mm';

inP = inputParser();
validNum = @(x) isnumeric(x);
addRequired(inP,'diameter',validNum);
addOptional(inP,'units',defaultunits,@ischar);
parse(inP,phi,varargin{:});

p = inP.Results.diameter; % phi
u = inP.Results.units;

phi = @(x) (2).^((-1).*x);

if strcmp(u,'mm') || strcmpi(u,'millimeters')
	grainsize = phi(p);
elseif strcmpi(u,'um') || strcmpi(u,'microns') || strcmpi(u,'micrometers')
	grainsize = phi(p).*1000;
elseif strcmpi(u,'nm') || strcmpi(u,'nanometers')
	grainsize = phi(p).*1000000;
elseif strcmpi(u,'cm') || strcmpi(u,'centimeters')
	grainsize = phi(p)./10;
elseif strcmpi(u,'m') || strcmp9(u,'meters')
	grainsize = phi(p)./1000;
else
	error('The input ''units'' must be ''mm'' (default), ''um'', ''nm'', ''cm'', or ''m''.')
end
%
% END FUNCTION BODY
%
end