function terms = grainsizeterm(sizes,varargin)
%terms = grainsizeterm(sizes) 
%
%SUMMARY
% Uses the Wentworth (1922) naming convention to assign grain size terms to
% an array of grain sizes (in units of phi). The output is a categorical
% array of the same size as the first input.
%
%SYNTAX
% terms = grainsizeterm(sizes) - where 'sizes' is a NxM numeric array of
% grain sizes given in units of "phi".
%
%EXAMPLE
% load diameters.mat
% grain_size_classifications = grainsizeterm(diameters_phi)
%
%See also
%diameter2phi
%phi2diameter

%(C) 2024 Austin M Weber

%
% BEGIN FUNCTION BODY
%
defaultterms = 'wentworth';

inP = inputParser();
validPosNum = @(x) all(isnumeric(x));
addRequired(inP,'sizes',validPosNum);
addParameter(inP,'definition',defaultterms,@ischar);
parse(inP,sizes,varargin{:});

sz = inP.Results.sizes;
trm = inP.Results.definition;

if strcmpi(trm,'wentworth')
	terms = categorical(wentworth(sz));
else
	error('Second input is a name-value pair. Default: ''definition'',''Wentworth''.')
end

%
% LOCAL FUNCTIONS
%
function out = wentworth(size_array)
	% Preallocate memory
	s = size(size_array);
	out = cell(s);
	% Make assignments
	boulders = (size_array <= -8);
		out(boulders) = {'Boulders'};
	cobbles = logicalrange(size_array,[-6,-8]);
		out(cobbles) = {'Cobbles'};
	vcpebbles = logicalrange(size_array,[-5,-6]);
		out(vcpebbles) = {'Very coarse pebbles'};
	cpebbles = logicalrange(size_array,[-4,-5]);
		out(cpebbles) = {'Coarse pebbles'};
	mpebbles = logicalrange(size_array,[-3,-4]);
		out(mpebbles) = {'Medium pebbles'};
	fpebbles = logicalrange(size_array,[-2,-3]);
		out(fpebbles) = {'Fine pebbles'};
	vfpebbles = logicalrange(size_array,[-1,-2]);
		out(vfpebbles) = {'Very fine pebbles'};
	vcsand = logicalrange(size_array,[0,-1]);
		out(vcsand) = {'Very coarse sand'};
	csand = logicalrange(size_array,[1,0]);
		out(csand) = {'Coarse sand'};
	msand = logicalrange(size_array,[2,1]);
		out(msand) = {'Medium sand'};
	fsand = logicalrange(size_array,[3,2]);
		out(fsand) = {'Fine sand'};
	vfsand = logicalrange(size_array,[4,3]);
		out(vfsand) = {'Very fine sand'};
	csilt = logicalrange(size_array,[5,4]);
		out(csilt) = {'Coarse silt'};
	msilt = logicalrange(size_array,[6,5]);
		out(msilt) = {'Medium silt'};
	fsilt = logicalrange(size_array,[7,6]);
		out(fsilt) = {'Fine silt'};
	vfsilt = logicalrange(size_array,[8,7]);
		out(vfsilt) = {'Very fine silt'};
	clay = (size_array > 8);
		out(clay) = {'Clay'};
end
function idx = logicalrange(values,range)
	idx = (values <= range(1)) & (values > range(2));
end
%
% END FUNCTION BODY
%
end