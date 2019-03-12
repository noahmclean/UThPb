function rootOut = fzero_both40_4(nt, mxp, t, lambda) %#ok<INUSD>
%% Determines when the 230/238 activity activity reaches
%  negative values, which represents the maximum age of sample,
%  when both the 234/238 and 230/238 have been measured.

rootOut = mxp.UTh840_4(-t)*nt;