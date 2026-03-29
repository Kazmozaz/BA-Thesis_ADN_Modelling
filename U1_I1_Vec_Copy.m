% Evaluation of high-resolution measurement data of the research project
% with U-I_Diagrams
% "self-regulating effect"
% 22.07.2023 - Verion 1 - Kareem Hassan (IFK)

clc
clear all

%% Load measurement data from mat-file
load('Z:\Daten\Netzselbstregeleffekt\UW_Osterburken\UW Osterburken_001_20170517_10240HzOszilloskop.mat')


num_measurements = 10;  % Or whatever your actual number of measurements is

% Preallocate Input Vectors
areas = zeros(num_measurements, 1);
residuals = zeros(num_measurements, 1);
middle_slopes = zeros(num_measurements, 1);
I_maxes = zeros(num_measurements, 1);
I_mins = zeros(num_measurements, 1);
num_spins_all = zeros(num_measurements, 1);

% Preallocate Ouput Vectors

suns = zeros(num_measurements, 1);
winds = zeros(num_measurements, 1);
w_enrgs = zeros(num_measurements, 1);
biogas_all = zeros(num_measurements, 1);
pv_enrgs = zeros(num_measurements, 1);
combined_dates = cell(num_measurements, 1);


for ii_measurement = 1:num_measurements


     t         = single_data(ii_measurement).t;                      %für Schickhardtschule, Osterburken
    %t        = single_data(ii_measurement).t.*2;                   %für Rest
    zeit      = single_data(ii_measurement).uhrzeit_string;
    tag       = single_data(ii_measurement).datums_tag_int;
    monat     = single_data(ii_measurement).monat_int;
    jahr      = single_data(ii_measurement).jahr;
    wochentag = single_data(ii_measurement).tag_int;

    % Combine tag, monat, jahr and zeit into a single datetime
    combined_date_str = [num2str(ii_measurement) '_' num2str(jahr) '/' num2str(monat) '/' num2str(tag) ' ' zeit];
    combined_date = datetime(combined_date_str, 'InputFormat', 'd_yyyy/MM/dd HH:mm:ss');


    ereignis = single_data(ii_measurement).pqf_ereignis;
    sun      = single_data(ii_measurement).sun;
    wind     = single_data(ii_measurement).wind;
    w_enrg   = single_data(ii_measurement).wind_W/1e6;              
    biogas   = single_data(ii_measurement).biogas_W/1e6;         
    pv_enrg  = single_data(ii_measurement).pv_W/1e6;


    %normierte Sternspannung
    % --> Eppingen, Osterburken, Obersteinach: (25MVA) 110/20kV
    % --> Schickhardtschule: (40MVA) 110/10kV
    U1N = (single_data(ii_measurement).U1.*1e-3)/10; % [kV]
    U2N = (single_data(ii_measurement).U2.*1e-3)/10; % [kV]
    U3N = (single_data(ii_measurement).U3.*1e-3)/10; % [kV]

    %normierter Strom
    In = 25000/20;    % für Eppingen, Osterburken, Obersteinach
    %In = 40000/10;   % für Schickhardtschule

    I1N = (single_data(ii_measurement).I1)/In; % [A]
    I2N = (single_data(ii_measurement).I2)/In; % [A]
    I3N = (single_data(ii_measurement).I3)/In; % [A]


    %% Compute the enclosed area, non-linearity, slope, highest and lowest points of I, and num_spins here...

    % means of I and V
    nP=t(end)/20e-3; %Anzahl der Perioden
    nP=ceil(nP);
    nE=length(t)-mod(length(t),nP);
    U1N_M=reshape(U1N(1:nE),[],nP); 
    I1N_M=reshape(I1N(1:nE),[],nP); 

    nS= 1:10;%nP;  --> looking at the first 10 seconds of event
    % Per=size()
    U1N_m=mean(U1N_M(:,nS),2); %mean of U1N
    I1N_m=mean(I1N_M(:,nS),2); %mean of I1N  
    % (nP-20:nP,: )

   
    % Compute non-linearity by fitting a line and computing residuals
    p = polyfit(U1N_m, I1N_m, 1);        % Fit line
    yfit = p(1)*U1N_m + p(2);            % Compute fitted values
    residual = norm((I1N_m - yfit),1);   % Compute residuals
    
    
    % Compute the slope of the middle segment (assuming you know the indices of the middle segment)
    middle_p = polyfit(U1N_m, I1N_m, 1);
    middle_slope = middle_p(1);

    % Compute the highest and lowest points of I
    I_max = max(I1N);
    I_min = min(I1N);

    % Compute the enclosed area
    area = polyarea(U1N, I1N);  

    % Compute the angle of each point with the positive x-axis
    angles = atan2(I1N_m, U1N_m);  % in radians

    % Normalize the angles to [0, 2*pi)
    angles = mod(angles, 2*pi);

    % Compute the differences between consecutive angles
    angle_diffs = diff(angles);

    % Correct for jumps from near 2*pi to near 0
    corrected_angle_diffs = mod(angle_diffs + pi, 2*pi) - pi;

    % Count the number of spins by summing the corrected angle differences and dividing by 2*pi
    num_spins = round(sum(corrected_angle_diffs) / (2*pi));


    %Store input vectors
    areas(ii_measurement) = area;  
    residuals(ii_measurement) = residual;
    middle_slopes(ii_measurement) = middle_slope;
    I_maxes(ii_measurement) = I_max;
    I_mins(ii_measurement) = I_min;  
    num_spins_all(ii_measurement) = num_spins;

      
end

% Storing all input and output vectors in cell arrays
input_vectors = {areas, residuals, middle_slopes, I_maxes, I_mins, num_spins_all};
output_vectors = {combined_dates, suns, pv_enrgs, winds, w_enrgs, biogas_all};

% Names of the vectors for printing purposes
input_names = {'areas', 'residuals', 'middle_slopes', 'I_maxes', 'I_mins', 'num_spins'};
output_names = {'Date', 'Sun', 'Solarenergy', 'Wind', 'Windenergy', 'Biogasenergy'};

% Iterate over each combination of input and output vector
for ii_input = 1:length(input_vectors)
    for ii_output = 1:length(output_vectors)
        % Open a file for writing
        filename = [input_names{ii_input}, '_vs_', output_names{ii_output}, '.txt'];
        fid = fopen(filename, 'w');
        
        % Print the header to the file
        fprintf(fid, 'Date: %-25s Wochentag: %-15s Input: %-15s Output: %s\n', combined_dates{ii_measurement}, num2str(wochentags(ii_measurement)), input_names{ii_input}, output_names{ii_output});
        
        % Print the date vector to the file
        fprintf(fid, '\n%-30s %-20s %-20s %-20s\n', 'Date vector:', 'Wochentag:', 'Input vector:', 'Output vector:');
        
        % Determine the length of the shorter vector
        min_length = min(length(input_vectors{ii_input}), length(output_vectors{ii_output}));
        
        % Print the date, wochentag, input and output vectors to the file side by side
        for i = 1:min_length
            if iscell(output_vectors{ii_output})
                fprintf(fid, '%-30s %-20d %-20f %-20s\n', combined_dates{i}, wochentags(i), input_vectors{ii_input}(i), output_vectors{ii_output}{i});
            else
                fprintf(fid, '%-30s %-20d %-20f %-20f\n', combined_dates{i}, wochentags(i), input_vectors{ii_input}(i), output_vectors{ii_output}(i));
            end
        end
        
        % Close the file
        fclose(fid);
    end
end
