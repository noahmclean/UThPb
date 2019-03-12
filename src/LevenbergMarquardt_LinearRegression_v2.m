%% Matrix version of Levenberg-Marquardt

function [a, v, Sav, L, MSWD, BIC] = LevenbergMarquardt_LinearRegression_v2 ...
    (av, data, covmats, assump, maxiter, chiTolerance, lambda0, verbose)

lambda = lambda0;
d = size(data,2);
a = [assump(1); av(1:(d-1))];  %intercept with y-axis (x=0)
v = [assump(2); av(d:end)];  %av(2) is slope (change in x is 1)
n = size(covmats,3);

L = calcL(a, v, data, covmats, n); %calculate log-likelihood
if verbose, disp(['  L0 = ' num2str(L)]); end

[G, H] = calc_GH(a, v, data, covmats, n);

iters = 0;
while iters < maxiter
    
    h = -(H + lambda*diag(diag(H))) \ G; %calculate update
    
    avnew = av + h;
    anew = [assump(1); avnew(1:(d-1))];  %intercept with x=0 axis/(hyper)plane
    vnew = [assump(2); avnew(d:end)];  %v is direction vector (slope when v1=1)
    
    Lnew = calcL(anew, vnew, data, covmats, n); %calculate log-likelihood
    iters = iters + 1;
    
    if Lnew < L  %if things got worse, try again
        
        if verbose, disp(['Lnew = ', num2str(Lnew) ' rejected, ' num2str([av' lambda])]); end
        lambda = lambda * 10;
        
        %next is top of while
        
    else % if things got better
        
        if abs(1 - L/Lnew) < chiTolerance  %if things got better and solved
            
            a = [assump(1); avnew(1:(d-1))];  %intercept with y-axis (x=0)
            v = [assump(2); avnew(d:end)];  %av(2) is slope (change in x is 1)
            [~, H] = calc_GH(a, v, data, covmats, n);
            Sav = -inv(H);
            L = Lnew;
            MSWD = -2*L/((d-1)*(n-2));
            BIC  = -2*L + (2*d-2)*log(n);
            if verbose, disp(['Lnew = ' num2str(L) ' accepted, ' num2str([avnew' lambda])])
                        disp(['solved, ' num2str(iters) ' iterations']); end
            return
            
        else % if things got better but not solved, accept values, lambda /= 10
            
            if verbose, disp(['Lnew = ' num2str(Lnew) ' accepted, ' num2str([avnew' lambda])]); end
            
            lambda = lambda/10;
            av = avnew;
            a = [assump(1); av(1:(d-1))];  %intercept with y-axis (x=0)
            v = [assump(2); av(d:end)];  %av(2) is slope (change in x is 1)
            L = Lnew;
            [G, H] = calc_GH(a, v, data, covmats, n);
            
            %next is top of while
            
        end %if solved or else just a step in the right direction
        
    end %if things are better/worse
    
end % while

%if you never get there in maxiters
a = -999; v = -999; Sav = -999; L = -999; MSWD = -999; BIC = -999;
disp('LM Failure')

end % main function


%% Local Functions

function [G, H] = calc_GH(a, v, data, covmats, n)

dlda = 0;
dldv = 0;
d2LdaaT = 0;
d2LdvvT = 0;
d2LdavT = 0;

% Calculate gradient and Hessian for log-Likelihood function
for i = 1:n
    
    xi = data(i,:)' - a; % pi - a
    si = covmats(:,:,i);
    
    %common terms in derivatives
    invsi  = inv(si); %#ok<*MINV>
    siv    = si\v;
    vTsi   = v'/si;
    xiTsi  = xi'/si;
    sixi   = si\xi;
    xiTsiv = xiTsi*v;    
    vTsiv  = vTsi*v;
    vTsixi = vTsi*xi;
    
    dlda = dlda + xi'*(invsi - (siv*vTsi)/vTsiv);
    dldv = dldv + (vTsiv * vTsixi * sixi - vTsixi^2*siv)/(vTsiv^2);

    d2LdaaT = d2LdaaT + -(invsi - ( siv * vTsi )/vTsiv);
    
    d2LdavT = d2LdavT + -( vTsiv * ( siv * xiTsi + xiTsiv * invsi ) - ...
        2*xiTsiv * siv * vTsi ) /...
        vTsiv^2; 
    
    d2LdvvT = d2LdvvT + (vTsiv^2*(2 * vTsixi * sixi * vTsi + ...
       vTsiv * sixi * xiTsi - vTsixi^2*invsi - ...
       2*vTsixi * siv * xiTsi ) - ...
       4* vTsiv * ( vTsiv * vTsixi * sixi - vTsixi^2* siv) * vTsi )/ ...
             vTsiv^4;
    
end

% Trim off gradient and Hessian elements for fixed vector components 
G = [dlda(2:end)'; dldv(2:end)];
H = [d2LdaaT(2:end,2:end)  d2LdavT(2:end,2:end); ...
     d2LdavT(2:end,2:end)' d2LdvvT(2:end,2:end)];

end

function L = calcL(a,v, data, covmats, n)

% Evaluate log-liklihood function for vectors a and v given measured data
L = 0;
for i = 1:n
    xi = data(i,:)' - a;  % pi - a, used often
    si = covmats(:,:,i);
    L = L + xi'*(si\xi) - (v'*(si\xi))^2/(v'*(si\v));
end %for i = 1:n

% Leaving out log(det(si)) and constant terms,
L = -0.5*L;

end

