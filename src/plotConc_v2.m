function handles = plotConc_v2(handles)
%% Plots a concordia curve consistent with measured/assumed U-Th data
%  Reads x-y axis limits from plot.
%  Calculates maximum age given U-Th constraints
%  Plots concordia line and labels tics.


%% Extract data from handles structure

xLims = handles.cPlot.xLims;

ar234238  = handles.UThin.ar234238.value;
sar234238 = handles.UThin.ar234238.oneSigmaAbs;
ar230238  = handles.UThin.ar230238.value;
sar230238s= handles.UThin.ar230238.oneSigmaAbs;
r238235s  = handles.UThin.r238235s.value;
sr238235s = handles.UThin.r238235s.oneSigmaAbs;

lambda238 = handles.lambda.U238; lambda234 = handles.lambda.U234;  lambda230 = handles.lambda.Th230;
mxp = handles.mxp; UThin = handles.UThin;


%% Determine maximum possible age, given U-Th inputs

% maximum permissible ar234238, if ar234238t > 1 and assumed an ar230238
maxAr234238 = 200;

% The solution depends on whether the 234/238 and 230/238 have been measured or assumed.

% if     UThin.ar234238.measassm == 1 && UThin.ar230238.measassm == 2
%     measassm = 'meas48assm08';
% elseif UThin.ar234238.measassm == 1 && UThin.ar230238.measassm == 1
%     measassm = 'meas48meas08';
% elseif UThin.ar234238.measassm == 2 && UThin.ar230238.measassm == 1
%     measassm = 'assm48meas08'; % unlikely
% elseif UThin.ar234238.measassm == 2 && UThin.ar230238.measassm == 2
%     measassm = 'assm48assm08';
% end

switch handles.UThin.measassm
    case 'meas48assm08' % if measured 234/238 and assumed 230/238:
        
    nt = [1; ar234238*lambda238/lambda234]; % only 238-234, use for ar>1 or ar<1
    if ar234238 > 1
        const = maxAr234238;
        tmax = fzero(@(t) fzero_only4Over(const, nt, mxp, t, handles.lambda), 1e5);
    else
        tmax = fzero(@(t) fzero_only4Under(nt, mxp, t, handles.lambda), 1e5);
    end
    
    case 'meas48meas08' % if both 234/238 and 230/238 are measured (at time t):

    nt = [1; ar234238*lambda238/lambda234; ar230238*lambda238/lambda230];
    tmax = fzero(@(t) fzero_both40_0(nt, mxp, t, handles.lambda), 1e5);
    
    % Test to make sure tmax does not make the 234 negative, if so evaluate new tmax
    n0 = mxp.UTh840(-tmax)*nt;
    if n0(2) < -1e-8 || isnan(tmax) % if the 234 < 0, within some small rounding error, or 230 never negative
        tmax = fzero(@(t) fzero_both40_4(nt, mxp, t, handles.lambda), 1e5);
    end

    case 'assm48assm08' % to plot conventional concordia (with assumption on ar230238i)
        tmax = 4567e6;
    
end


%% Calculate miniumum date, at rhs of current plot window

r238206minmax = handles.cPlot.xLims;
r238206max = r238206minmax(2);

t0 = 1/lambda238*log(1/r238206max + 1);

% For 238U-234U-230Th-226Ra-206Pb
tmin = fzero(@(t) fzero_UTh8_6(UThin, mxp, handles.lambda, r238206max, t), t0);

% If there is no visible concordia line on the current plot axes
if tmin > tmax || tmin < 0
    handles.cPlot.concLine = [];
    handles.cPlot.xyFortmax = [];
    handles.cPlot.maxPossibleAge = tmax;
    handles.cPlot.minAge = tmin;
    handles.cPlot.maxAge = tmax; %for now, with xmin = 0, no panning allowed
    return
end


%% Calculate concordia line from tmin to tmax

ntPoints = 200; % number of points to plot along concordia, eventually make dependent on pixel count from plot?
tvec = linspace(tmin, tmax, ntPoints);

ntMat = zeros(8,ntPoints);
niMat = ntMat; % same size
for i = 1:ntPoints
    
    t = tvec(i);
    niMat(:,i) = calcNi_UTh8_v2(ar234238, ar230238, r238235s, UThin, mxp, handles.lambda, t);
    ntMat(:,i) = mxp.UTh8(t)*niMat(:,i);
    
end

handles.cPlot.concLine = [ntMat(1,:)./ntMat(5,:); ntMat(8,:)./ntMat(5,:)]; % row1 238/206, row2 207/206 

% and also the xy coordinates of tmax, for separate plotting
handles.cPlot.xyFortmax = handles.cPlot.concLine(:,end);


%% Do some plotting
axes(handles.concPlotAxes)
% blue line for concordia
plot(handles.concPlotAxes, handles.cPlot.concLine(1,:), handles.cPlot.concLine(2,:), ...
   'LineStyle', '-', 'LineWidth', 1, 'Color', [0 0 0.5], 'ZData', -0.001*ones(ntPoints, 1))%, 'LineSmoothing', 'on')

% solid point at tmax
plot(handles.concPlotAxes, handles.cPlot.concLine(1,end), handles.cPlot.concLine(2,end), ...
    'Marker', '.', 'MarkerSize', 14, 'MarkerFaceColor', 'b')

% experimental: set xLim(1) = 0
currentXLim = get(handles.concPlotAxes, 'XLim');
set(handles.concPlotAxes, 'XLim', [0 currentXLim(2)]);

%% Update handles structure with outputs

handles.cPlot.maxPossibleAge = tmax;
handles.cPlot.minAge = tmin;
handles.cPlot.maxAge = tmax; %for now, with xmin = 0, no panning allowed



end