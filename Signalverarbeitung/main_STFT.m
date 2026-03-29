% Evaluation of high-resolution measurement data of the research project
% with Short Fourier Transform
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

%Dreieckspannung
U12 = single_data(ii_measurement).U12.*1e-3; % [kV]
U23 = single_data(ii_measurement).U23.*1e-3; % [kV]
U31 = single_data(ii_measurement).U31.*1e-3; % [kV]

%Sternspannung
U1 = single_data(ii_measurement).U1.*1e-3; % [kV]
U2 = single_data(ii_measurement).U2.*1e-3; % [kV]
U3 = single_data(ii_measurement).U3.*1e-3; % [kV]

%normierte Sternspannung 
% --> Eppingen, Osterburken, Obersteinach: (25MVA) 110/20kV
% --> Schickhardtschule,   : (40MVA) 110/10kV
U1N = U1/20;
U2N = U2/20;
U3N = U3/20;

%Strom
I1 = single_data(ii_measurement).I1; % [A]
I2 = single_data(ii_measurement).I2; % [A]
I3 = single_data(ii_measurement).I3; % [A]

%normierter Strom
In = 25000/20;    %für Eppingen, Osterburken, Obersteinach
%In = 40000/20;   %für Schickhardtschule

I1N = I1/In;
I2N = I2/In;
I3N = I3/In;


%STFT
% Specify the parameters of a signal with a sampling frequency of 1 kHz and a signal duration of 1.5 second                    
T = (t(2)-t(1));   % Sampling period 
Fs = 1/T;          % Sampling frequency
L = length(t);     % Length of signal


%%Calculating STFT
window = hamming(128); % smaller window size
noverlap = 64;         % adjust overlap accordingly
nfft = 256;            % adjust FFT size accordingly

% Apply STFT to currents
fft_current1 = stft(I1, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);
fft_current2 = stft(I2, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);
fft_current3 = stft(I3, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);

% Apply STFT to voltages
fft_voltage1 = stft(U12, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);
fft_voltage2 = stft(U23, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);
fft_voltage3 = stft(U31, 'Window', window, 'OverlapLength', noverlap, 'FFTLength', nfft);


% Define your desired frequency range
f_range = [0 1]; % in kHz, change this to your desired range


%% Plotting the spectrogram

figure;

% Plot for Current I1
subplot(3,2,1);
spectrogram(I1, window, noverlap, nfft, Fs, 'yaxis'); % 'yaxis' for frequency in Hz
title('Spectrogram of Current I1');
ylim(f_range); % set the limits of y-axis

% Plot for Current I2
subplot(3,2,3);
spectrogram(I2, window, noverlap, nfft, Fs, 'yaxis');
title('Spectrogram of Current I2');
ylim(f_range); % set the limits of y-axis

% Plot for Current I3
subplot(3,2,5);
spectrogram(I3, window, noverlap, nfft, Fs, 'yaxis');
title('Spectrogram of Current I3');
ylim(f_range); % set the limits of y-axis

% Plot for Voltage U1
subplot(3,2,2);
spectrogram(U1, window, noverlap, nfft, Fs, 'yaxis');
title('Spectrogram of Voltage U1');
ylim(f_range); % set the limits of y-axis

% Plot for Voltage U2
subplot(3,2,4);
spectrogram(U2, window, noverlap, nfft, Fs, 'yaxis');
title('Spectrogram of Voltage U2');
ylim(f_range); % set the limits of y-axis

% Plot for Voltage U3
subplot(3,2,6);
spectrogram(U3, window, noverlap, nfft, Fs, 'yaxis');
title('Spectrogram of Voltage U3');
ylim(f_range); % set the limits of y-axis