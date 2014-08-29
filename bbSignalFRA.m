function y = bbSignalFRA(a, avgSymEnergy, pulseParam, overSamp, tDelay)
%
% Purpose:
%   This function generates a complex envelope signal for QAM, PSK, ASK, 
% PAM, or PCM.  This function satisfies the requirements of EC4530, 
% 2014 Lab 1, section 4.11.
%
% Inputs:
%   a is a vector containing the message information in the form of 
% signal constellation values.  The average per element energy in a is 1, 
% e.g., E{|a(3)|^2} = 1 where E is expectation.  For example, for a 12 
% channel bit QPSK message, these might be (1+j)/sqrt(2), (1+j)/sqrt(2), 
% (1+j)/sqrt(2), (-1-j)/sqrt(2), (-1+j)/sqrt(2), and (1-j)/sqrt(2).
%   avgSymEnergy is the desired average energy in the baseband symbols at
% the output y.
%   pulseParam is a structure which contains parameters for the Nyquist
% pulse.
%   overSamp is the oversampling factor, M.  There are M samples per
%   intersymbol interval.  The intersymbol interval is specified in
%   pulseParam.symInterval.
%
% Outputs:
%   y is a vector containing the values of the complex envelope signal 
% For the rectangular pulse, these are the samples at times [0 T/M 2T/M ...
% T (M+1)T/M ...] where the total number of samples are M*length(a).
%
% Custom functions called:
% pulse.FRA
% 
% Notes:
%
% History:
% DATE (YYMMDD) WHO            EMAIL            DETAIL
% 140722        Frank Kragh    fekragh@nps.edu  Original code.
% 140730        Frank Kragh    fekragh@nps.edu  See NOTE1
% 140904        MARCOS SIU     msiu@nps.edu     See NOTE2
% NOTE1:  Modified to work with pulses that are longer than the intersymbol
%         interval, which would include the SRRC.
%
% NOTE2: Modified to work with aditional delay (tDelay). In order to attend
% the LAB Assignement 5.1 (SoftRadio SuFY14)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pulseShapFilImpulseResp is the Nyquist pulse, which is the impulse 
% response of the pulse shaping filter.
t = ( 0:(pulseParam.durInSym*overSamp-1) )*( pulseParam.symInterval/overSamp );

%MODIFICATION PROPOSED FROM 'msiu':
t = t - tDelay;
%END OF THE MODIFICATION PROPOSED FROM 'msiu'
pulseShapFilImpulseResp = pulseFRA(t,pulseParam);

% pulseShapFilIn is the input for the pulse shaping filter.
pulseShapFilIn = upsample(a, overSamp);  % insert zeros
pulseShapFilIn = pulseShapFilIn(1: length(pulseShapFilIn)-overSamp+1); 
            % get rid of last overSamp-1 zeros
            
% generate the complex envelope signal (the output of the pulse shaping 
% filter).             
y = sqrt(avgSymEnergy)*conv(pulseShapFilIn, pulseShapFilImpulseResp);

