## MATLAB Functions for Ice Core Dust Size Analyses
<large> Copyright 2024 - Austin M. Weber </large> 

### Description
This repository contains 5 files (4 functions written for MATLAB and 1 binary file) for evaluating log-normal particle concentrations, converting particle diameters sizes in metric units to phi "φ" units (and vice versa), and classifying particles sizes according to the Wentworth Scale (Wentworth, 1922).

---
### normconc.m
Log-normalized particle concentration.

**Description** - Calculates `dN/dlogDp` or `dV/dlogDp`, which are the normalized concentrations or normalized volumes of particles based on the diameter size channels of the particles. The function performs the following calculation:

```matlab
dN/dlogDp = dN / (log10(Dupper) - log10(Dlower))
```

where `dN` is a vector of particles size concentrations, `Dupper` is the upper limit of the particle size channel, and `Dlower` is the lower limit of the particle size channel. For instance, the concentration of particles in the 1.0 - 2.0 micron size range is 500, then the `normconc()` can be used to convert the particle concentration into a log-normalized concentration:

```matlab
concentration = 500; 
lower_diameter = 1.0; % in microns
upper_diameter = 2.0; % in microns
lognormconcention = normconc(concentration,...
    upper_diameter,lower_diameter)

lognormconcentration =
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

**Description** The `grainsizeterm` function classifies a vector of particle diameters (in phi units) to their corresponding morphological categories based on the Wentworth Scale. For example:

```matlab
phis = [1 3 10];
terms = grainsizeterms(phis)

terms = 
    1x3 categorical array
        Coarse sand    Fine sand    Clay

```
---
### diameters.mat
MATLAB binary file containing two variables: `diameters_microns` and `diameters_phi`. You can lod the variables into MATLAB with the `load()` function:

```matlab
load diameters.mat
```

The `diameters_microns` variable is a vector of particle diameter sizes in units of micrometers. The `diameters_phi` variable contains the same particle diameter sizes as `diameters_microns` but expressed in terms of the phi scale.

### References
<small> Wentworth, C.K., 1922. A scale of grade and class terms for clastic sediments. *The Journal of Geology* **30**, 377-392.  </small>