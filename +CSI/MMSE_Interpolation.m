function H_MMSE = MMSE_Interpolation(MaxDopplerShift, SampleRate, length_of_symbol, Frame_size, H_Ref, RS, Pilot_location_symbols, Num_of_FFT, SNR, Num_of_pilot, H_LS)

H_MMSE = zeros(Num_of_FFT, Num_of_pilot);

MMSE_Time = [besselj(0,2 * pi * (MaxDopplerShift / SampleRate) * (length_of_symbol) * ([1 : 7]' - Pilot_location_symbols(1)));...
besselj(0,2 * pi * (MaxDopplerShift / SampleRate) * (length_of_symbol) * ([8 : Frame_size]' - Pilot_location_symbols(2)))];

for i = 1 : Frame_size
    
    if i <= 7
        H_pilot = H_Ref(:, 1);
        Rhh = H_pilot * H_pilot' * MMSE_Time(i);
        H_MMSE(:, i) = (RS(:, Pilot_location_symbols(1)) * (H_pilot') * MMSE_Time(i)) * pinv((Rhh * MMSE_Time(i)) + (1 / 10^(SNR / 10)) * eye(size(Rhh, 1))) * H_LS(:, 1);      
    else
        H_pilot = H_Ref(:, 2);
        Rhh = H_pilot * H_pilot' * MMSE_Time(i);
        H_MMSE(:, i) = (RS(:, Pilot_location_symbols(2)) * (H_pilot') * MMSE_Time(i)) * pinv((Rhh * MMSE_Time(i)) + (1 / 10^(SNR / 10)) * eye(size(Rhh, 1))) * H_LS(:, 2);
    end
    
end
