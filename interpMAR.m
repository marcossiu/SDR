% This function was developed for attendance of the course
% EC4530 - Software Radio
% Assignment: LAB4, section 4.3.
% written by: Marcos Siu (msiu@nps.edu)
% version 1: Aug25,2014
%
% interpMAR function:
%
% This functions returns the value of continuous time interpolation of the
% discrete signal x[n]. interpMAR version 1, only implements Sinc
% interpolation.
%
% function y = interpMAR(x,t,Tsamp)
% x = discrete signal to be interpoled (reconstructed);
% t = desired time value;
% Tsamp = Sample interval (1/fs, fs = sample frequency);
%
% Example:
% x = [ones(1,10) zeros(1,10)]; %square pulse
% Tsamp = 0.1; %seconds
% t = .87;
% y = interpMAR(x,t,Tsamp); %will return the exact value at t=0.87


function y = interpMAR(x,t,Tsamp)
% EC4530: Software Radio
% Students: Marcos Siu - msiu@nps.edu
%
% LAB4) Interpolation function (pulse reconstruction).
% Section: 4.3 Code
%
%Generate sinc function:
time = 0:1:length(x)-1;

for ix = 1:length(t);
    %creating Ideal Low Pass Filter impulse response:
    h = sinc((t(ix)/Tsamp)-time);
    % computing y(t):
    y(1,ix) = sum(x.*h);
end

end

