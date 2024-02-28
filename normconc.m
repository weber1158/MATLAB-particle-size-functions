function dNdlogD = normconc(dN,Dupper,Dlower)
%Normalized aerosol concentration
%
%Syntax:
% dNdlogD = normconc(dN,Dupper,Dlower)
%
%Description:
% Computes dN/dlogD, where dN is the concentration of aerosols with
% midpoint diameter D. The midpoint diameter is defined as the difference
% between the upper boundary and lower boundary of a diameter size channel.
% For example, if the concentration of aerosols (dN) in the 1.0 - 2.0
% micron size channel is 500, then the normalized concentration is computed
% as:
%       dN/dlogD = dN  / (log10(D[upper]) - log10(D[lower]))
%                = 500 / (log10(2.0) - log10(1.0))
%                = 1660.96
%
%Inputs:
% - All 3 input arguments must be specified
% - All 3 input arguments must be numeric
% - All 3 input arguments must be of size Nx1 or 1xN
% - All 3 input arguments must have the same number of elements
%
% Copyright 2024 Austin M Weber

n_inputs = nargin;
% Display error if the number of input arguments is invalid.
if n_inputs < 3 || n_inputs > 3
    error('The function normconc requires exactly three input arguments.')
end

% Make sure that all variables are vectors (not matrixes)
if ~isvector(dN) || ~isvector(Dupper) || ~isvector(Dlower)
    error('All input arguments must be numeric vectors.')
end

% Make sure that all variables are numeric
if ~isnumeric(dN) || ~isnumeric(Dupper) || ~isnumeric(Dlower)
    error('All input arguments must be numeric vectors.')
end

% Make sure that all variables have the same number of elements
dN_sz = numel(dN);
dU_sz = numel(Dupper);
dL_sz = numel(Dlower);
if dN_sz ~= dU_sz || dN_sz ~= dL_sz || dU_sz ~= dL_sz
    error('All input arguments must have the same number of elements.')
end

% Calculate dlogD
Dupper_log = log10(Dupper);
Dlower_log = log10(Dlower);
dlogD = Dupper_log - Dlower_log;

% Calculate normalized concentration
dNdlogD = dN ./ dlogD;

% Make sure that the output remained a vector. If not, then the input
% arguments were not oriented in the same way and so the correct answer is
% along the diagonal of dNdlogD:
if ~isvector(dNdlogD)
    idx = logical(eye(size(dNdlogD)));
    dNdlogD = dNdlogD(idx);
end

% Ensure that the final output is a column vector (for consistency).
if ~iscolumn(dNdlogD)
    dNdlogD = dNdlogD';
end

end