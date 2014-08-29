% This function was developed for attendance of the course
% EC4530 - Software Radio
% Assignment: LAB1, section 4.9.
% written by: Marcos Siu (msiu@nps.edu)
%
% pulse function:
% function p = pulseMAR(t,pulseParam)
% t = time;
% pulseParam = Structure of variables that gives the pulse characteristics:
% Example:  pulseParam.symInterval sets the pulse length (in seconds)
%           pulseParam.type = 'rectangular' sets the pulse as a rectangular
%           pulse. pulseParam.type is a string variable.
%
% The pulse function is defined as:
%                
% p(t)={A if 0 < t < T
%        or 0 otherwise}
%
% For a unit-energy rectangular pulse A = 1/T.
%

function p = pulseMAR(t,pulseParam)
% EC4530: Software Radio
% Students: Marcos Siu - msiu@nps.edu
%
% LAB1) SDR transmitter that modulates the signal space points.
% Section: 4.9 Code
% PART1) Pulse Function
%

p = zeros(size(t)); %creating an empty buffer (double type)
T = pulseParam.symInterval; %(seconds) Symbol interval
type = pulseParam.type; %Pulse type
A = 1/sqrt(T); %adjusting pulse magnitude in order to get a unit-energy symbol

switch type
    case 'rectangular'
        % the logical condition below sets the elements which represents
        % t<T to "1" or otherwise to zero.
        p = double(t < T & t >= 0);
        % The operation below sets the pulse magnitude
        p = p.*A;
        % note1: The pulse magnitude is given by 1/T, in order to set the pulse
        % energy to "1".
    case 'srrc'
        % calls function srrcMAR that returns a SRRC pulse normalized time.
        alpha = pulseParam.rolloff; %Roll Off factor
        D = pulseParam.durInSym; %the duration of the pulse in symbols.
        %check arguments:
        if T < 0 | rem(D,2) > eps | alpha > 1 | alpha < 0
             %display an error return:
            disp('arguments mismatch')
            return
        end

        p = srrcMAR((t-0.5*D*T)/T,alpha);
        trunc = double(t < T*D & t >= 0);
        % The operation below normalize the pulse magnitude and truncate
        % the pulse:
        p = p.*A.*trunc;
    otherwise
        %display an error return:
        disp('this type of pulse is not supported')
        return
end
        
end

    