function y = pulseFRA(t, pulseParam)
%
% Purpose:
%   This function generates unit energy square root Nyquist or near-square 
% root Nyquist pulses for SDR applications.  This function satisfies the
% requirements of EC4530, 2014 Lab 1, section 4.9.
% Pulse shapes accomodated: rectangular, square root raised cosine
%
% Inputs:
%   t is a vector representing time values.
%   pulseParam is a structure which contains parameters for the square root
% Nyquist pulse.
%
% Outputs:
%   y is a vector containing the values of the pulse sampled at the values
%   of t.  For example, y(3) is the pulse shape evaluated at t(3).
%
% Custom functions called:
% srrcFRA.m
% 
% Notes:  
% All pulses are zero for t<0.
%
% History:
% DATE (YYMMDD) WHO            EMAIL            DETAIL
% 140722        Frank Kragh    fekragh@nps.edu  Original code.
% 140730        Frank Kragh    fekragh@nps.edu  Added square root raised
%                                               cosine pulse type.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch pulseParam.type
    
    case 'rectangular'  % The super-simple rectangular pulse.
        % The inter-symbol interval (pulseParam.symInterval) is also the 
        % pulse duration.  We'll call it T = pulseParam.symInterval
        % The pulse is zero for t<0 and t>= T.
        % The pulse is A otherwise where A is chosen so that the energy of
        % the pulse is A^2*T = 1
        A = 1/sqrt(pulseParam.symInterval);
        y = A*(t >=0 ).*(t < pulseParam.symInterval);
        
    case 'srrc'  % The truncated square root raised cosine pulse.
        x = t/pulseParam.symInterval; % Normalize time axis.
        % make center of pulse duration the peak of the srrc pulse.
            x = x - 0.5*pulseParam.durInSym;  
        % support indictes which points in x need to have srrc calculated.    
        support = (x >= -0.5*pulseParam.durInSym) & ...
            (x < 0.5*pulseParam.durInSym);  
        x = x(support);  % Determine points that need to be calculated.
        
        y = zeros(1, length(t));
        y(support) = (1/sqrt(pulseParam.symInterval))*srrcFRA(x, pulseParam.rolloff);
        
    otherwise  % Go here if function not programmed for pulse shape specified.
        error('Unknown pulse shape specified in pulseParam.type.')

end

return