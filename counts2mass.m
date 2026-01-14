function Cmass = counts2mass(counts,sizes,varargin)
%Particle concentration to mass concentration
%
%SYNTAX
%Cmass = counts2mass(counts,sizes)
%Cmass = counts2mass(counts,sizes,varargin)
%
%INPUT   INPUT TYPE/CLASS            DESCRIPTION             UNITS
%counts  {Numeric vector or matrix}  particle concentration  counts/mL
%sizes   {Numeric scalar or vector}  mean particle size      microns (µm) 
%
%OUTPUT  OUTPUT TYPE/CLASS           DESCRIPTION             UNITS         
%Cmass   {Numeric vector or matrix}  particle mass conc.     µg/g (=ppm)
%
%NAME-VALUE PAIRS
%'ParticleDensity' : Mean density of the particles (default=2.66 g/cm^3) 
%'SnowDensity'     : Density of snow (default=0.40 g/cm^3)
%
%EXAMPLE 1
%C1 = [500; 250; 300; 400; 350]; % particle concentrations counts/mL
%s1 = 2.0;                       % particle size (i.e. diameter, µm)
%Cm = counts2mass(C1,s1);        % 5×1 vector, particle mass conc.
%
%EXAMPLE 2
%C2 = [500 100 20  1;...
%      250  60  9  0;...
%      300  70 14  0;...
%      400  85 19  2;...
%      350  80 15  1];           % 5×4 matrix
%s2 = [  2   5 10 50];           % 1×4 matrix
%Cm = counts2mass(C2,s2);        % 5×4 matrix, particle mass conc.
%
%EXAMPLE 3
%hem_density = 5.26;             % Density of hematite (g/cm^3)
%Cm = counts2mass(C2,s2,...
%        'ParticleDensity',hem_density);
%

% Copyright 2026 Austin M. Weber

% Input parsing
parser = inputParser;
default_part_density = 2.66; % g/cm^3
default_snow_density = 0.4;  % g/cm^3
valfun_counts = @(x) isnumeric(x);
valfun_sizes  = @(x) isnumeric(x) & isvector(x);
valfun_part_density = @(x) isnumeric(x) & isscalar(x);
valfun_snow_density = @(x) isnumeric(x) & isscalar(x);
addRequired(parser,'counts',valfun_counts);
addRequired(parser,'sizes',valfun_sizes);
addParameter(parser,'ParticleDensity',default_part_density,valfun_part_density);
addParameter(parser,'SnowDensity',default_snow_density,valfun_snow_density);
parse(parser, counts, sizes, varargin{:});
part_density = parser.Results.ParticleDensity;
snow_density = parser.Results.SnowDensity;
sz_counts = size(counts);
if length(sizes)~=sz_counts(2)
  counts = counts';
  if length(sizes)~=sz_counts(1)
    error('`sizes` must be the same length as the number of columns in `counts`!')
  else
    warning('`counts` variable needs to be a column vector or NxM matrix where N>=2. Transposing `counts` so that dimensions match with length of `sizes`. Double-check the output to ensure the expected result was achieved.')
  end
end
if iscolumn(sizes)
  sizes = sizes';
end
if part_density<=0
  error('Particle density cannot be less than or equal to 0 g/cm^3!')
end
if (snow_density<=0) || (snow_density>=0.830)
  error('Snow density must be between 0.000 and 0.830 g/cm^3 (not inclusive)!')
end

%
% Function begins here
%

% Volume of a sphere as a function of diameter.
% Diameter (D) is converted from µm to cm and
% then halved to obtain the radius.
Vsphere = @(D) (4/3).*pi().*((D.*0.0001)/2).^3;

% Conversion factor g->µg
ug = 1e6; 

pV = Vsphere(sizes);                    % Volume of a theor. particle(s)
pm = pV .* part_density;                % Mass of a theor. particle(s)
pmTotal = pm .* counts .* ug;           % Masses of real particle(s)
Cmass = pmTotal ./ snow_density;        % Mass concentration(s)

end
