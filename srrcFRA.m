function yy = srrcFRA(x, rollOff)
%
% Purpose:
%   This function generates the unit energy square root raised cosine pulse 
% with intersymbol interval = T = 1. This pulse is evaluated at all values of x
% and the peak of the pulse occurs at x = 0.
%
% Inputs:
%   x is a vector representing normallized time values (x=t/T).
%
% Outputs:
%   yy is a vector containing the values of the pulse sampled at the values
%   of t.  For example, yy(3) is the pulse shape evaluated at t(3).
%
% Notes:
% Reference: http://en.wikipedia.org/wiki/Root-raised-cosine_filter
%
% History:
% DATE (YYMMDD) WHO            EMAIL            DETAIL
% 140730        Frank Kragh    fekragh@nps.edu  original code                        cosine pulse type.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num1 =  sin(pi*(1-rollOff)*x);   % Three expressions that appear in 
                                      % the numerator of the srrc.
num2 =  4*rollOff*x;
num3 =  cos(pi*(1+rollOff)*x);

den1 =  pi*x;                  % Two expressions that appear in 
                               % the denominator of the srrc. 
den2 =  1 - (4*rollOff*x).^2;

yy = (num1 + num2.*num3)./(den1.*den2);
        
% Take care of points where (den1.*den2) = 0.
yy(x == 0) = ( 1 - rollOff + 4*rollOff/pi);
yy( (x == 0.25/rollOff) | (x == -0.25/rollOff) ) = (rollOff/sqrt(2)) ...
    * (1 + 2/pi)*sin(0.25*pi/rollOff) + (1 - 2/pi)*cos(0.25*pi/rollOff);
