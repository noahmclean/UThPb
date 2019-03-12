function rootOut = fzero_UTh8_6(UThin, mxp, lambda, r238206in, t)
%% Find when 206/238 = r206238in, subject to disequilibrium, and
%  measured/initial values, for use in concordia plotting. 

ni = calcNi_UTh5_v2(UThin, mxp, lambda, t);
nt = mxp.UTh5(t)*ni;
rootOut = nt(1)/nt(5) - r238206in;