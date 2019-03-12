function rmat = multivariateNormal_v2(mu, sigma, nsamples)
%% multivariate normal random numbers without stats toolbox
% based on mvnrnd and cholcov codes, without the rigor and elegance
%  
%  rmat = multivariateNormal_v2(mu, sigma, nsamples)
%  
%  mu is the mean (row) vector of n elements/variables
%  sigma is the (positive definite) covariance matrix
%  nsamples is the scalar number of random samples

%  rmat is the trials-by-n matrix of random numbers, 
%  with each row a random sample, each column a variable


%% some input error checks

[n,d] = size(mu);
sz = size(sigma);

% if mu was input as a column vector, make it a row vector
if d == 1 && sz(1) == n
    mu = mu';
    d = size(mu, 2);
end % if mu was input as a column vector, make it a row vector

% make sure the mu and sigma are the right size/shape
if sz(1) ~= sz(2)
    error('UThPb:mvrand:covmatNotSquare', ...
          'The covariance matrix should be square');
elseif ~isequal(sz, [d d])
    error('UThPb:mvrand:muSigmaMismatch', ...
        ['The covariance matrix must have the same number of rows/columns as the\n' ...
         'number of variables in the mean vector']);
end % make sure the mu and sigma are the right size/shape

% check for non-negative definite
tol = 10*eps(max(abs(diag(sigma)))); % tolerance for subtraction
if ~all(all(abs(sigma - sigma') < tol)) % check symmetric
    error('UThPb:mvrand:sigmaSymmetric', ...
          'The covariance matrix must be symmetric.');
else
    lambda = eig((sigma+sigma')/2); % force symmetry
    if sum(lambda<0) % if any negative eigenvalues
        error('UThPb:mvrand:positiveDefinite', ...
              'The covariance matrix must be positive definite')
    end %check for non-negative eigenvalues
end %check for symmetric positive definite


%% If the inputs check out, calculate random samples
%  from multivariate normal distribution transforming by Cholesky factorization
%  of covariance matrix

if all(diag(sigma)) % if positive definite, use quick cholesky
    cholSigma = chol(sigma);                   % cholesky decomposition
else % if one or more of the uncertainties is set to zero, use eigendecomposition
    [Q, Lambda] = eig(sigma);
    cholSigma = diag(sqrt(diag(Lambda)))*Q';
end 

rmat = randn(nsamples,d) * cholSigma + repmat(mu, [nsamples 1]); % affine linear transform