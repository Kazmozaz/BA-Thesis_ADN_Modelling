% Evaluation of high-resolution measurement data of the research project
% with U-I_Diagrams
% "self-regulating effect"
% 22.07.2023 - Verion 1 - Kareem Hassan (IFK)

clc
clear all

%% Load measurement data from mat-file
load('Z:\Daten\Netzselbstregeleffekt\UW_Osterburken\UW Osterburken_001_20170517_10240HzOszilloskop.mat')

% Initialize results matrix
input  = [];
output = {};

for ii_measurement = 1:10
%for ii_measurement = [1:80,294,295,367,512,514]

    t  = single_data(ii_measurement).t;                      %für Schickhardtschule, Osterburken
    %t = single_data(ii_measurement).t.*2;                   %für Rest
    zeit     = single_data(ii_measurement).uhrzeit_string;
    tag      = single_data(ii_measurement).datums_tag_int;
    monat    = single_data(ii_measurement).monat_int;
    jahr     = single_data(ii_measurement).jahr;

    % Combine tag, monat, jahr and zeit into a single datetime
    combined_date = datetime([num2str(jahr), '/', num2str(monat), '/', num2str(tag), ' ', zeit], 'InputFormat', 'yyyy/MM/dd HH:mm:ss');


    ereignis = single_data(ii_measurement).pqf_ereignis;
    sun      = single_data(ii_measurement).sun;
    wind     = single_data(ii_measurement).wind;
    w_enrg   = single_data(ii_measurement).wind_W/1e6;           %Osterburken   
    biogas   = single_data(ii_measurement).biogas_W/1e6;         %Osterburken
    pv_enrg  = single_data(ii_measurement).pv_W/1e6;

    % Convert to decimal format with 2 decimal places
    w_enrg  = sprintf('%.2f', w_enrg);
    biogas  = sprintf('%.2f', biogas);
    pv_enrg = sprintf('%.2f', pv_enrg);

    %Sternspannung
    U1 = single_data(ii_measurement).U1.*1e-3; % [kV]
    U2 = single_data(ii_measurement).U2.*1e-3; % [kV]
    U3 = single_data(ii_measurement).U3.*1e-3; % [kV]

    %normierte Sternspannung 
    % --> Eppingen, Osterburken, Obersteinach: (25MVA) 110/20kV
    % --> Schickhardtschule,   : (40MVA) 110/10kV
    U1N = U1/10;
    U2N = U2/10;
    U3N = U3/10;

    %Strom
    I1 = single_data(ii_measurement).I1; % [A]
    I2 = single_data(ii_measurement).I2; % [A]
    I3 = single_data(ii_measurement).I3; % [A]

    % normierter Strom
    %In = 25000/20;    % für Eppingen, Osterburken, Obersteinach
    In = 40000/10;   % für Schickhardtschule

    I1N = I1/In;
    I2N = I2/In;
    I3N = I3/In;


    %% Compute the enclosed area, non-linearity, slope, highest and lowest points of I, and num_spins here...

    % Compute the enclosed area
    area = polyarea(U1N, I1N);  % Replace U1N and I1N with the appropriate variables for your case

    % Compute non-linearity by fitting a line and computing residuals
    p = polyfit(U1N, I1N, 1);   % Fit line
    yfit = polyval(p, U1N);     % Compute fitted values
    residuals = I1N - yfit;     % Compute residuals
    % Convert to decimal format with 2 decimal places
    residuals = sprintf('%.2f', residuals);

    % Compute the slope of the middle segment (assuming you know the indices of the middle segment)
    middle_indices = (round(length(U1N)/4)):(round(3*length(U1N)/4));  % Update this as necessary
    middle_p = polyfit(U1N(middle_indices), I1N(middle_indices), 1);
    middle_slope = middle_p(1);

    % Compute the highest and lowest points of I
    I_max = max(I1N);
    I_min = min(I1N);

    % Compute the angle of each point with the positive x-axis
    angles = atan2(I1N, U1N);  % in radians

    % Normalize the angles to [0, 2*pi)
    angles = mod(angles, 2*pi);

    % Compute the differences between consecutive angles
    angle_diffs = diff(angles);

    % Correct for jumps from near 2*pi to near 0
    corrected_angle_diffs = mod(angle_diffs + pi, 2*pi) - pi;

    % Count the number of spins by summing the corrected angle differences and dividing by 2*pi
    num_spins = round(sum(corrected_angle_diffs) / (2*pi));

    % Add calculated values to results matrix
    input = [input; [area, mean(residuals), middle_slope, I_max, I_min, num_spins]];

    % Append additional information to the cell array
    output = [output; {combined_date, sun, pv_enrg, wind, w_enrg, biogas}];

end

% Convert results to a cell array and add column headers
input = num2cell(input);
input_headers = {'area', 'non_linearity', 'slope', 'I_max', 'I_min', 'spins'};
input = [input_headers; input];

% Convert additional_info to a cell array and add column headers
output_headers = {'date', 'sun','pv_enrg', 'wind', 'w_enrg', 'biogas'};
output = [output_headers; output];

% Display the results
disp('Input Matrix:');
disp(input);

disp('Output Matrix:');
disp(output);

% Convert results to a table and add column headers
input_table = array2table(input, 'VariableNames', input_headers);

% Convert additional_info to a table and add column headers
output_table = cell2table(output, 'VariableNames', output_headers);

% Display the input table
figure; % Create a new figure that is not displayed
text(0, 0.5, evalc('disp(input_table)'), 'Interpreter', 'none', 'FontName', 'FixedWidth'); % Display the table as text
title('Input Table');
axis off; 
print('input_table.png', '-dpng'); 

% Display the output table
figure; % Create a new figure that is not displayed
text(0, 0.5, evalc('disp(output_table)'), 'Interpreter', 'none', 'FontName', 'FixedWidth'); % Display the table as text
title('Output Table'); % Set the title
axis off; % Turn off the axis
print('output_table.png', '-dpng'); % Save the figure as a PNG file

