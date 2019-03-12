function covmats = makeCovMats_v2(d, unct)
%% Build covariance matrices from uncertainty inputs
n = size(unct, 1);
covmats = zeros(d,d,n);
logicalindices = logical(tril(ones(d,d)));  %spots to place covariance terms
halfcov = zeros(d);  %just to hold form of d-by-d matrix
trinum_d = d*(d+1)/2;    %number of elements in lower triangular covariance matrix
diag_indcs = trinum_d+1 - (d:-1:1).*((d:-1:1)+1)/2; %positions of variance terms
for i = 1:n
    sveci = unct(i,1:d); rveci = unct(i,d+1:end); %vectors of sigmas and rhos
    
    v1i = zeros(1,trinum_d);  %for indices of covariance matrix
    v1i(diag_indcs) = 0.5*ones(1,d);   %half the variance so that you can add transpose
    v1i(v1i==0) = rveci;
    
    v2index = reshape(tril(repmat(1:d,d,1)),d^2,1);
    v2index = v2index(v2index~=0);  %remove zeros
    v2i = sveci(v2index);
    
    v3index = reshape(tril(repmat((1:d)',1,d)),d^2,1);
    v3index = v3index(v3index~=0);  %remove zeros
    v3i = sveci(v3index);
    
    covvec = v1i.*v2i.*v3i; %rho_xy * sigma_x * sigma_y
    halfcov(logicalindices) = covvec;  %place in lower triangular matrix
    covmats(:,:,i) = halfcov + halfcov';  %duplicate to above diagonal
end
