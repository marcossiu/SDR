% This function was developed for attendance of the course
% EC4530 - Software Radio
% Assignment: LAB3, section 3.14
% written by: Marcos Siu (msiu@nps.edu)
%
% pulse function:
% function h_mf = matchedfilterMAR(t,pulseParam)
% t = time (vector);
% pulseParam = Structure of variables that gives the pulse characteristics:
%           pulseParam.symInterval double that sets the pulse length (seconds)
%           pulseParam.type string that sets the pulse as a rectangular
%           pulseParam.rolloff double that sets Roll Off factor
%           pulseParam.durInSym double that sets the duration of the pulse 
%           in symbols.
%
% Example:
% If the desired matched filter has a rectangular shape amplitude 1 and
% period 1(s), defined as:
%
% h_mf(t)={1 if 0 < t <= T
%        or 0 otherwise}
% 
% use the following commands:
% time = 0:0.1:5;
% pulseParam.symInterval = 1; %seconds
% pulseParam.type = 'rectangular';
% pulseParam.durInSym = 1; %pulse
% h_mf = matchedfilterMAR(time,pulseParam);
% stem(h_mf)
% title('Matched Filter Example')

function h_mf = matchedfilterMAR(t,pulseParam)
% EC4530: Software Radio
% Students: Marcos Siu - msiu@nps.edu
%
% LAB3) SDR receiver matched filter.
% Section: 3.14
% version 1) Only rectangular (NRZ) and square-root raised cosine pulses. 
%

% constants and variables:
h_mf = zeros(size(t)); %creating an empty buffer (double type)
T = pulseParam.symInterval; %(seconds) Symbol interval
type = pulseParam.type; %Pulse type
A = 1/sqrt(T); %adjusting pulse magnitude in order to get a unit-energy symbol
     
%check time interval:
if T < 0;
    %display an error return:
    disp('pulseParam.symInterval must be greater than 0')
    return
end

switch type
    case 'rectangular'
        % the logical condition below sets the elements which represents
        % t<T to "1" or otherwise to zero.
        h_mf = double(t <= T & t > 0);
        % The operation below sets the pulse magnitude
        h_mf = h_mf.*A;
        % note1: The pulse magnitude is given by 1/T, in order to set the pulse
        % energy to "1".
    case 'srrc'
        % constants and variables for SRRC filters:
        alpha = pulseParam.rolloff; %Roll Off factor
        D = pulseParam.durInSym; %the duration of the pulse in symbols.
        %check arguments:
        if rem(D,2) > eps | alpha > 1 | alpha < 0
             %display an error return:
             disp('arguments mismatch')
             return
        end
        if D*T > max(t)
            %display an error return:
             disp('Pulse shape duration cannot be smaller than time length')
             disp('ERROR: D*T > max(t)')
             %if the user choose for rescale the matched filter the time
             %vector will be replaced (see footnote 1):
             decision = input('Do you want to rescale your matched filter automatically? [y/n]: ','s');
             if decision(1,1) == 'y' | decision(1,1) == 'Y';
                 t = linspace(0,D*T,length(t));
             else
                 disp('exiting function matchedfilterMAR()')
                 return
             end
        end
        % calls function srrcMAR that returns a SRRC pulse normalized time.
        h_mf = srrcMAR((t-0.5*D*T)/T,alpha);
        trunc = double(t <= T*D & t > 0);
        % The operation below normalize the pulse magnitude and truncate
        % the pulse:
        h_mf = h_mf.*A.*trunc;
    otherwise
        %display an error return:
        disp('this type of Matched Filter is not supported')
        return
end
        
% footnote 1: The way srrc pulse filter is implemented it shifts and truncates 
% the pulse in the interval (0,DT], so if the time vector is smaller than DT 
% in seconds, it will return a deformed pulse. The rescale option give the
% same number of points, but the range is adjusted to all SRRC pulse.


end

    