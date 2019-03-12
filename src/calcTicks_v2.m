function ticksout = calcTicks_v2(handles)
%% Calculate optimum tick labels for a tick range
%  Algorithm after Talbot et al - An extension of Wilkinsons Algorithm 
%  for positioning tick labels on axes (Talbot et al., 2010)

% if concordia line is not in current xLims or no concLine calculated
if~isfield(handles, 'cPlot') || ~isfield(handles.cPlot, 'concLine') ...
        || isempty(handles.cPlot.concLine) || isnan(handles.cPlot.maxAge)
    ticksout = [];
    return % don't bother with computing or plotting ticks
end

cPlot = handles.cPlot; 
concPlotAxes = handles.concPlotAxes;

% Input: approx number of pixels between plot ticks
pixelsPerTick = 80;
tickFontSize = 12;

%% First, determine plot and concordia dimensions

xRangeOfConcLine = cPlot.concLine(1,1) - cPlot.concLine(1,end);
xRangeOfPlot = cPlot.xLims(2) - cPlot.xLims(1);
tmin = cPlot.minAge; tmax = cPlot.maxAge;

set(concPlotAxes, 'Units', 'pixels')
plotPosition = get(concPlotAxes, 'Position');
plotWidthInPixels = plotPosition(3);
concLengthInPixels = xRangeOfConcLine/xRangeOfPlot * plotWidthInPixels;

numTicks = concLengthInPixels/pixelsPerTick; %desired number of ticks


%% 

Q = [1, 5, 2, 2.5, 4, 3];

m = ceil(numTicks);
% weights: simplicity, coverage, density, legibility
if m == 1, w = [0.5 0 0.5 0]; best_score = -2; kstart = 1;% simplicity_max(1, Q, 1)-eps;
else w = [0.15, 0.20, 0.6, 0.05]; best_score = -2.0; kstart = 2;
end

jmax = 50; kmax = 50; zmax = 10;

only_inside = true;

dmin = tmin; dmax = tmax;

j = 1.0;
while j < jmax
    for q = Q
        sm = simplicity_max(q, Q, j);
        
        if w(1)*sm + w(2) + w(3) + w(4) < best_score
            j = inf;
            break
        end
        
        k = kstart;
        while k < kmax
            dm = density_max(k, m);

            if w(1)*sm + w(2) + w(3)*dm + w(4) < best_score
                break
            end

            delta = (dmax-dmin)/(k+1.0)/j/q;
            z = ceil(log10(delta));
            
            while z < zmax
                lstep = j*q*10^z;
                cm = coverage_max(dmin, dmax, lstep*(k-1.0));
                
                if w(1)*sm + w(2)*cm + w(3)*dm + w(4) < best_score
                    break
                end
                
                min_start = floor(dmax/lstep)*j - (k-1.0)*j;
                max_start = ceil(dmin/lstep)*j;
                
                if min_start > max_start
                    z = z+1;
                    break
                end
                
                for start = floor(dmax/lstep-(k-1)):1/j:ceil(dmin/lstep) % range(int(min_start), int(max_start)+1)
                    lmin = start * (lstep);
                    lmax = lmin + lstep*(k-1.0);
                    
                    s = simplicity(q, Q, j, lmin, lmax, lstep);
                    c = coverage(dmin, dmax, lmin, lmax);
                    d = density(k, m, dmin, dmax, lmin, lmax);
                    l = legibility(lmin, lmax, lstep);
                    
                    score = w(1)*s + w(2)* c + w(3)*d + w(4)*l;
                    
                    if score > best_score && (~only_inside || (lmin >= dmin && lmax <= dmax))
                        best_score = score;
                        best = [lmin, lmax, lstep, j, q, k];
                    end
                    
                    z = z+1;
                end
                k = k+1;
            end
            j = j+1;
        end
    end
end

%% nested functions

    function sm = simplicity_max(q, Q, j)
        n = numel(Q);
        i = find(Q==q) + 1;
        v = 1;
        sm = (n-i)/(n-1) + v - j;
    end

    function s = simplicity(q, Q, j, lmin, lmax, lstep)
        n = numel(Q);
        i = find(Q==q) + 1;       
        if ((lmin + lstep < eps || (lstep - lmin + lstep) < eps) && lmin <= 0 && lmax >= 0)
            v = 1;
        else
            v = 0;
        end
        s = (n-i)/(n-1.0) + v - j;
    end


    function l = legibility(lmin, lmax, lstep)
        l = 1; % some work to do here
    end

    function dm = density_max(k, m)
        if m == 1, dm = 1;
        elseif k >= m, dm = 2 - (k-1.0)/(m-1.0);
        else dm = 1;
        end
    end

    function d = density(k, m, dmin, dmax, lmin, lmax)
        
        if m == 1
            d = 1;
        else
        r = (k-1.0) / (lmax-lmin);                          % candidate density
        rt = (m-1.0) / (max(lmax, dmax) - min(lmin, dmin)); % target density
        d =  2 - max( r/rt, rt/r );
        end
    end

    function cm = coverage_max(dmin, dmax, span)
        range = dmax-dmin;
        if span > range
            half = (span-range)/2;
            cm = 1 - half^2 / (0.1*range)^2;
        else
            cm = 1;
        end
    end

    function c = coverage(dmin, dmax, lmin, lmax)
        range = dmax-dmin;
        c = 1 - 0.5 * ((dmax-lmax)^2+(dmin-lmin)^2) / (0.1 * range)^2;
    end

ticksout = best(1):best(3):best(2);

end
