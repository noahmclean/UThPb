function handles = initDataStructs_v2(handles)

handles.UPbin = []; handles.UPbin.a1 = 0; handles.UPbin.v1 = 1;
handles.UThin = [];
%handles.soln = [];
handles.lambda = [];
handles.cPlot.concLine = []; 
handles.controlParams = [];

% Initialize radio buttons, update structures
set(handles.UPbUnctRadioButton_Abs,'value',0);
set(handles.UPbUnctRadioButton_Pct,'value',1);
handles.UPbin.abspct = 2;

set(handles.ar234238RadioButton_Meas,'value',1);
set(handles.ar234238RadioButton_AsIn,'value',0);
handles.UThin.ar234238.measassm = 1;

set(handles.ar230238RadioButton_Meas,'value',1);
set(handles.ar230238RadioButton_AsIn,'value',0);
handles.UThin.ar230238.measassm = 1;

handles.UThin.measassm = 'meas48meas08';

handles.soln.propagateDecayConstUnct = false;

% Initialize values of lambdas 
handles = initLambdas_v2(handles);
handles.mxp = makeMxps_v2(handles.lambda);


% Initialize error checking for values in input edit text boxes
handles.controlParams.plotsNeed = zeros(7,1); %turn to zeros after debugging
% for [UPbdata ar234238Value ar234238OneSigma ar230238Value ...
%      ar230238OneSigma r238235sValue r238235sOneSigma]

% Initialize partitioning values for Ra and Pa
handles.UThin.DRaDU = 0;
handles.UThin.DPaDU = 0;

handles.UThin.r238235s.value = 137.82;
handles.UThin.r238235s.oneSigmaAbs = 0.02;
set(handles.r238235sValue, 'String', '137.82');
set(handles.r238235sOneSigmaAbs, 'String', '0.02');