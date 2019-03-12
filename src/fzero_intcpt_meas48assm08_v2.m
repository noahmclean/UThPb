function rootOut = fzero_intcpt_meas48assm08_v2(ar234238t, ar230238i, r238235s, mxp, lambda, DRaDU, DPaDU, a, v, t)

% Calculate ni
n3t = [1;
       ar234238t*lambda.U238/lambda.U234;
       1/r238235s]; % assemble nt vector for 238, 234, 235

n3i = mxp.U3(-t)*n3t; %back-calculate ni for time t
n226Rai = DRaDU * lambda.U238/lambda.Ra226 * (n3i(1)+n3i(3)); % assume 226Ra in secular eqbm with U
n231Pai = DPaDU * lambda.U238/lambda.Pa231 * (n3i(1)+n3i(3));
ni = [n3i(1) n3i(2) ar230238i*lambda.U238/lambda.Th230 n226Rai 0 n3i(3) n231Pai 0]';

% calculate nt
nt = mxp.UTh8(t)*ni;                        %forward-calculate to get radiogenic 206 and 207

% x-y coordinates (238/206, 207/206) of radiogenic end-member
x = 1/nt(5);      % 238U /206Pb
y = nt(8)/nt(5);  % 207Pb/206Pb

rootOut = v(end)*x+a(end)-y; %this is zero when x and y are on line y = a + vx