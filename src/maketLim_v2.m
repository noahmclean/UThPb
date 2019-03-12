function tminmax = maketLim_v2(a, v, xylims)
%find limits for parameteric parameter t in linear regression plots

d = length(a);
numplots = d-1;
tminmax = zeros(numplots,2);% tmax = zeros(4,nruns);

xlims = xylims(:,1);  %the same for every plot
txlims = (xlims-a(1))/v(1);
for ploti = 1:numplots
    yvar = ploti + 1;   %for the first plot, 2nd variable is on y-axis, etc.
    ylimi = xylims(:,yvar);
    yl = a(yvar)+v(yvar)*txlims(1);  %left-most possible y value
    yr = a(yvar)+v(yvar)*txlims(2);  %right-most possible y value
    
    if v(1)*v(yvar) > 0  % positive slope
        if yl > ylimi(1)
            tminmax(ploti, 1) = (xlims(1)-a(1))/v(1);       %min
        else
            tminmax(ploti, 1) = (ylimi(1)-a(yvar))/v(yvar); %min
        end
        if yr > ylimi(2)
            tminmax(ploti, 2) = (ylimi(2)-a(yvar))/v(yvar); %max
        else
            tminmax(ploti, 2) = (xlims(2)-a(1))/v(1);       %max
        end
    else  %negative slope
        if yl < ylimi(2)
            tminmax(ploti, 1) = (xlims(1)-a(1))/v(1);       %min
        else
            tminmax(ploti, 1) = (ylimi(2)-a(yvar))/v(yvar); %min
        end
        if yr > ylimi(1)
            tminmax(ploti, 2) = (xlims(2)-a(1))/v(1);       %max
        else
            tminmax(ploti, 2) = (ylimi(1)-a(yvar))/v(yvar); %max
        end
    end
    
end