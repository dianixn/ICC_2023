%CDL Channel Model

function [Fading_signal, Fading_signal_noise_free, Reference_Signal] = CDL_Channel(Transmitted_signal, Transmitted_signal_for_channel, SNR, SampleRate, Carrier_Frequency, MaxDopplerShift, DelayProfile, DelaySpread, PathDelays, AveragePathGains)

cdl = nrCDLChannel;
cdl.DelayProfile = DelayProfile;
cdl.MaximumDopplerShift = MaxDopplerShift;
cdl.SampleRate = SampleRate;
cdl.DelaySpread = DelaySpread;
cdl.CarrierFrequency = Carrier_Frequency;

if contains(cdl.DelayProfile,'Custom')
    cdl.AveragePathGains = AveragePathGains;
    cdl.PathDelays = PathDelays; 
    cdl.AnglesAoD = zeros(1, size(PathDelays, 2));
    cdl.AnglesAoA = zeros(1, size(PathDelays, 2));
    cdl.AnglesZoD = 90 * ones(1, size(PathDelays, 2));
    cdl.AnglesZoA = zeros(1, size(PathDelays, 2));
end

cdl.Seed = randi([0, 1e9]);

cdl.TransmitAntennaArray.Size = [1 1 1 1 1];
cdl.ReceiveAntennaArray.Size = [1 1 1 1 1];

cdl.InitialTime = 0;

Fading_signal_noise_free = cdl(Transmitted_signal);

release(cdl);

cdl.InitialTime = 0;
Reference_Signal = cdl(Transmitted_signal_for_channel);

%release(cdl);

%cdl.InitialTime = 0;
%h = cdl([1; zeros(size(Transmitted_signal_for_channel, 1) - 1, 1)]);

% Noise Generation
SignalPower = mean(abs(Fading_signal_noise_free) .^ 2);
Noise_Variance = SignalPower / (10 ^ (SNR / 10));

Nvariance = sqrt(Noise_Variance / 2);
n = Nvariance * (randn(length(Fading_signal_noise_free), 1) + 1j * randn(length(Fading_signal_noise_free), 1)); % Noise generation

Fading_signal = Fading_signal_noise_free + n;
