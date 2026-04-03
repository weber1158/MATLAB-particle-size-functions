function [x,y,H,L,R2] = fitDistribution(data,type)
%Lognormal PDF for visualization (requires Statistics & Machine Learning Toolbox)
%
%Syntax
% fitDistribution(data)
% fitDistribution(data,type)
% [x,y,H,L] = fitDistribution(data)
%
% where 
%  * `data` is a numeric vector
%  * `type` (optional) is a char vector specifying distribution type (default: 'Lognormal')
%  * `x` is a numeric vector of x-axis data (for plotting)
%  * `y` is a numeric vector for the probability density function (for plotting)
%  * `H` (optional output) is a axis handle; specifying will generate histogram
%  * `L` (optional output) is a handle to the fit line; specifying will generate histogram
%  * `R2`(optional output) is the approximate R^2 value for the fit line; specifying will generate histogram
%
%
%Example
% shapes = readtable('particle_morphologies.xlsx');
% [x,y] = fitDistribution(shapes.EquivalentDiameter);
% histogram(shapes.EquivalentDiameter, 'Normalization', 'pdf')
% hold on
%   plot(x,y)
% hold off
%
%
%Common Distribution Types
% 'Beta' | 'Binomial' | 'Exponential' | 'Gamma' | 'Half Normal' |
% 'InverseGaussian' | 'Logistic' | 'Lognormal' [default] | 'Normal' | 
% 'Poisson' | 'Rayleigh' | 'Rician' | 'Weibull'
%
% For full list of distribution names, see: <a href="matlab: web('https://www.mathworks.com/help/releases/R2024b/stats/fitdist.html?searchPort=53887#btu538h-distname')">fitdist</a>

% Copyright 2026 Austin M. Weber

% Input parsing
if nargin < 2
  type = 'Lognormal';
end

% Fit a lognormal distribution to the size data
pd = fitdist(data, type);

% Generate x values for the fitted PDF
x = linspace(min(data), max(data), 100);
y = pdf(pd, x);

if nargout >= 3

  % Calculate R2 (AICP)
  [counts,edges] = histcounts(data,'Normalization','pdf');
  bin_centers = edges(1:end-1)+diff(edges)/2;
  fitted_counts = interp1(x, y, bin_centers, 'linear', 0);
  SS_res = sum((counts - fitted_counts).^2);
  SS_tot = sum((counts - mean(counts)).^2);
  R2 = 1 - (SS_res /SS_tot);

  % Generate histogram with fit line overlayed
  H = histogram(data, 'Normalization', 'pdf');
  hold on
    L=plot(x,y, '-k', 'LineWidth', 1);
  hold off
  legend('Data',[type ' PDF'], 'IconColumnWidth', 12, 'Location', 'best')
  set(gcf,'Name',[type ' Distribution'])

end

end
