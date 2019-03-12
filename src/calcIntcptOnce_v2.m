function handles = calcIntcptOnce_v2(handles)
%% Calculate intercept of concordia curve and regression line
%  but not yet 95% CI (do that with MC).  Use solution to calculate 
%  initial and radiogenic U-Th activity ratios

%% Set up measassm (later do this from GUI function)

UThin = handles.UThin; mxp = handles.mxp; lambda = handles.lambda;

% if     UThin.ar234238.measassm == 1 && UThin.ar230238.measassm == 2
%     measassm = 'meas48assm08';
% elseif UThin.ar234238.measassm == 1 && UThin.ar230238.measassm == 1
%     measassm = 'meas48meas08';
% elseif UThin.ar234238.measassm == 2 && UThin.ar230238.measassm == 1
%     measassm = 'assm48meas08'; % unlikely
% elseif UThin.ar234238.measassm == 2 && UThin.ar230238.measassm == 2
%     measassm = 'assm48assm08';
% end


%% Calculate initial value for solver

% r86m = -handles.soln.a(2)/(2*handles.soln.v(2));
% r76m = 0.5*handles.soln.a(2);
% r76c = handles.soln.a(2);
% t0 = (r76m-r76c)/r86m * (6384.9923*sqrt(r76c-0.80183883) - 9063.8137) * 10^6;

r86max = handles.cPlot.xLims(2);
t0 = 1/handles.lambda.U238 * log(1/r86max + 1);


%% Solve for t and ni based on measured/assumed U-Th params

switch handles.UThin.measassm
    case 'meas48meas08'
        
    handles.soln.tInt = fzero(@(t) fzero_intcpt_meas48meas08_v2(UThin.ar234238.value, UThin.ar230238.value, ...
        UThin.r238235s.value, mxp, lambda, UThin.DRaDU, UThin.DPaDU, handles.soln.a, handles.soln.v, t), t0);
    handles.soln.niInt = calcNi_UTh8_v2(UThin.ar234238.value, UThin.ar230238.value,  UThin.r238235s.value, ...
        UThin, mxp, lambda, handles.soln.tInt);
    handles.soln.ntInt = mxp.UTh8(handles.soln.tInt)*handles.soln.niInt;
    
    ar234238i = handles.soln.niInt(2)/handles.soln.niInt(1) * handles.lambda.U234/handles.lambda.U238;
    set(handles.outar234238, 'String', [num2str(ar234238i, '%5.4f') ' '], 'FontAngle', 'normal')
    ar230238i = handles.soln.niInt(3)/handles.soln.niInt(1) * handles.lambda.Th230/handles.lambda.U238;
    set(handles.outar230238, 'String', [num2str(ar230238i, '%5.4f') ' '], 'FontAngle', 'normal')

    case 'meas48assm08'
        
    handles.soln.tInt = fzero(@(t) fzero_intcpt_meas48assm08_v2(UThin.ar234238.value, UThin.ar230238.value, ...
        UThin.r238235s.value, mxp, lambda, UThin.DRaDU, UThin.DPaDU, handles.soln.a, handles.soln.v, t), t0);    
    handles.soln.niInt = calcNi_UTh8_v2(UThin.ar234238.value, UThin.ar230238.value,  UThin.r238235s.value, ...
        UThin, mxp, lambda, handles.soln.tInt);
    handles.soln.ntInt = mxp.UTh8(handles.soln.tInt)*handles.soln.niInt;
    
    ar234238i = handles.soln.niInt(2)/handles.soln.niInt(1) * handles.lambda.U234/handles.lambda.U238;
    set(handles.outar234238, 'String', [num2str(ar234238i, '%5.4f') ' '], 'FontAngle', 'normal')
    ar230238t = handles.soln.ntInt(3)/handles.soln.ntInt(1) * handles.lambda.Th230/handles.lambda.U238;
    set(handles.outar230238, 'String', [num2str(ar230238t, '%5.4f') ' '], 'FontAngle', 'normal')

    case 'assm48assm08'
        
    handles.soln.tInt = fzero(@(t) fzero_intcpt_assm48assm08_v2(UThin.ar234238.value, UThin.ar230238.value, ...
        UThin.r238235s.value, mxp, lambda, UThin.DRaDU, UThin.DPaDU, handles.soln.a, handles.soln.v, t), t0);    
    handles.soln.niInt = calcNi_UTh8_v2(UThin.ar234238.value, UThin.ar230238.value,  UThin.r238235s.value, ...
        UThin, mxp, lambda, handles.soln.tInt);
    handles.soln.ntInt = mxp.UTh8(handles.soln.tInt)*handles.soln.niInt;
    
    ar234238t = handles.soln.ntInt(2)/handles.soln.ntInt(1) * handles.lambda.U234/handles.lambda.U238;
    set(handles.outar234238, 'String', [num2str(ar234238t, '%5.4f') ' '], 'FontAngle', 'normal')
    ar230238t = handles.soln.ntInt(3)/handles.soln.ntInt(1) * handles.lambda.Th230/handles.lambda.U238;
    set(handles.outar230238, 'String', [num2str(ar230238t, '%5.4f') ' '], 'FontAngle', 'normal')

    otherwise

        disp('not yet')
end


%% Regardless of meas/assm, output intercept age (if >0 )

if handles.soln.tInt >= 0
    set(handles.outInterceptInka, 'String', [num2str(handles.soln.tInt/1000, '%6.2f') ' '])
else
    set(handles.outInterceptInka, 'String', 'No Intercept ', 'FontAngle', 'italic')
    set(handles.outar234238,      'String', ' ')
    set(handles.outar230238,      'String', ' ')
end

% And clear the uncertainty output text boxes to avoid confusion
set(handles.outInterceptinka95CI, 'String', ' ')
set(handles.outar234238_95CI, 'String', ' ')
set(handles.outar230238_95CI, 'String', ' ')

