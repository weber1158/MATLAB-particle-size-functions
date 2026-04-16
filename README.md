## 👨‍💻 MATLAB Particle Size Functions
Copyright 2026 - Austin M. Weber

## 👋 About
This repository contains MATLAB files for calculating particle mass concentrations in snow, evaluating lognormal particle concentrations, fitting lognormal curves to size distribution data, converting particle diameters sizes in metric units to phi "φ" units (and vice versa), and classifying particles sizes according to the Wentworth Scale ([Wentworth, 1922](https://www.jstor.org/stable/30063207)).

## 📖 Documentation

### counts2mass.m
Particle concentration to mass concentration.

```matlab
Cmass = counts2mass(counts,sizes,varargin)
```

**Description** - Converts an array of particle concentrations (in units of counts/mL) to units of µg/g of snow (equivalent to ppm). Assumes that the particles can be approximated as spheres, and that the particles have a mean density of 2.66 g/cm<sup>3</sup> and a snow density of 0.4 g/cm<sup>3</sup>. The latter two assumptions can be modified using the name-value arguments `ParticleDensity` and `SnowDensity`, respectively. The `sizes` input contains the diameters of the particles in each column of `counts` in units of micrometers (µm).

**Example** - Calculate the mass concentrations for five samples (5 rows) across four particle sizes (4 columns). Assume a particle density of 5.26 g/cm<sup>3</sup>, which is the density of the mineral hematite.

```matlab
counts  = [500 100 20  1;...
           250  60  9  0;...
           300  70 14  0;...
           400  85 19  2;...
           350  80 15  1];
 sizes  = [  2   5 10 50];
 Cmass = counts2mass(counts,sizes,'ParticleDensity',5.26);
```
The output `Cmass` is the same size as the input `counts`.

---
### fitDistribution.m
Lognormal PDF for visualization (requires Statistics and Machine Learning Toolbox)

**Syntax**
* `fitDistribution(data)`
* `fitDistribution(data, type)`
* `[x,y,H,L,R2] = fitDistribution(data)`

where
* `data` is a numeric vector.
* `type` (optional) is a `char` vector specifying distribution type (default: `'Lognormal'`)
* `x` is a numeric vector of x-axis data (for plotting)
* `y` is a numeric vector for the probability density function (for plotting)
* `H` (optional output) is an axis handle; specifying will generate a histogram object
* `L` (optional output) is a handle to the fit line; specifying will generate a histogram object
* `R2` (optional output) is the approximate R^2 value for the fit line; specifying will generate a histogram object

**Example**
```matlab
shapes = readtable('particle_morphologies.xlsx');
[x,y] = fitDistribution(shapes.ParticleDiameter);
histogram(shapes.Diameter, 'Normalization', 'pdf');
hold on
  plot(x,y)
hold off
```

** Alternative distribution types:
```
'Beta' | 'Binomial' | 'Exponential' | 'Gamma' | 'Half Normal' |
'InverseGaussian' | 'Logistic' | 'Lognormal' [default] | 'Normal' | 
'Poisson' | 'Rayleigh' | 'Rician' | 'Weibull'
```

For full list of distribution names, see: [fitdist.m](https://www.mathworks.com/help/releases/R2024b/stats/fitdist.html?searchPort=53887#btu538h-distname)

---
### normconc.m
Log-normalized particle concentrations.

**Description** - Calculates `dN/dlogDp` or `dV/dlogDp`, which are the normalized concentrations or normalized volumes of particles based on the diameter size channels of the particles. The function performs the following calculation:

```matlab
dN/dlogDp = dN / (log10(Dupper) - log10(Dlower))
```

where `dN` is a vector of particles size concentrations, `Dupper` is the upper limit of the particle size channel, and `Dlower` is the lower limit of the particle size channel. For instance, the concentration of particles in the 1.0 - 2.0 micron size range is 500, then the `normconc()` can be used to convert the particle concentration into a log-normalized concentration:

```matlab
concentration = 500; 
lower_diameter = 1.0; % in microns
upper_diameter = 2.0; % in microns
lognormconc = normconc(concentration,...
    upper_diameter,lower_diameter)

lognormconc =
    1660.96
```

---
### diameter2phi.m
Convert metric units into the phi (φ) scale.

**Description** - The phi scale is defined as:

```
phi = -log2(diameter)
```

where `diameter` is the diameter of a particle in metric units (i.e, millimeters, microns, etc.). The `diameter2phi()` function applies this equation to a vector of particle sizes. For example, to convert a particle diameter of 0.80 microns into phi units:

```matlab
diameter = 0.80; % microns
phi = diameter2phi(diameter,'um')

phi = 
    10.29
```
Note that you need to specify the metric unit of the particle diameter. For microns, `'um'`, `'microns'`, and `'micrometers'` are valid funcion inputs. The function is comptable with many other common metric size units as well, including `'m'`, `'cm'`, `'mm'`, and `'nm'`. If the metric unit is not specified, the function assumes units of millimeters by default.

---
### phi2diameter.m
Convert phi (φ) scale units into metric units.

**Description** - The `phi2diameter()` function performs the inverse operation of the `diameter2phi()` function. For example, if you have a vector of particle sizes with phi scale values, you can convert them into metric values:

```matlab
phis = [5 8 10 14];
diameters_nm = phi2diameter(phis,'nanometers')

diameters_nm = 
    [31250.00 3906.25 976.56 61.04]
```
If the metric unit is not specified, the function will convert from φ units to millimeters by default.

---
### grainsizeterm.m
Wentworth Scale grain size classification

**Description** - The `grainsizeterm()` function classifies a vector of particle diameters (in phi units) to their corresponding morphological categories based on the Wentworth Scale. For example:

```matlab
phis = [1 3 10];
terms = grainsizeterm(phis)

terms = 
    1x3 categorical array
        Coarse sand    Fine sand    Clay

```

---
### stokes.m
Stokes Law

**Description** - Calculate the settling velocity of an idealized spherical particle.

Stokes Law is defined as:
```
V_p = (2*radius^2*(rho_p - rho_f)*g) / (9*mu_f)
```
where `p` refers to the particle, `f` refers to the fluid, `rho` is density, and `mu` is dynamic viscosity.

**Syntax:**
```
V_p = stokes(r_p,rho_p,rho_f,mu_f)
```

**Inputs:**
* `r_p` --> Radius of the particle (in meters)
* `rho_p` --> Density of the particle (in kg/m^3)
* `rho_f` --> Density of the fluid medium (in kg/m^3)
* `mu_f` --> Dynamic viscosity of the fluid medium (in Pa/s)

**Output:**
* `V_p` --> Settling velocity of the particle (in m/s)

---
### diameters.mat
MATLAB binary file containing two variables: `diameters_microns` and `diameters_phi`. You can load the variables into MATLAB with the `load()` function:

```matlab
load diameters.mat
```

The `diameters_microns` variable is a vector of particle diameter sizes in units of micrometers. The `diameters_phi` variable contains the same particle diameter sizes as `diameters_microns` but expressed in terms of the phi scale.

### References

<small> Wentworth, C.K., 1922. A scale of grade and class terms for clastic sediments. *The Journal of Geology* **30**, 377-392.  </small>