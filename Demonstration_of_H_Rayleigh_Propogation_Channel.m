SNR_Range = 15; % 15
Num_of_frame_each_SNR = 5000;

MSE_LS_over_SNR = zeros(length(SNR_Range), 1);
MSE_MMSE_over_SNR = zeros(length(SNR_Range), 1);
MSE_DNN_over_SNR = zeros(length(SNR_Range), 1);
MSE_HA02_over_SNR = zeros(length(SNR_Range), 1);

% Import Deep Neuron Network
load('InterpolateResNet_LOS.mat'); 

% Import HA02 Network
load('parameters_LOS.mat');

for SNR = SNR_Range
    
M = 4; % QPSK
k = log2(M);

Parameter.parameters

Num_of_QPSK_symbols = Num_of_FFT * Num_of_symbols * Num_of_frame_each_SNR;
Num_of_bits = Num_of_QPSK_symbols * k;

LS_MSE_in_frame = zeros(Num_of_frame_each_SNR, 1);
MMSE_MSE_in_frame = zeros(Num_of_frame_each_SNR, 1);
DNN_MSE_in_frame = zeros(Num_of_frame_each_SNR, 1);
HA02_MSE_in_frame = zeros(Num_of_frame_each_SNR, 1);

Frame_error_LS = 0;
Frame_error_MMSE = 0;
Frame_error_DNN = 0;
Frame_error_HA02 = 0;

for Frame = 1 : Num_of_frame_each_SNR

% Data generation
N = Num_of_FFT * Num_of_symbols;
data = randi([0 1], N, k);
Data = reshape(data, [], 1);
dataSym = bi2de(data);

% QPSK modulator
QPSK_symbol = OFDM.QPSK_Modualtor(dataSym);
QPSK_signal = reshape(QPSK_symbol, Num_of_FFT, Num_of_symbols);

% Pilot inserted
[data_in_IFFT, data_location] = OFDM.Pilot_Insert(Pilot_value_user, Pilot_location_symbols, Pilot_location, Frame_size, Num_of_FFT, QPSK_signal);
[data_for_channel, ~] = OFDM.Pilot_Insert(1, Pilot_location_symbols, kron((1 : Num_of_FFT)', ones(1, Num_of_pilot)), Frame_size, Num_of_FFT, (ones(Num_of_FFT, Num_of_symbols)));

% OFDM Transmitter
[Transmitted_signal, ~] = OFDM.OFDM_Transmitter(data_in_IFFT, Num_of_FFT, length_of_CP);
[Transmitted_signal_for_channel, ~] = OFDM.OFDM_Transmitter(data_for_channel, Num_of_FFT, length_of_CP);

% Channel

SNR_OFDM = SNR + 10 * log10((Num_of_subcarriers / Num_of_FFT));
Doppler_shift = randi([0, MaxDopplerShift]);
[Multitap_Channel_Signal, Multitap_Channel_Signal_user, Multitap_Channel_Signal_user_for_channel] = Channel.Propagation_Channel_Model(Transmitted_signal, Transmitted_signal_for_channel, SNR_OFDM, SampleRate, Carrier_Frequency, PathDelays, AveragePathGains, Doppler_shift, DelayProfile);

% OFDM Receiver
[Unrecovered_signal, RS_User] = OFDM.OFDM_Receiver(Multitap_Channel_Signal, Num_of_FFT, length_of_CP, length_of_symbol, Multitap_Channel_Signal_user);
[~, RS] = OFDM.OFDM_Receiver(Multitap_Channel_Signal_user_for_channel, Num_of_FFT, length_of_CP, length_of_symbol, Multitap_Channel_Signal_user_for_channel);

[Received_pilot, ~] = OFDM.Pilot_extract(RS_User, Pilot_location, Num_of_pilot, Pilot_location_symbols, data_location);
H_Ref = Received_pilot ./ Pilot_value_user;

% Channel estimation

% LS
[Received_pilot_LS, ~] = OFDM.Pilot_extract(Unrecovered_signal, Pilot_location, Num_of_pilot, Pilot_location_symbols, data_location);

tStart_LS = tic;

H_LS = CSI.LS(Received_pilot_LS, Pilot_value_user);

H_LS_frame = imresize(H_LS, [Num_of_FFT, max(Pilot_location_symbols)]);
H_LS_frame(:, max(Pilot_location_symbols) + 1 : Frame_size) = kron(H_LS_frame(:, max(Pilot_location_symbols)), ones(1, Frame_size - max(Pilot_location_symbols)));

MSE_LS_frame = mean(abs(H_LS_frame - RS).^2, 'all');

% MMSE

% linear MMSE

H_MMSE = CSI.MMSE(H_Ref, RS, Pilot_location, Pilot_location_symbols, Num_of_FFT, SNR, Num_of_pilot, H_LS);

H_MMSE_frame = imresize(H_MMSE, [Num_of_FFT, max(Pilot_location_symbols)]);
H_MMSE_frame(:, max(Pilot_location_symbols) + 1 : Frame_size) = kron(H_MMSE_frame(:, max(Pilot_location_symbols)), ones(1, Frame_size - max(Pilot_location_symbols)));

%H_MMSE_frame = CSI.MMSE_Interpolation(Doppler_shift, SampleRate, length_of_symbol, Frame_size, H_Ref, RS, Pilot_location_symbols, Num_of_FFT, SNR, Num_of_pilot, H_LS);

MSE_MMSE_frame = mean(abs(H_MMSE_frame - RS).^2, 'all');

% Deep learning

Res_feature_signal(:, :, 1) = real(H_LS);
Res_feature_signal(:, :, 2) = imag(H_LS);

H_DNN_feature = predict(DNN_Trained, Res_feature_signal);

H_DNN_frame = H_DNN_feature(:, :, 1) + 1j * H_DNN_feature(:, :, 2);

MSE_DNN_frame = mean(abs(H_DNN_frame - RS).^2, 'all');

% HA02

Feature_signal(:, 1, 1) = reshape(real(H_LS), [], 1);
Feature_signal(:, 2, 1) = reshape(imag(H_LS), [], 1);
Feature_signal = dlarray(Feature_signal);

H_HA02_feature = transformer_HA02.model(Feature_signal, parameters);

H_HA02_frame = reshape(extractdata(H_HA02_feature(:, 1)), Num_of_FFT, Frame_size) + 1j * reshape(extractdata(H_HA02_feature(:, 2)), Num_of_FFT, Frame_size);

MSE_HA02_frame = mean(abs(H_HA02_frame - RS).^2, 'all');

% LS MSE calculation in each frame
LS_MSE_in_frame(Frame, 1) = MSE_LS_frame;

% MMSE MSE calculation in each frame
MMSE_MSE_in_frame(Frame, 1) = MSE_MMSE_frame;

% DNN MSE calculation in each frame
DNN_MSE_in_frame(Frame, 1) = MSE_DNN_frame;

% HA02 MSE calculation in each frame
HA02_MSE_in_frame(Frame, 1) = MSE_HA02_frame;

end

% MSE calculation
MSE_LS_over_SNR(SNR_Range == SNR, 1) = sum(LS_MSE_in_frame, 1) / Num_of_frame_each_SNR;

MSE_MMSE_over_SNR(SNR_Range == SNR, 1) = sum(MMSE_MSE_in_frame, 1) / Num_of_frame_each_SNR;

MSE_DNN_over_SNR(SNR_Range == SNR, 1) = sum(DNN_MSE_in_frame, 1) / Num_of_frame_each_SNR;

MSE_HA02_over_SNR(SNR_Range == SNR, 1) = sum(HA02_MSE_in_frame, 1) / Num_of_frame_each_SNR;

end
