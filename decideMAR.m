% This function was developed for attendance of the course
% EC4530 - Software Radio
% Assignment: LAB5, section 5.4.
% written by: Marcos Siu (msiu@nps.edu)
% version 1: Sep04,2014
%
% decideMAR function:
%
% This functions returns the quantized value of continuous time signal.
% This functions round to the closest value of the alphabet
%
% function y = decideMAR(z,alphabet)
% z = complex number scalar (output of matched filter);
% alphabet = M-ary modulation complex number alphabet;
%
% Example:
% % QPSK quantizer example (normalized):
% alphabet = [(1+j) (1-j) (-1+j) (-1-j)]*0.5*sqrt(2)
% z = 0.6 + j*.2 %example of matched filter output
% y = decideMAR(z,alphabet); %will return the z closest value of the alphabet
%

function y = decideMAR(z,alphabet)
% EC4530: Software Radio
% Students: Marcos Siu - msiu@nps.edu
%
% LAB5) Quantization function (decideMAR.m).
% Section: 5.4 Code
%
%Generate sinc function:
time = 0:1:length(z)-1;
Q = alphabet;


for ix = 1:length(z);
    % compute the distance between Q and z
    aux = abs(Q-z(1,ix));
    y(1,ix) = Q(aux==min(aux));
end

end

