function rootOut = fzero_only4Over(const, nt, mxp, t, lambda)
%% Determine when the 234U activity increases above const
%   In the case ar234238t is measured > 0, ar230238i is assumed

% nt = [1; ar234238t*lambda238/lambda234]; This was created in plotConc_v1
n0 = mxp.U2(-t)*nt; % go back in time to calculate n0 before time t
rootOut = n0(2)/n0(1)*lambda.U234/lambda.U238 - const; 
% find when ar234238 = const (max allowable ar)
