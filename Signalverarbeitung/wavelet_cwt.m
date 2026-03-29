% Evaluation of high-resolution measurement data of the research project
% with Continuous Wavelet Transform
% "self-regulating effect"
% 
% 24.06.2023 - Verion 1 - Kareem Hassan (IFK)

clc
clear all

%% Measurement data from mat-file

load('Z:\Daten\Netzselbstregeleffekt\UW_Schickhardtschule\UW_Schickhardtschule_113_20180913_10240HzOszilloskop.mat')

ii_measurement = 99; % choose entry of the measurement-struct single_data 

t = single_data(ii_measurement).t;

U12 = single_data(ii_measurement).U12.*1e-3; % [kV]
U23 = single_data(ii_measurement).U23.*1e-3; % [kV]
U31 = single_data(ii_measurement).U31.*1e-3; % [kV]

I1 = single_data(ii_measurement).I1; % [A]
I2 = single_data(ii_measurement).I2; % [A]
I3 = single_data(ii_measurement).I3; % [A]

T = (t(2)-t(1));   % Sampling period 
Fs = 1/T;          % Sampling frequency
L = length(t);     % Length of signal

figure;

f_range = [0 60];

% Choose a wavelet.
waveletName = 'mexh';

% Plot for Current I1
subplot(3,2,1);
[cfs1,frequencies1] = cwt(I1,waveletName,Fs,'VoicesPerOctave',48);
imagesc(t,frequencies1,abs(cfs1)); axis tight; set(gca, 'YScale', 'log');
title('CWT of Current I1');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim(f_range);

% Plot for Current I2
subplot(3,2,3);
[cfs2,frequencies2] = cwt(I2,waveletName,Fs,'VoicesPerOctave',48);
imagesc(t,frequencies2,abs(cfs2)); axis tight; set(gca, 'YScale', 'log'); 
title('CWT of Current I2');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim(f_range);


% Plot for Current I3
subplot(3,2,5);
[cfs3,frequencies3] = cwt(I3,waveletName,Fs,'VoicesPerOctave',48);
imagesc(t,frequencies3,abs(cfs3)); axis tight; set(gca, 'YScale', 'log'); 
title('CWT of Current I3');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim(f_range);


% Plot for Voltage U12
subplot(3,2,2);
[cfs4,frequencies4] = cwt(U12,waveletName,Fs,'VoicesPerOctave',48);
imagesc(t,frequencies4,abs(cfs4)); axis tight; set(gca, 'YScale', 'log'); 
title('CWT of Voltage U12');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim(f_range);


% Plot for Voltage U23
subplot(3,2,4);
[cfs5,frequencies5] = cwt(U23,waveletName,Fs,'VoicesPerOctave',48);
imagesc(t,frequencies5,abs(cfs5)); axis tight; set(gca, 'YScale', 'log');
title('CWT of Voltage U23');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim(f_range);


% Plot for Voltage U31
subplot(3,2,6);
[cfs6,frequencies6] = cwt(U31,waveletName,Fs,'VoicesPerOctave',48);
imagesc(t,frequencies6,abs(cfs6)); axis tight; set(gca, 'YScale', 'log'); 
title('CWT of Voltage U31');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim(f_range);


