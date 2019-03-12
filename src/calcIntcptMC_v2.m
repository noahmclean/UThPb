function handles = calcIntcptMC_v2(handles, nMC)
%% Calculate intercepts over Monte Carlo simulations, varying measured parameters
 % returns solutions in handles.soln.tIntMC, handles.soln.niIntMC, handles.soln.ntIntMC
 
 
%% Set up MC simulations of U-Th parameters, line fit parameters, decay constants

soln = handles.soln;
ar234238 = handles.UThin.ar234238;
ar230238 = handles.UThin.ar230238;
r238235s = handles.UThin.r238235s;
lambda = handles.lambda;

lineParamMean = [soln.a(2) soln.v(2)];
bmMC = multivariateNormal_v2(lineParamMean, soln.Sav, nMC);

UThMean = [ ar234238.value,         ar230238.value,         r238235s.value];
SUTh = diag([ar234238.oneSigmaAbs^2, ar230238.oneSigmaAbs^2, r238235s.oneSigmaAbs^2]);
UThMC = multivariateNormal_v2(UThMean, SUTh, nMC);

lambdaMean = [lambda.U238, lambda.U234, lambda.Th230, lambda.Ra226, lambda.U235, lambda.Pa231];
if handles.soln.propagateDecayConstUnct % if directed to propagate decay constant uncertainties
    lambdaMCmat = multivariateNormal_v2(lambdaMean, lambda.Slambdas, nMC);
    nuclideNames = {'U238', 'U234', 'Th230', 'Ra226', '235U', 'Pa231'};
    lambdaMC = cell2struct(num2cell(lambdaMCmat, size(lambdaMCmat)), nuclideNames, 2);
else
    lambdaMCmat = repmat(lambdaMean, nMC, 1);
    nuclideNames = {'U238', 'U234', 'Th230', 'Ra226', 'U235', 'Pa231'};
    lambdaMC = cell2struct(num2cell(lambdaMCmat, size(lambdaMCmat)), nuclideNames, 2);
end

%% Solve for intercepts over each MC simulation

t0 = handles.soln.tInt; % use MLE as initial value for solver
handles.soln.tIntMC = zeros(nMC,1);
handles.soln.niIntMC = zeros(8,nMC);
handles.soln.ntIntMC = zeros(8,nMC);
switch handles.UThin.measassm
    case 'meas48meas08'
        
        for i = 1:nMC
        handles.soln.tIntMC(i) = fzero(@(t) fzero_intcpt_meas48meas08_v2(UThMC(i,1), UThMC(i,2), ...
            UThMC(i,3), handles.mxp, lambdaMC(i), handles.UThin.DRaDU, handles.UThin.DPaDU, bmMC(i,1), bmMC(i,2), t), t0);
        handles.soln.niIntMC(:,i) = calcNi_UTh8_v2(UThMC(i,1), UThMC(i,2), UThMC(i,3), ...
            handles.UThin, handles.mxp, lambdaMC(i), handles.soln.tIntMC(i)); 
        handles.soln.ntIntMC(:,i) = handles.mxp.UTh8(handles.soln.tIntMC(i))*handles.soln.niIntMC(:,i);        
        end
        
        ar234238MC = handles.soln.niIntMC(2,:)'./handles.soln.niIntMC(1,:)' * lambda.U234 /lambda.U238;
        ar230238MC = handles.soln.niIntMC(3,:)'./handles.soln.niIntMC(1,:)' * lambda.Th230/lambda.U238;
        
        ar48TextString = 'i';
        ar08TextString = 'i';
        
    case 'meas48assm08'
        
        for i = 1:nMC
        handles.soln.tIntMC(i) = fzero(@(t) fzero_intcpt_meas48assm08_v2(UThMC(i,1), UThMC(i,2), ...
            UThMC(i,3), handles.mxp, lambdaMC(i), handles.UThin.DRaDU, handles.UThin.DPaDU, bmMC(i,1), bmMC(i,2), t), t0);
        handles.soln.niIntMC(:,i) = calcNi_UTh8_v2(UThMC(i,1), UThMC(i,2), UThMC(i,3), ...
            handles.UThin, handles.mxp, lambdaMC(i), handles.soln.tIntMC(i)); 
        handles.soln.ntIntMC(:,i) = handles.mxp.UTh8(handles.soln.tIntMC(i))*handles.soln.niIntMC(:,i);
        end
        
        ar234238MC = handles.soln.niIntMC(2,:)'./handles.soln.niIntMC(1,:)' * lambda.U234 /lambda.U238;
        ar230238MC = handles.soln.ntIntMC(3,:)'./handles.soln.ntIntMC(1,:)' * lambda.Th230/lambda.U238;
        
        ar48TextString = 'i';
        ar08TextString = 't';
        
    case 'assm48assm08'
        
        for i = 1:nMC
        handles.soln.tIntMC(i) = fzero(@(t) fzero_intcpt_assm48assm08_v2(UThMC(i,1), UThMC(i,2), ...
            UThMC(i,3), handles.mxp, lambdaMC(i), handles.UThin.DRaDU, handles.UThin.DPaDU, bmMC(i,1), bmMC(i,2), t), t0);
        handles.soln.niIntMC(:,i) = calcNi_UTh8_v2(UThMC(i,1), UThMC(i,2), UThMC(i,3), ...
            handles.UThin, handles.mxp, lambdaMC(i), handles.soln.tIntMC(i)); 
        handles.soln.ntIntMC(:,i) = handles.mxp.UTh8(handles.soln.tIntMC(i))*handles.soln.niIntMC(:,i);
        end
        
        ar234238MC = handles.soln.ntIntMC(2,:)'./handles.soln.ntIntMC(1,:)' * lambda.U234 /lambda.U238;
        ar230238MC = handles.soln.ntIntMC(3,:)'./handles.soln.ntIntMC(1,:)' * lambda.Th230/lambda.U238;
        
        ar48TextString = 't';
        ar08TextString = 't';
        
    otherwise
        
        disp('not yet')
        return
end

%% Calculate nt and/or ni vectors for MC simulations
% Calculate 95% Confidence Intervals and display them in GUI

indexNonNeg = all([handles.soln.tIntMC ar234238MC ar230238MC]>0,2); % where no calculated parameter is negative

tNonNeg = handles.soln.tIntMC(indexNonNeg);
ar48NonNeg = ar234238MC(indexNonNeg);
ar08NonNeg = ar230238MC(indexNonNeg);

% Sort MC trials and find 95% confidence intervals
tsort    = sort(tNonNeg)/1000; % in ka
ar48sort = sort(ar48NonNeg);
ar08sort = sort(ar08NonNeg);
handles.soln.tIntCI95 =        findShortestCI(tsort, 0.95);
handles.soln.ar234238IntCI95 = findShortestCI(ar48sort, 0.95);
handles.soln.ar230238IntCI95 = findShortestCI(ar08sort, 0.95);

% Calculate means and significant figures, display in GUI
tsigfig = max(-(floor(log10(min(abs(handles.soln.tInt/1000-handles.soln.tIntCI95))))-1), 0); %power of 10 of 2nd sig fig, 0 if > 1
handles.soln.tsigfigString = ['%5.' num2str(tsigfig) 'f'];
set(handles.outInterceptinka95CI, 'String', ['['  num2str(handles.soln.tIntCI95(1), handles.soln.tsigfigString) ...
    ', ' num2str(handles.soln.tIntCI95(2), handles.soln.tsigfigString) ']'])

ar48outMedian = median(ar48NonNeg);
ar48sigfig = max(-(floor(log10(min(abs(ar48outMedian - handles.soln.ar234238IntCI95))))-1), 0);
handles.soln.ar48sigfigString = ['%5.' num2str(ar48sigfig) 'f'];
set(handles.outar234238_95CI, 'String', ['['  num2str(handles.soln.ar234238IntCI95(1), handles.soln.ar48sigfigString) ...
    ', ' num2str(handles.soln.ar234238IntCI95(2), handles.soln.ar48sigfigString) ']'])

ar08outMedian = median(ar08NonNeg);
ar08sigfig = max(-(floor(log10(min(abs(ar08outMedian - handles.soln.ar230238IntCI95))))-1), 0);
handles.soln.ar08sigfigString = ['%5.' num2str(ar08sigfig) 'f'];
set(handles.outar230238_95CI, 'String', ['['  num2str(handles.soln.ar230238IntCI95(1), handles.soln.ar08sigfigString) ...
    ', ' num2str(handles.soln.ar230238IntCI95(2), handles.soln.ar08sigfigString) ']'])


%% Make a matrix plot figure

% Matrix plot
fig2h = figure('Position', [10 10 750 650]);
%set(0, 'DefaultLineLineSmoothing', 'on')
[H,AX,BigAx,P,PAx] = plotmatrix([tNonNeg/1000, ...
    ar48NonNeg , ...
    ar08NonNeg]);
set(H, 'MarkerSize', 1)

% Label axes
set(get(AX(1,1), 'YLabel'), 'String', 'Intercept Age (kyr)')
set(get(AX(2,1), 'YLabel'), 'String', ['[234U/238U]' ar48TextString])
set(get(AX(3,1), 'YLabel'), 'String', ['[230Th/238U]' ar08TextString])
set(get(AX(3,1), 'XLabel'), 'String', 'Intercept Age (kyr)')
set(get(AX(3,2), 'XLabel'), 'String', ['[234U/238U]' ar48TextString])
set(get(AX(3,3), 'XLabel'), 'String', ['[230Th/238U]' ar08TextString])


%% Calculate the shortest confidence interval using sorted MC trials
    function outCI = findShortestCI(sortedData, fractionalCI)
        % sortedData is MC trials sorted in ascending order, 
        % fractionalCI is confidence interval, e.g. 0.95 (not in percent)
        
        intervalLength = ceil(fractionalCI*length(sortedData));
        shortestInterval = sortedData(1+intervalLength) - sortedData(1);
        outCI = [sortedData(1), sortedData(1+intervalLength)];
        
        for j = 2:(length(sortedData)-intervalLength)
            if (sortedData(j+intervalLength) - sortedData(j)) < shortestInterval
                shortestInterval = sortedData(j+intervalLength) - sortedData(j);
                outCI = [sortedData(j), sortedData(j+intervalLength)];
            end
        end
        
    end % function outCI


end % function calcIntcptMC
