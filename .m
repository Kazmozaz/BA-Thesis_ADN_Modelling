% Evaluation of high-resolution measurement data of the research project
% with U-I_Diagrams
% "self-regulating effect"
% 27.04.2021 - Verion 1 - Christian Schoell (IFK)

clc
clear all

%% Load measurement data from mat-file
load('Z:\Daten\Netzselbstregeleffekt\UW_Schickhardtschule\UW_Schickhardtschule_113_20180913_10240HzOszilloskop.mat')

% loop through each measurement in the dataset
%for ii_measurement = 1:85
for ii_measurement = [1:80,294,295,367,512,514]

    %t        = single_data(ii_measurement).t.*2;            %für Rest
    t        = single_data(ii_measurement).t;                %für Schickhardtschule, Osterburken
    zeit     = single_data(ii_measurement).uhrzeit_string;
    tag      = single_data(ii_measurement).datums_tag_int;
    monat    = single_data(ii_measurement).monat_int;
    jahr     = single_data(ii_measurement).jahr;
    ereignis = single_data(ii_measurement).pqf_ereignis;
    sun      = single_data(ii_measurement).sun;
    wind     = single_data(ii_measurement).wind;
    w_enrg   = single_data(ii_measurement).wind_W;           %Osterburken   
    biogas   = single_data(ii_measurement).biogas_W;         %Osterburken
    pv_enrg  = single_data(ii_measurement).pv_W;

    % Convert to mega unit
    w_enrg  = w_enrg/1e6; 
    biogas  = biogas/1e6;
    pv_enrg = pv_enrg/1e6;

    % Convert to decimal format with 2 decimal places
    w_enrg = sprintf('%.2f', w_enrg);
    biogas = sprintf('%.2f', biogas);
    pv_enrg = sprintf('%.2f', pv_enrg);

    % Sternspannung
    U1 = single_data(ii_measurement).U1.*1e-3; % [kV]
    U2 = single_data(ii_measurement).U2.*1e-3; % [kV]
    U3 = single_data(ii_measurement).U3.*1e-3; % [kV]

    %normierte Sternspannung 
    % --> Eppingen, Osterburken, Obersteinach: (25MVA) 110/20kV
    % --> Schickhardtschule,   : (40MVA) 110/10kV
    U1N = U1/10;
    U2N = U2/10;
    U3N = U3/10;


    % Strom
    I1 = single_data(ii_measurement).I1; % [A]
    I2 = single_data(ii_measurement).I2; % [A]
    I3 = single_data(ii_measurement).I3; % [A]

    % normierter Strom
    %In = 25000/20;    % für Eppingen, Osterburken, Obersteinach
    In = 40000/10;   % für Schickhardtschule

    I1N = I1/In;
    I2N = I2/In;
    I3N = I3/In;

    %% Plot measurement data and VI-diagrams
    figure(ii_measurement)
    clf 

    plot(U2N,I2N); hold on
    xlabel('{\itU_{2N}}')
    ylabel('{\itI_{2N}}')
    txt = sprintf('Schickhardtschule\n%s   %d.0%d.%d\n%s\n Sun: %.2fmin/h,  Sunenergy:%s MW\nWind:%.2fm/s ,  Windenergy:%s MW\n   Biogasenergy:%s MW', zeit, tag, monat, jahr, ereignis, sun,pv_enrg, wind, w_enrg, biogas);
    title(txt)
    grid on

    %Save the figure
    saveas(gcf, sprintf('U2_I2_Diagram_SKS_%d.png', ii_measurement));

    %Close the figure to free up memory
    close(gcf);

end
