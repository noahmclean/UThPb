function rootOut = fzero_intcpt_assm48assm08_v2(ar234238i, ar230238i, r238235s, mxp, lambda, DRaDU, DPaDU, a, v, t)

% Calculate ni
ni = [exp(lambda.U238*t);                                                                  %238U
      ar234238i*lambda.U238/lambda.U234;                                                   %234U
      ar230238i*lambda.U238/lambda.Th230;                                                  %230Th
      DRaDU * lambda.U238/lambda.Ra226 * (exp(lambda.U238*t)+exp(lambda.U235*t)/r238235s); %226Ra
      0;                                                                                   %206Pb
      exp(lambda.U235*t)/r238235s;                                                         %235U
      DPaDU * lambda.U238/lambda.Pa231 * (exp(lambda.U238*t)+exp(lambda.U235*t)/r238235s); %231Pa
      0];                                                                                  %207Pb

% calculate nt
nt = mxp.UTh8(t)*ni;                        %forward-calculate to get radiogenic 206 and 207

% x-y coordinates (238/206, 207/206) of radiogenic end-member
x = 1/nt(5);      % 238U /206Pb
y = nt(8)/nt(5);  % 207Pb/206Pb

rootOut = v(end)*x+a(end)-y; %this is zero when x and y are on line y = a + vx