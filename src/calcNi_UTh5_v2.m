function ni = calcNi_UTh5_v2(UThin, mxp, lambda, t)
%% Calculates ni given various U-Th disequilbrium assumptions and inputs
%  where UTh5 is the system: 238U - 234U - 230Th - 226Ra - 206Pb
%  using the user-input 226Ra/238U distribution coefficient ratio, and
%  assuming initial U-Ra secular eqilibrium

%% Extract measured values

ar234238 = UThin.ar234238.value;
ar230238 =  UThin.ar230238.value;
r238235s =  UThin.r238235s.value;


%% Measured vs. assumed values

switch UThin.measassm
    
    case 'meas48meas08' % measured ar234238t, measured ar230238t
     
    n4t = [1; 
           ar234238*lambda.U238/lambda.U234;
           ar230238*lambda.U238/lambda.Th230;
           1/r238235s]; % assemble nt vector for 238,234,230,235
       
    n4i = mxp.UTh4(-t)*n4t; %back-calculate ni for time t
    n226Rai = UThin.DRaDU * lambda.U238/lambda.Ra226 * (n4i(1)+n4i(4)); % assume 226Ra in secular eqbm with U
    ni = [n4i(1) n4i(2) n4i(3) n226Rai 0]';  %add in no intial Pb

    case 'meas48assm08' % measured ar234238t, assumed initial ar230238t
    
    n3t = [1;
           ar234238*lambda.U238/lambda.U234;
           1/r238235s]; % assemble nt vector for 238, 234, 235
    
    n3i = mxp.U3(-t)*n3t; %back-calculate ni for time t
    n226Rai = UThin.DRaDU * lambda.U238/lambda.Ra226 * (n3i(1)+n3i(3)); % assume 226Ra in secular eqbm with U
    ni = [n3i(1) n3i(2) ar230238 *lambda.U238/lambda.Th230 n226Rai 0]'; 

    case 'assm48assm08'
    
    ni = [exp(lambda.U238*t);
          ar234238*lambda.U238/lambda.U234;
          ar230238*lambda.U238/lambda.Th230;
          UThin.DRaDU * lambda.U238/lambda.Ra226 * (exp(lambda.U238*t) + exp(lambda.U235*t)/r238235s);
          0];
    
    otherwise % can't measure 230 but not 234
    ni = -9999; return
    
end % if case 

