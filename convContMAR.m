% This function was developed for attendance of the course
% EC4530 - Software Radio
% Assignment: LAB3, section 3.13.
% written by: Marcos Siu (msiu@nps.edu)
%
% continuous time convolution:
% function xy = convContMAR(x,y,Tsamp)
% 
% It is a continuous time convolution implemented using convolution sum.
%
% x(t) = vector signal
% y(t) = vector signal
% Tsamp = Sampling Interval (1/Tsamp) = sampling frequency.
% 
% example:
% x = [ones(1,10) 0];
% y = [ones(1,10) 0];
% Tsamp = 0.1;
% xy = convContMAR(x,y,Tsamp);
% n = 0:length(xy)-1
% plot(n*Tsamp,xy);
%
% Example returns the convolution of two rectangular pulses (results a
% triangle).


function xy = convContMAR(x,y,Tsamp)
% EC4530: Software Radio
% Students: Marcos Siu - msiu@nps.edu
%
% LAB3) continuous time convolution:
% Section: 3.13 Code

xy = conv(x,y);
xy = xy*(Tsamp);
xy = [0 xy];

end

