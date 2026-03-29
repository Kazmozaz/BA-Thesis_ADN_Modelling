% Evaluation of high-resolution measurement data of the research project
% with Fast Fourier Transform
% "self-regulating effect"
% 
% 24.06.2023 - Verion 1 - Kareem Hassan (IFK)

clc
clear all

%% Measurement data from mat-file

load('Z:\Daten\Netzselbstregeleffekt\UW_Obersteinach\UW_Obersteinach_20160406_10240HzOszilloskop.mat')

ii_measurement = 99; % choose entry of the measurement-struct single_data 

%if ...
t = single_data(ii_measurement).t*2; % watch out for wrong time-values, frequency must be around 50 Hz
%end

%t = single_data(ii_measurement).t;


U12 = single_data(ii_measurement).U12.*1e-3; % [kV]
U23 = single_data(ii_measurement).U23.*1e-3; % [kV]
U31 = single_data(ii_measurement).U31.*1e-3; % [kV]

I1 = single_data(ii_measurement).I1; % [A]
I2 = single_data(ii_measurement).I2; % [A]
I3 = single_data(ii_measurement).I3; % [A]


%FFT
% Specify the parameters of a signal with a sampling frequency of 1 kHz and a signal duration of 1.5 second                    

%specifies time snippets
start  = 1;
finish = 10000;

t   = t(start:finish);
I1  = I1(start:finish);
I2  = I2(start:finish);
I3  = I3(start:finish);
U12 = U12(start:finish);
U23 = U23(start:finish);
U31 = U31(start:finish);


T = (t(2)-t(1));   % Sampling period 
Fs = 1/T;          % Sampling frequency
L = length(t);     % Length of signal


%%Calculating FFT
% Apply FFT to currents
fft_current1 = fft(I1);
fft_current2 = fft(I2);
fft_current3 = fft(I3);

% Apply FFT to voltages
fft_voltage1 = fft(U12);
fft_voltage2 = fft(U23);
fft_voltage3 = fft(U31);

%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L
%I1
I1_P2 = abs(fft_current1/L);
I1_P1 = I1_P2(1:L/2+1);
I1_P1(2:end-1) = 2*I1_P1(2:end-1);

%I2
I2_P2 = abs(fft_current2/L);
I2_P1 = I1_P2(1:L/2+1);
I2_P1(2:end-1) = 2*I2_P1(2:end-1);

%I3
I3_P2 = abs(fft_current3/L);
I3_P1 = I3_P2(1:L/2+1);
I3_P1(2:end-1) = 2*I3_P1(2:end-1);


%Plot measurements with FFT data for currents
figure(1)
unit_I ='A';
clf

%Plot I1
ii_plot = 1;
sb(ii_plot) = subplot(2,3,ii_plot);
ax(ii_plot) = plot(t,I1); hold on
xlabel('{\itt} in s')
ylabel(['{\itI_{1}} in ',unit_I])
grid on

%Plot I2
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
ax(ii_plot) = plot(t,I2); hold on
xlabel('{\itt} in s')
ylabel(['{\itI_{2}} in ',unit_I])
grid on

%Plot I3
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
ax(ii_plot) = plot(t,I3); hold on
xlabel('{\itt} in s')
ylabel(['{\itI_{3}} in ',unit_I])
grid on

%Plot of FFT I1
ii_plot = ii_plot +1;
sb(ii_plot) = subplot(2,3,ii_plot);
f = Fs*(0:(L/2))/L;
ax(ii_plot) = semilogy(f,I1_P1); hold on
title("")
xlabel("f(Hz)")
ylabel("|P1(f)|")
xlim([0,500])
grid on

%Plot of FFT I2
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
f = Fs*(0:(L/2))/L;
ax(ii_plot) = semilogy(f,I2_P1); hold on
title("")
xlabel("f(Hz)")
ylabel("|P1(f)|")
xlim([0,500])
grid on

%Plot of FFT I3
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
f = Fs*(0:(L/2))/L;
ax(ii_plot) = semilogy(f,I3_P1); hold on
title("")
xlabel("f(Hz)")
ylabel("|P1(f)|")
xlim([0,500])
grid on


%Compute the two-sided spectrum of voltages
%U12
U12_P2 = abs(fft_voltage1/L);
U12_P1 = U12_P2(1:L/2+1);
U12_P1(2:end-1) = 2*U12_P1(2:end-1);

%U23
U23_P2 = abs(fft_voltage2/L);
U23_P1 = U23_P2(1:L/2+1);
U23_P1(2:end-1) = 2*U23_P1(2:end-1);

%U31
U31_P2 = abs(fft_voltage3/L);
U31_P1 = U31_P2(1:L/2+1);
U31_P1(2:end-1) = 2*U31_P1(2:end-1);

%Plot measurements with FFT data for voltages
figure(2)
unit_U ='kV';
clf

%Plot U13
ii_plot = 1;
sb(ii_plot) = subplot(2,3,ii_plot);
ax(ii_plot) = plot(t,U12); hold on
xlabel('{\itt} in s')
ylabel(['{\itU_{13}} in ',unit_U])
grid on

%Plot U23
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
ax(ii_plot) = plot(t,U23); hold on
xlabel('{\itt} in s')
ylabel(['{\itU_{23}} in ',unit_U])
grid on

%Plot U31
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
ax(ii_plot) = plot(t,U31); hold on
xlabel('{\itt} in s')
ylabel(['{\itU_{31}} in ',unit_U])
grid on

%Plot of FFT U12
ii_plot = ii_plot +1;
sb(ii_plot) = subplot(2,3,ii_plot);
f = Fs*(0:(L/2))/L;
ax(ii_plot) = semilogy(f,U12_P1); hold on
title("U12")
xlabel("f(Hz)")
ylabel("|P1(f)|")
xlim([0,500])
grid on

%Plot of FFT U23
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
f = Fs*(0:(L/2))/L;
ax(ii_plot) = semilogy(f,U23_P1); hold on
title("U23")
xlabel("f(Hz)")
ylabel("|P1(f)|")
xlim([0,500])
grid on

%Plot of FFT U31
ii_plot = ii_plot + 1;
sb(ii_plot) = subplot(2,3,ii_plot);
f = Fs*(0:(L/2))/L;
ax(ii_plot) = semilogy(f,U31_P1); hold on
title("U31")
xlabel("f(Hz)")
xlim([0,500])
ylabel("|P1(f)|")
grid on
