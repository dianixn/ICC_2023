% Parameters

M = 4; % QPSK
k = log2(M);

Num_of_subcarriers = 71; 
Num_of_FFT = Num_of_subcarriers + 1; % 5G also deploy DC subcarrier, so dont remove DC
length_of_CP = 7 + 8;

Num_of_symbols = 10;
Num_of_pilot = 4;
Frame_size = Num_of_symbols + Num_of_pilot;

Pilot_location_symbols = [3, 6, 9, 12];
Pilot_location = [(2 : 2 : Num_of_FFT)', (2 : 2 : Num_of_FFT)', (2 : 2 : Num_of_FFT)', (2 : 2 : Num_of_FFT)'];
Pilot_value_user = 1 + 1j;

length_of_symbol = Num_of_FFT + length_of_CP;

Frequency_Spacing = 15e3;

Carrier_Frequency = 2.1e9;
Max_Mobile_Speed = 50; % km/h

SampleRate = Num_of_subcarriers * Frequency_Spacing;

MaxDopplerShift = floor((Carrier_Frequency * Max_Mobile_Speed) / (3e8 * 3.6));

DelayProfile = 'CDL-A'; % 'Custom' 'CDL-A' 'CDL-B' 'CDL-C' 
