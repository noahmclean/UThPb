function plotConcTicks_v2(handles, ticksout)


if isempty(handles.cPlot.concLine) % if concordia line is not in current xLims
    return % don't bother with computing or plotting ticks
end

% if     handles.UThin.ar234238.measassm == 1 && handles.UThin.ar230238.measassm == 2
%     measassm = 'meas48assm08';
% elseif handles.UThin.ar234238.measassm == 1 && handles.UThin.ar230238.measassm == 1
%     measassm = 'meas48meas08';
% elseif handles.UThin.ar234238.measassm == 2 && handles.UThin.ar230238.measassm == 1
%     measassm = 'assm48meas08'; % unlikely
% elseif handles.UThin.ar234238.measassm == 2 && handles.UThin.ar230238.measassm == 2
%     measassm = 'assm48assm08';
% end

tvec = ticksout;
relbuf = 0.005;
xrange = handles.cPlot.xLims(2) - handles.cPlot.xLims(1);
yrange = handles.cPlot.yLims(2) - handles.cPlot.yLims(1);
xbufabs = relbuf*xrange;
ybufabs = relbuf*yrange;

ntMat = zeros(8,length(tvec));
niMat = ntMat; % same size
for i = 1:length(tvec)
    
    t = tvec(i);
    niMat(:,i) = calcNi_UTh8_v2(handles.UThin.ar234238.value, handles.UThin.ar230238.value, ...
        handles.UThin.r238235s.value, handles.UThin, handles.mxp, handles.lambda, t);
    ntMat(:,i) = handles.mxp.UTh8(t)*niMat(:,i);
    
end

% Plot tick marks themselves
axes(handles.concPlotAxes)
ticksXY = [ntMat(1,:)./ntMat(5,:); ntMat(8,:)./ntMat(5,:)]; % row1 238/206, row2 207/206 
plot(ticksXY(1,:), ticksXY(2,:), 'ob', 'MarkerSize', 5) % 


% Evaluate concave up vs. down, set tick label position relative to point
nFirstTick = find(handles.cPlot.concLine(1,:) < ticksXY(1,1), 1, 'first');
ua = handles.cPlot.concLine(2,nFirstTick+1);
ub = handles.cPlot.concLine(2,nFirstTick);
uc = handles.cPlot.concLine(2,nFirstTick-1);
h1 = handles.cPlot.concLine(1,nFirstTick) - handles.cPlot.concLine(1,nFirstTick+1);
h2 = handles.cPlot.concLine(1,nFirstTick-1) - handles.cPlot.concLine(1,nFirstTick);
% numerical approx of second derivative on non-uniform mesh at ub
A = 2/(h1*(h1+h2))*ua + (-2/(h1*(h1+h2))-2/(h2*(h1+h2)))*ub + 2/(h2*(h1+h2))*uc;

if A < 0 % concave down
    hAlign = 'Left'; vAlign = 'Bottom'; hOffset = xbufabs; vOffset = 2*ybufabs;
else     % concave up
    hAlign = 'Left'; vAlign = 'Top'; hOffset = xbufabs; vOffset = -ybufabs;
end

% Plot labels
for i = 1:length(tvec)
    text(ticksXY(1,i)+hOffset, ticksXY(2,i)+vOffset, num2str(tvec(i)/1000, '%4.0f'), ...
        'HorizontalAlignment', hAlign, 'VerticalAlignment', vAlign, ...
        'Color', 'b', 'FontSize', 12)
end