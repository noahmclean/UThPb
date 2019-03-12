function mxp = makeMxps_v2(lambda)
%% Make matrix exponenial functions for 238U and 235U decay chains
%  The functions use an eigen-decomposition of the matrix exponential solution
%  to the system of linear differential equations that describe the uranium
%  series.  
% 
%  mxp.UTh8(t) evaluates expm(At) for the isotopes:
%  238U-234U-230Th-226Ra-206Pb and 235U-231Pa-207Pb
%  for forward-calculation of relative abundances
% 
%  mxp.UTh4(t) evaluates expm(At) for the isotopes:
%  238U-234U-230Th and 235U
%  for back-calculation of intial relative abundances.


%% For 238U - 234U - 230Th - 226Ra - 206Pb and 235U - 231Pa - 207Pb
mxp.Q8 = ...
[-((lambda.Ra226 - lambda.U238)*(lambda.Th230 - lambda.U238)*(lambda.U234 - lambda.U238))/(lambda.Ra226*lambda.Th230*lambda.U234),                                                                                        0,                                           0,  0, 0,                                          0,  0, 0;
                 -(lambda.U238*(lambda.Ra226 - lambda.U238)*(lambda.Th230 - lambda.U238))/(lambda.Ra226*lambda.Th230*lambda.U234), -((lambda.Ra226 - lambda.U234)*(lambda.Th230 - lambda.U234))/(lambda.Ra226*lambda.Th230),                                           0,  0, 0,                                          0,  0, 0;
                                                          -(lambda.U238*(lambda.Ra226 - lambda.U238))/(lambda.Ra226*lambda.Th230),                  -(lambda.U234*(lambda.Ra226 - lambda.U234))/(lambda.Ra226*lambda.Th230), -(lambda.Ra226 - lambda.Th230)/lambda.Ra226,  0, 0,                                          0,  0, 0;
                                                                                                        -lambda.U238/lambda.Ra226,                                                                -lambda.U234/lambda.Ra226,                  -lambda.Th230/lambda.Ra226, -1, 0,                                          0,  0, 0;
                                                                                                                                1,                                                                                        1,                                           1,  1, 1,                                          0,  0, 0;
                                                                                                                                0,                                                                                        0,                                           0,  0, 0, -(lambda.Pa231 - lambda.U235)/lambda.Pa231,  0, 0;
                                                                                                                                0,                                                                                        0,                                           0,  0, 0,                  -lambda.U235/lambda.Pa231, -1, 0;
                                                                                                                                0,                                                                                        0,                                           0,  0, 0,                                          1,  1, 1];

mxp.G8 = @(t) diag([exp(-lambda.U238*t) exp(-lambda.U234*t) exp(-lambda.Th230*t) exp(-lambda.Ra226*t) 1 exp(-lambda.U235*t) exp(-lambda.Pa231*t) 1]);
                                                                                                       
mxp.Qinv8 = ...
[ -(lambda.Ra226*lambda.Th230*lambda.U234)/((lambda.Ra226 - lambda.U238)*(lambda.Th230 - lambda.U238)*(lambda.U234  - lambda.U238)),                                                  0,                                                        0,                           0, 0,                          0,                  0, 0;
   (lambda.Ra226*lambda.Th230*lambda.U238)/((lambda.Ra226 - lambda.U234)*(lambda.Th230 - lambda.U234)*(lambda.U234  - lambda.U238)), -(lambda.Ra226*lambda.Th230)/((lambda.Ra226 - lambda.U234)*(lambda.Th230 - lambda.U234)),                  0,                           0, 0,                          0,                  0, 0;
  -(lambda.Ra226*lambda.U234*lambda.U238)/((lambda.Ra226 - lambda.Th230)*(lambda.Th230 - lambda.U234)*(lambda.Th230 - lambda.U238)),  (lambda.Ra226*lambda.U234)/((lambda.Ra226 - lambda.Th230)*(lambda.Th230 - lambda.U234)), -lambda.Ra226/(lambda.Ra226 - lambda.Th230),  0, 0,                          0,                  0, 0;
   (lambda.Th230*lambda.U234*lambda.U238)/((lambda.Ra226 - lambda.Th230)*(lambda.Ra226 - lambda.U234)*(lambda.Ra226 - lambda.U238)), -(lambda.Th230*lambda.U234)/((lambda.Ra226 - lambda.Th230)*(lambda.Ra226 - lambda.U234)),  lambda.Th230/(lambda.Ra226 - lambda.Th230), -1, 0,                          0,                  0, 0;
                                                                                                           1,                                                                        1,                                                         1,                           1, 1,                          0,                  0, 0;
                                                                                                           0,                                                                        0,                                                         0,                           0, 0, -lambda.Pa231/(lambda.Pa231 - lambda.U235),  0, 0;
                                                                                                           0,                                                                        0,                                                         0,                           0, 0,  lambda.U235 /(lambda.Pa231 - lambda.U235), -1, 0;
                                                                                                           0,                                                                        0,                                                         0,                           0, 0,                          1,                  1, 1];
mxp.UTh8 = @(t) mxp.Q8*mxp.G8(t)*mxp.Qinv8; 


%% For U and Th decays only, for back-calculation to ni
% 238U - 234U - 230Th and 235U

mxp.Q4 = [ ((lambda.Th230 - lambda.U238)*(lambda.U234 - lambda.U238))/(lambda.U234*lambda.U238),          0,                                  0, 0;
                                         (lambda.Th230 - lambda.U238)/lambda.U234,                 (lambda.Th230 - lambda.U234)/lambda.U234,  0, 0;
                                                                       1,                                 1,                                  1, 0;
                                                                       0,                                 0,                                  0, 1];

mxp.G4 = @(t) diag([exp(-lambda.U238*t) exp(-lambda.U234*t) exp(-lambda.Th230*t) exp(-lambda.U235*t)]);

mxp.Qinv4 = [  (lambda.U234*lambda.U238)/((lambda.Th230 - lambda.U238)*(lambda.U234 - lambda.U238)),                                  0,         0, 0;
              -(lambda.U234*lambda.U238)/((lambda.Th230 - lambda.U234)*(lambda.U234 - lambda.U238)),   lambda.U234/(lambda.Th230 - lambda.U234), 0, 0;
               (lambda.U234*lambda.U238)/((lambda.Th230 - lambda.U234)*(lambda.Th230- lambda.U238)),  -lambda.U234/(lambda.Th230 - lambda.U234), 1, 0;
                                                                        0,                                                            0,         0, 1];
mxp.UTh4 = @(t) mxp.Q4*mxp.G4(t)*mxp.Qinv4; 


%% For 238U-234U-235U, for back-calculation to ni

mxp.Q3 = [ (lambda.U234 - lambda.U238)/lambda.U238, 0, 0;
                                 1,                 1, 0;
                                 0,                 0, 1];
                             
mxp.G3 = @(t) diag([exp(-lambda.U238*t) exp(-lambda.U234*t) exp(-lambda.U235*t)]);

mxp.Qinv3 = [ lambda.U238/(lambda.U234 - lambda.U238), 0, 0;
             -lambda.U238/(lambda.U234 - lambda.U238), 1, 0;
                                 0,                    0, 1];

mxp.U3 = @(t) mxp.Q3*mxp.G3(t)*mxp.Qinv3;


%% For 238U-234U only, used to determine maximum age

% Matrix exponential for 238U-234U system only
mxp.U2   = @(t) [(lambda.U234 - lambda.U238)/lambda.U238, 0; 1, 1] * [exp(-lambda.U238*t) 0; 0 exp(-lambda.U234*t)] * ...
                                   [lambda.U238/(lambda.U234 - lambda.U238), 0; -lambda.U238/(lambda.U234 - lambda.U238), 1];

% U2_2 recovers only the relative abundance of 234U, 
% for quickly determining when it turns negative or goes above or goes over a threshold value
mxp.U2_2 = @(t) [1, 1] * [exp(-lambda.U238*t) 0; 0 exp(-lambda.U234*t)] * ...
                                   [lambda.U238/(lambda.U234 - lambda.U238), 0; -lambda.U238/(lambda.U234 - lambda.U238), 1];

%% For 238U-234U-230Th only, used to determine maximum age

% Matrix exponential for 238U-234U-230Th system only
mxp.Q840 = [ ((lambda.Th230 - lambda.U238)*(lambda.U234 - lambda.U238))/(lambda.U234*lambda.U238),        0,                     0;
                                       (lambda.Th230 - lambda.U238)/lambda.U234,       (lambda.Th230 - lambda.U234)/lambda.U234, 0;
                                                               1,                                         1,                     1];

mxp.G840 = @(t) diag([exp(-lambda.U238*t) exp(-lambda.U234*t) exp(-lambda.Th230*t)]);

mxp.Qinv840 = [(lambda.U234*lambda.U238)/((lambda.Th230 - lambda.U238)*(lambda.U234 - lambda.U238)),                             0, 0;
 -(lambda.U234*lambda.U238)/((lambda.Th230 - lambda.U234)*(lambda.U234  - lambda.U238)),  lambda.U234/(lambda.Th230 - lambda.U234), 0;
  (lambda.U234*lambda.U238)/((lambda.Th230 - lambda.U234)*(lambda.Th230 - lambda.U238)), -lambda.U234/(lambda.Th230 - lambda.U234), 1];


mxp.UTh840 = @(t) mxp.Q840*mxp.G840(t)*mxp.Qinv840;
mxp.UTh840_0 = @(t) mxp.Q840(3,:)*mxp.G840(t)*mxp.Qinv840; % For the 230 concentration only (to solve for when negative)
mxp.UTh840_4 = @(t) mxp.Q840(2,:)*mxp.G840(t)*mxp.Qinv840; % For the 234 concentration only (to solve for when negative)


%% For 238U - 234U - 230Th - 226Ra - 206Pb


mxp.Q5 = ...
[-((lambda.Ra226 -  lambda.U238)*(lambda.Th230 -  lambda.U238)*( lambda.U234 -  lambda.U238))/(lambda.Ra226*lambda.Th230* lambda.U234),                                                                                          0,                                           0,  0, 0;
                  -( lambda.U238*(lambda.Ra226 -  lambda.U238)*(lambda.Th230 -  lambda.U238))/(lambda.Ra226*lambda.Th230* lambda.U234), -((lambda.Ra226 -  lambda.U234)*(lambda.Th230 -  lambda.U234))/(lambda.Ra226*lambda.Th230),                                           0,  0, 0;
                                                             -( lambda.U238*(lambda.Ra226 -  lambda.U238))/(lambda.Ra226*lambda.Th230),                  -( lambda.U234*(lambda.Ra226 -  lambda.U234))/(lambda.Ra226*lambda.Th230), -(lambda.Ra226 - lambda.Th230)/lambda.Ra226,  0, 0;
                                                                                                            - lambda.U238/lambda.Ra226,                                                                 - lambda.U234/lambda.Ra226,                  -lambda.Th230/lambda.Ra226, -1, 0;
                                                                                                                                     1,                                                                                          1,                                           1,  1, 1];

mxp.G5 = @(t) diag([exp(-lambda.U238*t) exp(-lambda.U234*t) exp(-lambda.Th230*t) exp(-lambda.Ra226*t) 1]);                                                                                                                                 

mxp.Qinv5 = ...
[-(lambda.Ra226*lambda.Th230* lambda.U234)/((lambda.Ra226 -  lambda.U238)*(lambda.Th230 - lambda.U238)*( lambda.U234 - lambda.U238)),                                                                                         0,                                           0,  0, 0;
  (lambda.Ra226*lambda.Th230* lambda.U238)/((lambda.Ra226 -  lambda.U234)*(lambda.Th230 - lambda.U234)*( lambda.U234 - lambda.U238)), -(lambda.Ra226*lambda.Th230)/((lambda.Ra226 -  lambda.U234)*(lambda.Th230 - lambda.U234)),                                           0,  0, 0;
 -(lambda.Ra226* lambda.U234* lambda.U238)/((lambda.Ra226 - lambda.Th230)*(lambda.Th230 - lambda.U234)*(lambda.Th230 - lambda.U238)),  (lambda.Ra226* lambda.U234)/((lambda.Ra226 - lambda.Th230)*(lambda.Th230 - lambda.U234)), -lambda.Ra226/(lambda.Ra226 - lambda.Th230),  0, 0;
  (lambda.Th230* lambda.U234* lambda.U238)/((lambda.Ra226 - lambda.Th230)*(lambda.Ra226 - lambda.U234)*(lambda.Ra226 - lambda.U238)), -(lambda.Th230* lambda.U234)/((lambda.Ra226 - lambda.Th230)*(lambda.Ra226 - lambda.U234)),  lambda.Th230/(lambda.Ra226 - lambda.Th230), -1, 0;
                                                                                                                                   1,                                                                                         1,                                           1,  1, 1];
mxp.UTh5 = @(t) mxp.Q5*mxp.G5(t)*mxp.Qinv5; 


%% For deriving eigenvector matrices


% % For mxp.UTh5:
% syms lambda238 lambda234 lambda230 lambda226
% 
% A = [-lambda238  0          0          0         0;
%       lambda238 -lambda234  0          0         0;
%               0  lambda234 -lambda230  0         0;
%               0  0          lambda230 -lambda226 0;
%               0  0          0          lambda226 0];
% 
% [B, C] = eig(A);
% 
% P = [0 0 0 0 1;
%      0 0 0 1 0;
%      0 0 1 0 0;
%      0 1 0 0 0;
%      1 0 0 0 0];
%  
% D = B*P; E = P*C*P;
% F = simplify(inv(D), 20);
% % D is eigenvalue matrix of A, F is inverse, permuted for correct order of decay constants.



