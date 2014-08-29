% This function was developed for attendance of the course
% EC4530 - Software Radio
% Assignment: LAB3, section 3.15.
% written by: Marcos Siu (msiu@nps.edu)
%
% mfIllMAR function:
%
% This functions returns the output of the matched filter when the input is a 
% complex baseband signal.
% envelope of baseband Signal.
%
% function output = mfIllMAR(a,E,pulseParam,M)
% a = signal constellation values;
% E = average symbol energy;
% M = oversampling factor (2,4 or 8);
% pulseParam = Structure of variables that gives the pulse characteristics:
%           pulseParam.symInterval - double that sets the pulse length (seconds)
%           pulseParam.type - string that sets the pulse as a rectangular
%           pulseParam.rolloff - double that sets Roll Off factor
%           pulseParam.durInSym - double that sets the duration of the pulse 
%           in symbols (even number only).
%           pulseParam.LAB - string that decides if this LAB will use
%           student solution (functionMAR.m) or professor solutions
%           (functionsFRA.m) choose betweem {'MAR','FRA'}(see footnote 1)
%
% function [output,recov_a] = mfIllMAR(a,E,pulseParam,M)
%
% recov_a is a vector with the identified symbols (received 'a'). It is
% useful for test the model Bit Error Rate (BER), but noise block is not
% implemented yet.
%

function [output,varargout] = mfIllMAR(a,E,pulseParam,M)
% EC4530: Software Radio
% Students: Marcos Siu - msiu@nps.edu
% version 1)
%
% LAB3) SDR receiver decision output
% Section: 3.15 Code
%
%Variables:
T = pulseParam.symInterval; %pulse interval (period)
%LAB = pulseParam.LAB;
type = pulseParam.type;

%% Check parameters BLOCK (check arguments if they match the requirements):
switch type
    case 'rectangular'
        D = 0;
        graph_range = 1;
    case 'srrc'
        D = pulseParam.durInSym; %the duration of the pulse in symbols (must be even value).
        graph_range = 1;
    otherwise
        %display an error return:
        disp('this type of Pulse Shape is not supported')
end

if T < 0 | rem(M,1) > eps 
         %display an error return:
        disp('T or M invalid values')
        return
elseif rem(D,2) > eps
        %display an error return:
        disp('D invalid values')
        return
end

%% Creating Time Vector:
Tsamp = T/M; %Sample period (<Sample Frequency>^(-1))
N = length(a)+D; %computes the MSG size.
n = 0:1:((M*N)-1); %sample size (M*N)
t = n*Tsamp; %time defined in function of Sample period or Sample frequency.

%% Code CORE: Creating Baseband signal, applying Matched Filter and process output.

        BBsig = bbSignalFRA(a,E,pulseParam,M); %Baseband Signal
        h_mf = matchedfilterMAR(t,pulseParam); %Matched Filter
        buffer = zeros(2,length(BBsig)+length(h_mf)); 
        buffer(1,:) = convContMAR(real(BBsig),h_mf,Tsamp); %Convolution Signal and Filter (I)
        buffer(2,:) = convContMAR(imag(BBsig),h_mf,Tsamp); %Convolution Signal and Filter (Q)
        output = buffer(1,:)+(1j*(buffer(2,:))); % FUNCTION RETURN OUTPUT...

%% note: previously is was implemented as a switch case, in order to test
% functionsMAR() and functionsFRA. I kept the code.
%   switch LAB
 %   case 'FRA'
%        BBsig = bbSignalFRA(a,E,pulseParam,M); %Baseband Signal
 %       h_mf = matchedfilterMAR(t,pulseParam); %Matched Filter
%        buffer = zeros(2,length(BBsig)+length(h_mf)); 
%        buffer(1,:) = convContMAR(real(BBsig),h_mf,Tsamp); %Convolution Signal and Filter (I)
%        buffer(2,:) = convContMAR(imag(BBsig),h_mf,Tsamp); %Convolution Signal and Filter (Q)
%        output = buffer(1,:)+(1j*(buffer(2,:)));
 %THIS PART WAS WRITTEN TO TEST CODE USING functionsMAR
        %   case 'MAR'
 %       BBsig = bbSignalMAR(a,E,pulseParam,M); %Baseband Signal
 %       h_mf = matchedfilterMAR(t,pulseParam); %Matched Filter
 %       buffer = zeros(2,length(BBsig)+length(h_mf));
 %       buffer(1,:) = convContMAR(real(BBsig),h_mf,Tsamp); %Convolution Signal and Filter (I)
 %       buffer(2,:) = convContMAR(imag(BBsig),h_mf,Tsamp); %Convolution Signal and Filter (Q)
 %       output = buffer(1,:)+(1j*(buffer(2,:)));
 %   otherwise
        %display an error return:
 %       disp('Code not implemented - function terminated')
 %   end

%%  Receiver decision block 
% (generates the vector recov_a that might be the same as a_n, but with
% different amplitude): %see footnote 3:
    
    % reshape the time vector size due to convolution. (%see footnote 2)
    t2 = 0:1:(length(output)-1); 
    t2 = t2*Tsamp;
    %recovered 'a' vector:
    recov_a = output((rem((t2-Tsamp),T)< eps & (t2-Tsamp) >= D*T & (t2-Tsamp)...
        <= T*D+((max(t2)-2*(D*T))/2)));
        
    t3 = t2((rem((t2-Tsamp),T)< eps & (t2-Tsamp) >= D*T & (t2-Tsamp)...
        <= T*D+((max(t2)-2*(D*T))/2)));%time vector for decision block only
   
    % return the vector only if was assigned an output by the user.
    if nargout == 2;
        varargout{1} = recov_a;
    elseif nargout > 2;
        disp('ERROR: Too many output arguments')
        return;
    end

    %% Plotting block - COMPLEX SIGNAL:
    
   if sum(buffer(2,:))~=0;
       buffer = zeros(2,length(output)); % creating baseband plot buffer.
       %plotting commands:
        subplot(211);
        buffer(1,1:length(BBsig)) = real(BBsig);
        plot(t2,buffer(1,:)/1000,'b',t2,real(output),'r','LineWidth',2);
        % notice the BBsignal is divided by 1000.
        axis([(0.5*D+1)*T max(t2) (-max(output)-1) (max(output)+1)]);
        title('Matched Filter Output (In-phase)','FontSize', 20);
        xlabel('t (seconds)','FontSize', 14);
        ylabel('Magnitude','FontSize', 14);
        hold on;
        %ploting receiver decisions:
        plot(t3,real(recov_a),'sb','MarkerSize',14);
        grid on;
        legend('Baseband Signal (.10^3)','Matched Filter Output',...
            'Receiver Decisions','FontSize', 14);
        hold off;
        
        subplot(212);
        buffer(2,1:length(BBsig)) = imag(BBsig);
        plot(t2,buffer(2,:)/1000,'b',t2,imag(output),'r','LineWidth',2);
        % notice the BBsignal is divided by 1000.
        axis([(0.5*D)*T max(t2) (-max(output)-1) (max(output)+1)]);
        title('Matched Filter Output (Quadrature)','FontSize', 20);
        xlabel('t (seconds)','FontSize', 14);
        ylabel('Magnitude','FontSize', 14);
        hold on;
        %ploting receiver decisions:
        plot(t3,imag(recov_a),'sb','MarkerSize',14);
        grid on;
        legend('Baseband Signal (.10^3)','Matched Filter Output',...
            'Receiver Decisions','FontSize', 14);
        hold off;

        saveas(1,'Figure_mfIll_complex');
        clf;
        
   %% Plotting block - REAL SIGNAL:
   elseif sum(buffer(2,:))==0; 
        buffer = zeros(1,length(output));  % creating baseband plot buffer.
        buffer(1,1:length(BBsig)) = real(BBsig);
        plot(t2,buffer/1000,'b',t2,real(output),'r','LineWidth',2);
        % notice the BBsignal is divided by 1000.
        axis([(0.5*D-1)*T (max(t3)+T) (-max(output)-1) (max(output)+1)]);
        title('Matched Filter Output (NRZ)','FontSize', 20);
        xlabel('t (seconds)','FontSize', 14);
        ylabel('Magnitude','FontSize', 14);
        hold on;
        %ploting receiver decisions:
        plot(t3,recov_a,'sb','MarkerSize',14);
        grid on;
        legend('Baseband Signal (x10^3)','Matched Filter Output',...
            'Receiver Decisions');
        hold off;
        saveas(1,'Figure_3_17');
        clf;
       
   end
   

    
%% FOOTNOTES:
% footnote 1: For LAB purposes only. Testing Professor solutions against
% student designed solution.
% footnote 2: When convolution is performed its output has larger size when
% compared with the input. In order to use the Matched Filter Output, new
% time vector should be generated.
% footnote 3: Because of the implementation of convContMAR function, all
% timing is shiffited by 1 sample to the right (just for fit the continous
% time convolution). In order to make the decision in the right place, t3
% vector was shifted back 1 sample.
end

