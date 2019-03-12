%% Linear regression in multiple dimensions using Levenberg-Marquardt optimization
function handles = linearRegression_v2(handles)
% INPUTS:
% 'dataunct' is the dataset, formatted as in the provided Excel spreadhsheet:
% Each measured data point is placed in a separate row. The first 2*n 
% columns are the measured data points, each followed by
% its one-sigma uncertainty (absolute or percent).  The final n(n-1)/2 
% columns are the correlation coefficients.  If the variables are listed in 
% alphabetical order, then these correlation coefficients would be in
% alphabetical order as well (e.g. rho-xz comes before rho-yz).
% For 2D data, the columns of dataunct are (x-y)
% x,	±1sigmax,	y,	±1sigmay,	rho-xy
% For 3D data, the columns of dataunct are (x-y-z)
% x,	±1sigmax,	y,	±1sigmay,	z,	±1sigmaz,	rho-xy,	rho-xz,	rho-yz
% For 4D data, the columns of dataunct are (x-y-z-w)
% x,	±1sigmax,	y,	±1sigmay,	z,	±1sigmaz,	w,	±1sigmaw,	rho-xy,	rho-xz,	rho-xw,	rho-yz,	rho-yw,	rho-zw
% For 5D data, the columns of dataunct are (o-p-q-r-s)
% o,	±1sigmao,	p,	±1sigmap,	q,	±1sigmaq,	r,	±1sigmar,	s,	±1sigmas,	rho-op	rho-oq	rho-or	rho-os	rho-pq	rho-pr	rho-ps	rho-qr	rho-qs	rho-rs
% where rho-xy is the correlation coefficient between the uncertainties in x and y

% 'skipv' is a vector of length n where '1' indicates inclusion in
% the calculation, and '0' indicates rejection.
% 'a1' and 'v1' are the assumed values for the first components of the 
% two vectors required to describe a line in multiple dimensions: a point 
% on the line, and the direction vector, respectively.
% 'abspct' has a value of 1 if the input uncertainties are absolute, and
% a value of 2 if the input uncertainties are expressed as percent.

% OUTPUTS:
% 'a' is the point on the line with first component a1 specified above
% 'a2s' contains the two-sigma uncertainties in the free components of a
% 'v' is the direction vector of the line with first component v1 as input
% 'v2s' contains the two-sigma uncertainties in the free components of v
% 'Sav' contains the covariance matrix for the free components of a and v
% 'MSWD' is the mean of the squared weighted deviates (reduced chi-square)
% 'n' is the number of analyses included in the calculation, = sum(skipv)


dataunct = handles.UPbin.dataunct; a1 = handles.UPbin.a1; v1 = handles.UPbin.v1; 
abspct = handles.UPbin.abspct; skipv = handles.UPbin.skipv;

%% Set up calculation

% determine the dimension of the dataset, d
ncols = size(dataunct,2);
d = (sqrt(8*ncols+9)-3)/2;  %ncols = 2*d+(d-1)st triangular number

skipv(all(dataunct==0,2)) = [];      % shrink the vector of skipped data to size of data
dataunct(all(dataunct==0,2),:) = []; % clear zero (unused) rows
dataunct = dataunct(skipv~=0,:);     % remove skipped analyses from consideration

%new dataunct structure:
data = dataunct(:,1:2:(2*d-1));      % extract measured values
unct = dataunct(:,[2:2:(2*d) (2*d+1):(2*d+d*(d-1)/2)]);   %and uncertainties
assump = [a1 v1];   % assumed values for first component of vectors a, v
%n = size(data, 1);  % no longer needed?

if abspct==2 %then convert to absolute uncertainties
    unct(:,1:d) = unct(:,1:d)/100 .* data;
end

%initialize regression params with OLS regression on each marginal
a0 = zeros(d-1,1);
v0 = zeros(d-1,1);
for dimi = 1:(d-1)
    lsi = [ones(size(data,1),1) data(:,1)]\data(:,dimi+1);
    v0(dimi) = lsi(2)*v1;
    a0(dimi) = lsi(1) + v0(dimi)/v1*a1;
end
init = [a0' v0']';

% convert correlation coefficients and uncertainties to covariance matrices
covmats = makeCovMats_v2(d, unct);

%% Send data to Levenberg-Marquardt Solver

lambda0 = 1000;          % initial L-M damping parameter
chiTolerance = 10^-12;   % tolerance of chi-square
maxiter = 10^4;   % maximum iterations before solver quits
verbose = false;  %set this to true to see results of each L-M iteration
% antiAliasOutput = false;

% Send data to Levenberg-Marquardt iterative solver
[handles.soln.a, handles.soln.v, handles.soln.Sav, ~, handles.soln.MSWD, ~] = LevenbergMarquardt_LinearRegression_v2...
            (init, data, covmats, assump, maxiter, chiTolerance, lambda0, verbose);

handles.soln.n = size(data,1);

% if anti-aliasing is requested, use myaa() by Anders Brun
% also available at http://www.mathworks.com/matlabcentral/fileexchange/20979
% if antiAliasOutput, myaa(4); end

