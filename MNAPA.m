% Name: Seth Thompson
% Student Number: 101031310

% ELEC 4700 MNA PA | February 28th

close all
clear
clc

% Defining global G, C and B

global G C b;

% Starting the system off with matricies the same size as the number of
% nodes, functions from ELEC 4506 will populate each matrix/vector.

G = zeros(5,5);
C = zeros(5,5);
b = zeros(5,1);

% Filling in the matricies/vector

vol(1,0,5) % Use 5 as a dummy variable
res(1,2,1)
cap(1,2,0.25)
res(2,0,2)
ind(2,3,0.2)
res(3,0,10)
res(4,5,0.1)
res(5,0,1000)
% Jury-rig CCVS by dividing gain by R3
vcvs(4,0,3,0,100/10)

% The DC sweep can now be done, must sweep Vin from -10V to 10V

numSteps=200;
DCVector = linspace(-10,10,numSteps);

% Use a loop to obtain all solutions
for i = 1:numSteps
    
    % DC solution, so no need to use C matrix (s = 0)
    b(6,1) = DCVector(i);
    
    % Make a vector that holds the full solution
    Solution = G\b;
    
    % Hold Vo and V3 answers in their own vectors
    VoDC(i) = Solution(5);
    V3DC(i) = Solution(3);
end

% Plotting both Vo and V3 on the same plot

figure(1)
plot(DCVector,VoDC)
hold on
plot(DCVector,V3DC)
hold off
grid on
title({'Vo and V3 DC Sweep Plot','Seth Thompson | 101031310'})
xlabel('Vin (V)')
ylabel('Calculated Voltage (V)')

% Making another loop for the voltage gain

freqVector = linspace(1,100,numSteps);
% Set Vin value to 1V
b(6,1) = 1;
for i = 1:numSteps
   
    % Making the s variable
    w = 2*pi*freqVector(i);
    s = 1j*w;
    
    % This time the C matrix must be considered
    Matrix = G + s*C;
    Solution = Matrix\b;
    
    Vout(i) = Solution(5);
    V3(i) = Solution(3);
    gain(i) = Solution(5)/Solution(3); 
end

% Making a plot for the voltage gain in dB

figure(2)
plot(freqVector,abs(Vout/b(6,1)))
hold on
plot(freqVector,abs(V3))
hold off
grid on
title({'Vo and V3 AC Sweep Plot','Seth Thompson | 101031310'})
xlabel('frequency (Hz)')
ylabel('Calculated Voltage (V)')
legend('Vout','V3')

% Creating a plot for the randomly perturbed capacitance values

for i = 1:numSteps
    random = pi + 0.05*randn(1,1);
    
   % Cange the C matrix to account for the new C value
   C(1,1) = random;
   C(1,2) = -random;
   C(2,1) = -random;
   C(2,2) = random;
   
   % Store C value in vector
   CStore(i) = random;
   % Solve for the gain again 
   w = 2*pi*freqVector(i);
   s = 1j*w;
   
    % This time the C matrix must be considered
    Matrix = G + s*C;
    Solution = Matrix\b;

    Vout(i) = Solution(5);
    V3(i) = Solution(3);
    gain(i) = Solution(5)/Solution(3); 
end

% plotting the histograms for gain and capacitance values
figure(3)
hist(CStore)
title('Capacitance Histogram')
figure(4)
hist(abs(Vout))
title('Vout Histogram')