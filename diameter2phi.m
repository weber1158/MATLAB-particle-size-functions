function grainsize = diameter2phi(diameter,varargin)
%grainsize = diameter2phi(diameter) 
%
%SUMMARY
% Converts a grain diameter (or an array of grain diameters) to "phi" units
% based on the form: φ = -log2(diameter) . If a second input argument is not
% specified, the function will assume that the input 'diameter' is in units
% of mm by default. 
%
%SYNTAX
% diameter2phi(diameter) - converts diameter(s) in mm to phi
% diameter2phi(diameter,units) - converts diameters in 'units' to phi
%
%EXAMPLE
% load diameters.mat
% phis = diameter2phi(diameter_microns,'um') % convert from microns to phi
% 
%See also
%phi2diameter
%grainsizeterm

%(C) 2024 Austin M Weber

%
% BEGIN FUNCTION BODY
%
defaultunits = 'mm';

inP = inputParser();
validPosNum = @(x) isnumeric(x) && all(x > 0);
addRequired(inP,'diameter',validPosNum);
addOptional(inP,'units',defaultunits,@ischar);
parse(inP,diameter,varargin{:});

d = inP.Results.diameter;
u = inP.Results.units;

phi = @(x) (-1).*log2(x);

if strcmpi(u,'mm') || strcmpi(u,'millimeters')
	grainsize = phi(d);
elseif strcmpi(u,'um') || strcmpi(u,'microns') || strcmpi(u,'micrometers')
	grainsize = phi(d./1000);
elseif strcmpi(u,'nm') || strcmpi(u,'nanometers')
	grainsize = phi(d./1000000);
elseif strcmpi(u,'cm') || strcmpi(u,'centimeters')
	grainsize = phi(d.*10);
elseif strcmpi(u,'m') || strcmpi(u,'meters')
	grainsize = phi(d.*1000);
else
	error('The input ''units'' must be ''mm'' (default), ''um'', ''nm'', ''cm'', or ''m''.')
end
%
% END FUNCTION BODY
%
end