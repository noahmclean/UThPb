function handles = plotLine_v2(handles)


UPbin = handles.UPbin; 
soln = handles.soln;

dataunct = UPbin.dataunct; abspct = UPbin.abspct;
a = soln.a; v = soln.v; 
Sav = soln.Sav; skipv = UPbin.skipv;

ncols = size(dataunct,2);
d = (sqrt(8*ncols+9)-3)/2;  %ncols = 2*d + (d-1)st triangular number

dataunct(all(dataunct==0,2),:) = []; % clear zero (unused) rows, keep skipped rows for plotting
data = dataunct(:,1:2:(2*d-1));
unct = dataunct(:,[2:2:(2*d) (2*d+1):(2*d+d*(d-1)/2)]); %picks up uncts and corr. coeffs.
n = size(data,1);            % number of rows, data points
nplots = d-1;

if abspct==2 %then convert to absolute uncertainties
    unct(:,1:d) = unct(:,1:d)/100 .* data;
end


%% Plot points and uncertainty ellipses a first time, to determine x-y limits

covmats = makeCovMats_v2(d, unct);     % calculate covariance matrices

%% New xylimits, 2D only

xylims = [0                    0;
          a(1)-a(2)*v(1)/v(2), a(2)-(a(1)*v(2))/v(1)]; %2 rows, d columns, col1 for x, col2 for y
xylims = xylims*1.1; % slight expansion

tminmax = maketLim_v2(a, v, xylims);
[tEnv, unctEnvs] = makeEnvelopeUnctMinMax_v2(a, v, Sav, xylims, tminmax); %#ok<ASGLU>


%% Old code

%xylims = plotlinregxl_XYLim(d, data, covmats);
%tminmax = plotlinregxl_tLim(a, v, xylims);
%[tEnv, unctEnvs] = plotlinregxl_EnvelopeUnctMinMax(a, v, Sav, xylims, tminmax); %#ok<ASGLU>

% %ellipse parameters
pts = 100;
pis = 0:2*pi/(pts-1):2*pi;
circlepts = 2*[cos(pis') sin(pis')];   %a 2-column matrix of the points in a circle, center=origin, radius=2
% 
xvar = 1; %plot first variable listed as x-axis on all plots
% 
%scrdim = get(0, 'ScreenSize');
%scrheight = scrdim(4);
%winheight = scrheight-92;         %92 is the width in pixels of title bars, etc.
%winwidth  = winheight/(d-1);      %so individual x-y plots are roughly equant

% figure('Position',[9 9 winwidth scrheight-92]);
axes(handles.concPlotAxes)
hold on
% 
% hdlmat = zeros(d,1);   %holds graphics handles for each plot
% 
% for yvar = 2:d   %for each plot (projection of d dimensions into 2D)
%     
%     %create plot handle
%     %h = subplot('Position', [(0.1*runi - 0.1 + 0.02) (0.02+.25*(4-yvar)) 0.08 0.2], 'NextPlot', 'add');
%     h = subplot(nplots, 1, yvar-1, 'NextPlot', 'add');
%     hdlmat(yvar) = h;
%     
%     %3.  draw uncertainty envelope
%     plot(unctEnvs(:,1,1,yvar), unctEnvs(:,2,1,yvar), 'g:', 'LineWidth',0.4); %plus delta x or y
%     plot(unctEnvs(:,1,2,yvar), unctEnvs(:,2,2,yvar), 'g:', 'LineWidth',0.4); %minus delta x or y
%     
%     %2.  plot two-sigma covariance ellipses
%     for j = 1:n %plot measured data ellipses
%         
%         %determine ellipse points (using Cholesky decoposition of covariance matrix)
%         s = covmats(:,:,j); sub_s = s([xvar yvar],[xvar yvar]);
%         sc = chol(sub_s);
%         elpts = circlepts*sc + repmat([data(j,xvar) data(j,yvar)], pts, 1);
%                                                                            
%         plot(elpts(:,1), elpts(:,2), 'b', 'LineWidth', 0.2)                
%         
%     end
%     plot([a(xvar)+v(xvar)*tminmax(yvar-1, 1) a(xvar)+v(xvar)*tminmax(yvar-1, 2)], ...
%          [a(yvar)+v(yvar)*tminmax(yvar-1, 1) a(yvar)+v(yvar)*tminmax(yvar-1, 2)], 'g-',...
%         'LineWidth', 0.5) %fit line
%     
%     xylims(:,yvar) = get(h, 'yLim')';  %save off ymin and ymax for y variable (with MATLAB buffer, rounding)
%     
% end
% 
% xylims(:,1) = get(h, 'xLim')';  %get xmin and xmax from last plot

%% Plot a second time, with MATLAB-generated expanded x-y limits

%tminmax2 = plotlinregxl_tLim(a, v, xylims);
%[tEnv unctEnvs] = plotlinregxl_EnvelopeUnctMinMax(a, v, Sav, xylims, tminmax); %#ok<ASGLU>

%delete(get(gca, 'Children'))   %clear all previous plotting

%opengl software

for yvar = 2:d   %for each plot (projection of d dimensions into 2D)
    
    %create plot handle
%    h = subplot(nplots, 1, yvar-1, 'NextPlot', 'add');
%    hdlmat(yvar) = h;
    
    %3.  draw uncertainty envelope
    zcoords = -0.001*ones(size(unctEnvs, 1),1);
    plot(unctEnvs(:,1,1,yvar), unctEnvs(:,2,1,yvar), 'Color', [0 0.5 0], 'LineWidth',1, 'ZData', zcoords) %, 'LineSmoothing', 'on'); %plus delta x or y
    plot(unctEnvs(:,1,2,yvar), unctEnvs(:,2,2,yvar), 'Color', [0 0.5 0], 'LineWidth',1, 'ZData', zcoords) %, 'LineSmoothing', 'on'); %minus delta x or y
    
    %2.  plot two-sigma covariance ellipses
%     for j = 1:n %plot measured data ellipses
%         
%         %determine ellipse points (using Cholesky decoposition of covariance matrix)
%         s = covmats(:,:,j); sub_s = s([xvar yvar],[xvar yvar]);
%         sc = chol(sub_s);
%         elpts = circlepts*sc + repmat([data(j,xvar) data(j,yvar)], pts, 1);
% 
%         if skipv(j) == 0                                                   %if the block has been skipped
%             
%             fill(elpts(:,1), elpts(:,2), 0.5*[1 1 1], ...
%                 'LineWidth', 0.2, 'FaceAlpha', 0.2) %, 'LineSmoothing', 'on') %plot a light gray ellipse
%             plot(data(j,xvar), data(j,yvar),'.', 'MarkerFaceColor', 0.3*[1 1 1],...
%                 'MarkerEdgeColor', 0.3*[1 1 1]) %, 'LineSmoothing', 'on');    %with a dark gray point at the mean
%         else                                                               %if the block is included in the calucluation
%             fill(elpts(:,1), elpts(:,2), 'b',...
%                 'LineWidth', 0.4, 'FaceAlpha', 0.5) %, 'LineSmoothing', 'on');%with a blue ellipse
%             plot(data(j,xvar), data(j,yvar),'.k') %, 'LineSmoothing', 'on');  %plot a black point at the mean
%         end
% 
%     end % for j
    
    plot([a(xvar)+v(xvar)*tminmax(yvar-1, 1) a(xvar)+v(xvar)*tminmax(yvar-1, 2)], ...
         [a(yvar)+v(yvar)*tminmax(yvar-1, 1) a(yvar)+v(yvar)*tminmax(yvar-1, 2)], 'k-',...
        'LineWidth', 2, 'ZData', [-0.001 -0.001]) %, 'LineSmoothing', 'off') %fit line
    xlim(xylims(:,xvar)'); ylim(xylims(:,yvar)');
    %set(h,'xtick',[])  %remove tics+labels for x, which are all the same
    % set(h, 'Color', [0.945 0.969 0.949])
    
end

% Record x-y limits for concordia plotting, 
handles.cPlot.xLims = get(gca, 'XLim');
handles.cPlot.yLims = get(gca, 'YLim');


%set(gca,'xtickMode', 'auto', 'XColor', 'k', 'YColor', 'k')
% set(gca, 'Layer', 'top')

% switch d %label axes according to dimension of dataset
%     case 2 %2D
%         set(get(hdlmat(2),'YLabel'),'String','^{207}Pb/^{206}Pb', ...
%             'Rotation', 90, 'FontSize', 16); %, 'Interpreter', 'latex')
%         set(get(hdlmat(2),'XLabel'),'String','^{238}U/^{206}Pb' , ...
%             'Rotation',  0, 'FontSize', 16); %, 'Interpreter', 'latex')
%         %text('Interpreter','LaTex', 'string','$\frac{\tau_b(t)}{\phi \bar{U}}$','FontSize',20,'position',[-0.1,0.5]);
%     case 3 %3D
%         set(get(hdlmat(3),'XLabel'),'String','x', 'Rotation', 0,  'FontSize', 15)
%         set(get(hdlmat(2),'YLabel'),'String','y', 'Rotation', 90, 'FontSize', 15)
%         set(get(hdlmat(3),'YLabel'),'String','z', 'Rotation', 90, 'FontSize', 15)
%     case 4 %4D
%         set(get(hdlmat(4),'XLabel'),'String','x', 'Rotation', 0,  'FontSize', 15)
%         set(get(hdlmat(2),'YLabel'),'String','y', 'Rotation', 90, 'FontSize', 15)
%         set(get(hdlmat(3),'YLabel'),'String','z', 'Rotation', 90, 'FontSize', 15)
%         set(get(hdlmat(4),'YLabel'),'String','w', 'Rotation', 90, 'FontSize', 15)
%     case 5 %5D
%         set(get(hdlmat(5),'XLabel'),'String','o', 'Rotation', 0,  'FontSize', 15)
%         set(get(hdlmat(2),'YLabel'),'String','p', 'Rotation', 90, 'FontSize', 15)
%         set(get(hdlmat(3),'YLabel'),'String','q', 'Rotation', 90, 'FontSize', 15)
%         set(get(hdlmat(4),'YLabel'),'String','r', 'Rotation', 90, 'FontSize', 15)
%         set(get(hdlmat(5),'YLabel'),'String','s', 'Rotation', 90, 'FontSize', 15)
% end
