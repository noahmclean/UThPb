function [tEnv, unctEnvs] = makeEnvelopeUnctMinMax_v2(a, v, Sav, xylims, tminmax)

d = length(a);
nplots = d - 1;
tEnv = zeros(2,2,d);
pts = 100;
unctEnvs = zeros(pts, 2,2, nplots); 
%structure: 1- vector of coords, 2- x(1) or y(2), 3- plus(1) or minus(2), 
%           4- y variable (1:4 here)
    xvar = 1;

    %enlarge t range to ensure the entire envelope is captured
    tdiff = max(tminmax(:,2))-min(tminmax(:,1));
    tminiter = min(tminmax(:,1)) - tdiff;  %initialize
    tmaxiter = max(tminmax(:,2)) + tdiff;  %initialize
    
for yvar = 2:d
    %for the tstarts for y, z, ... vs. x
    for resolveIters = 3%   1:3
        tstep = tdiff*10^(-resolveIters);
        tvec = tminiter:tstep:tmaxiter;
        subCov = Sav([yvar-1 yvar-1+nplots],[yvar-1 yvar-1+nplots]);
        % minus one above because assuming a(1) and v(1)
        dxda = 0; dxdb = 0;
        dyda = 1; dydb = tvec;
        dxdt = v(xvar); dydt = v(yvar);
        vperp = [-dydt dxdt]; %add in term for aspect ratio of plot??
        
        numts = length(tvec);
        s2perp = zeros(1,numts);
        xv = zeros(1,numts);
        yv = zeros(1,numts);
        tint = 1:numts;
        for j = tint 
            Jxyab = [dxda dxdb;
                     dyda dydb(j)];
            s2perp(j) = vperp*Jxyab * subCov * Jxyab' * vperp' / (vperp * vperp');
            xv(j) = 2*cos(atan(-dxdt/dydt))*sqrt(s2perp(j));
            yv(j) = 2*sin(atan(-dxdt/dydt))*sqrt(s2perp(j));
        end
        xplus = a(xvar) + v(xvar)*tvec + xv;
        yplus = a(yvar) + v(yvar)*tvec + yv;
        xminus= a(xvar) + v(xvar)*tvec - xv;
        yminus= a(yvar) + v(yvar)*tvec - yv;
        
        xlimi = xylims(:,xvar); ylimi = xylims(:,yvar);
        xpinbox = (xplus < xlimi(2) & xplus > xlimi(1));  %indices where xplus is in bounding box
        ypinbox = (yplus < ylimi(2) & yplus > ylimi(1));
        plusinbox = tint.* (xpinbox & ypinbox); plusinbox(plusinbox == 0) = []; %remove zeros
        tEnv(1,1,yvar) = tvec(min(plusinbox)-1); tEnv(2,1,yvar) = tvec(max(plusinbox)+1);
        
        xminbox = (xminus < xlimi(2) & xminus > xlimi(1));  %indices where xplus is in bounding box
        yminbox = (yminus < ylimi(2) & yminus > ylimi(1));
        minusinbox = tint.*(xminbox & yminbox); minusinbox(minusinbox == 0) = []; %remove zeros
        tEnv(1,2,yvar) = tvec(min(minusinbox) - 1); tEnv(2,2,yvar) = tvec(max(minusinbox)+1);
    end %for resolveIters = 3 (just one loop now)
    
    tplusdiff = tEnv(2,1,yvar) - tEnv(1,1,yvar);
    tminusdiff = tEnv(2,2,yvar) - tEnv(1,2,yvar);
    tplusvec = tEnv(1,1,yvar):(tplusdiff/(pts-1)):tEnv(2,1,yvar);
    tminusvec = tEnv(1,2,yvar):(tminusdiff/(pts-1)):tEnv(2,2,yvar);
    
    xvplus  = interp1(tvec,xplus,tplusvec);   yvplus  = interp1(tvec,yplus,tplusvec);
    xvminus = interp1(tvec,xminus,tminusvec); yvminus = interp1(tvec,yminus,tminusvec);
    
    %upper and lower unct envvelopes, downsampled and on right domain/range
%     xplus_pts = a(xvar) + v(xvar)*tplusvec + xvplus;
%     yplus_pts = a(yvar) + v(yvar)*tplusvec + yvplus;
%     xminus_pts= a(xvar) + v(xvar)*tminusvec - xvminus;
%     yminus_pts= a(yvar) + v(yvar)*tminusvec - yvminus;

    unctEnvs(:, 1,1, yvar) = xvplus; % xplus_pts;
    unctEnvs(:, 2,1, yvar) = yvplus; % yplus_pts;
    unctEnvs(:, 1,2, yvar) = xvminus; % xminus_pts;
    unctEnvs(:, 2,2, yvar) = yvminus; % yminus_pts;
    
end %for yvar = 2:nplots
