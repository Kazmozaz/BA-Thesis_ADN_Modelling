clc
clear all


%% Load measurement data from mat-file    

load("Z:\Daten\Netzselbstregeleffekt\UW_Osterburken\UW Osterburken_001_20170517_10240HzOszilloskop.mat");
for ii_measurement = 1:length(single_data)


    t         = single_data(ii_measurement).t;                      %für Schickhardtschule, Osterburken
    %t        = single_data(ii_measurement).t.*2;                   %für Rest
    zeit      = single_data(ii_measurement).uhrzeit_string;
    tag       = single_data(ii_measurement).datums_tag_int;
    monat     = single_data(ii_measurement).monat_int;
    jahr      = single_data(ii_measurement).jahr;
    wochentag = single_data(ii_measurement).tag_int;


    ereignis = single_data(ii_measurement).pqf_ereignis;
    sun      = single_data(ii_measurement).sun;
    wind     = single_data(ii_measurement).wind;
    w_enrg   = single_data(ii_measurement).wind_W/1e6;              
    biogas   = single_data(ii_measurement).biogas_W/1e6;         
    pv_enrg  = single_data(ii_measurement).pv_W/1e6;


    %normierte Sternspannung
    % --> Eppingen, Osterburken, Obersteinach: (25MVA) 110/20kV
    % --> Schickhardtschule: (40MVA) 110/10kV
    U1N = (single_data(ii_measurement).U1.*1e-3)/20; % [kV]
    U2N = (single_data(ii_measurement).U2.*1e-3)/20; % [kV]
    U3N = (single_data(ii_measurement).U3.*1e-3)/20; % [kV]

    %normierter Strom
    In = 25000/20;    % für Eppingen, Osterburken, Obersteinach
    %In = 40000/10;   % für Schickhardtschule

    I1N = (single_data(ii_measurement).I1)/In; % [A]
    I2N = (single_data(ii_measurement).I2)/In; % [A]
    I3N = (single_data(ii_measurement).I3)/In; % [A]

end


nP=t(end)/20e-3; %Anzahl der Perioden
nP=ceil(nP);
nE=length(t)-mod(length(t),nP);
U1N_M=reshape(U1N(1:nE),[],nP); 
I1N_M=reshape(I1N(1:nE),[],nP); 



nS= 1:10;%nP;  --> looking at the first 10 periods of event
% Per=size()
U1N_m=mean(U1N_M(:,nS),2); %mean of U1N
I1N_m=mean(I1N_M(:,nS),2); %mean of I1N  
% (nP-20:nP,: )

aS=polyfit(U1N_m,I1N_m,1); %*
xv=[min(U1N),max(U1N)];
I1lin=aS(1)*U1N_m+aS(2); %yfit

aSNl=polyfit(U1N_m,I1N_m,13);


I1nl=polyval(aSNl,U1N_m);

I1res=I1N_m-I1lin;
norm(I1res,1);


figure;
subplot 311
plot(U1N,I1N,'k--','linewidth',1)
hold on;
plot(U1N_m,I1N_m,'b','linewidth',2)

grid minor


nS= nP-10:nP;%nP; --> looking at the last 10 periods of event
% Per=size()
U1N_m=mean(U1N_M(:,nS),2);
I1N_m=mean(I1N_M(:,nS),2);  % (nP-20:nP,: )


aE=polyfit(U1N_m,I1N_m,1);

subplot 312
plot(U1N,I1N,'k--','linewidth',1)
hold on;
plot(U1N_m,I1N_m,'b','linewidth',2)

grid minor

subplot 313
plot(U1N_m,I1res,'k--','linewidth',1)
hold on;
plot(U1N_m,I1nlres,'r--','linewidth',1)

grid minor


