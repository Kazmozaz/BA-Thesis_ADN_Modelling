% Evaluation of high-resolution measurement data of the research project
% with Discrete Wavelet Transform
% "self-regulating effect"
% 
% 24.06.2023 - Verion 1 - Kareem Hassan (IFK)

clc
clear all

%% Measurement data from mat-file

load('Z:\Daten\Netzselbstregeleffekt\UW_Schickhardtschule\UW_Schickhardtschule_113_20180913_10240HzOszilloskop.mat')

ii_measurement = 99; % choose entry of the measurement-struct single_data 


t = single_data(ii_measurement).t; % watch out for wrong time-values, frequency must be around 50 Hz

%t = single_data(ii_measurement).t*2;


U12 = single_data(ii_measurement).U12.*1e-3; % [kV]
U23 = single_data(ii_measurement).U23.*1e-3; % [kV]
U31 = single_data(ii_measurement).U31.*1e-3; % [kV]

I1 = single_data(ii_measurement).I1; % [A]
I2 = single_data(ii_measurement).I2; % [A]
I3 = single_data(ii_measurement).I3; % [A]


%SFT
% Specify the parameters of a signal with a sampling frequency of 1 kHz and a signal duration of 1.5 second                    
T = (t(2)-t(1));   % Sampling period 
Fs = 1/T;          % Sampling frequency
L = length(t);     % Length of signal

figure;

% Choose a wavelet. 'db1' specifies the Daubechies wavelet of order 1
waveletName = 'db1';

% Define level for DWT decomposition
level = 5;

% Plot for Current I1
subplot(3,2,1);
[c1,l1] = wavedec(I1, level, waveletName);
plot(c1); 
title('DWT of Current I1');

% Plot for Current I2
subplot(3,2,3);
[c2,l2] = wavedec(I2, level, waveletName);
plot(c2); 
title('DWT of Current I2');

% Plot for Current I3
subplot(3,2,5);
[c3,l3] = wavedec(I3, level, waveletName);
plot(c3); 
title('DWT of Current I3');

% Plot for Voltage U12
subplot(3,2,2);
[c4,l4] = wavedec(U12, level, waveletName);
plot(c4); 
title('DWT of Voltage U12');

% Plot for Voltage U23
subplot(3,2,4);
[c5,l5] = wavedec(U23, level, waveletName);
plot(c5); 
title('DWT of Voltage U23');

% Plot for Voltage U31
subplot(3,2,6);
[c6,l6] = wavedec(U31, level, waveletName);
plot(c6); 
title('DWT of Voltage U31');
