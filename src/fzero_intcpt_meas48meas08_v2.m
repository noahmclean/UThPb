function rootOut = fzero_intcpt_meas48meas08_v2(ar234238t, ar230238t, r238235s, mxp, lambda, DRaDU, DPaDU, a, v, t)

% Calculate ni
n4t = [1;
       ar234238t*lambda.U238/lambda.U234;
       ar230238t*lambda.U238/lambda.Th230;
       1/r238235s]; % assemble nt vector for 238,234,230,235

n4i = mxp.UTh4(-t)*n4t; %back-calculate ni for time t
n226Rai = DRaDU * lambda.U238/lambda.Ra226 * (n4i(1)+n4i(4)); % assume 226Ra in secular eqbm with U
n231Pai = DPaDU * lambda.U238/lambda.Pa231 * (n4i(1)+n4i(4));
ni = [n4i(1) n4i(2) n4i(3) n226Rai 0 n4i(4) n231Pai 0]';  %add in no intial Pb

% calculate nt
nt = mxp.UTh8(t)*ni;                        %forward-calculate to get radiogenic 206 and 207

% x-y coordinates (238/206, 207/206) of radiogenic end-member
x = 1/nt(5);      % 238U /206Pb
y = nt(8)/nt(5);  % 207Pb/206Pb

rootOut = v(end)*x+a(end)-y; %this is zero when x and y are on line y = a + vx
