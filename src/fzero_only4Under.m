function n0_2 = fzero_only4Under(nt, mxp, t, lambda) %#ok<INUSD>
%% Determine when the 234U activity increases above const
%   In the case ar234238t is measured > 0, ar230238i is assumed

% nt = [1; ar234238t*lambda238/lambda234]; This was created in plotConc_v1
n0_2 = mxp.U2_2(-t)*nt; % go back in time to calculate n0 before time t
% Uses only second component of n0 (the 234U term) ...
% when the 234U goes negative, so does its activity
