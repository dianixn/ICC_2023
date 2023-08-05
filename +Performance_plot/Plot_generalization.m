ianfigure;
semilogy(SNR_Range,MSE_DNN_over_SNR_CDL_A, 'Marker', 'o', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_CDL_B, 'Marker', '*', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_CDL_C, 'Marker', '+', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_HA02_over_SNR_CDL_A, 'Marker', 'o', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_HA02_over_SNR_CDL_B, 'Marker', '*', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_HA02_over_SNR_CDL_C, 'Marker', '+', 'LineWidth', 1, 'LineStyle', '--');

ylim([1e-3 1e2])

legend('InterpolateNet tested on the CDL-A channel', ...
    'InterpolateNet tested on the CDL-B channel', ...
    'InterpolateNet tested on the CDL-C channel', ...
    'HA02 tested on the CDL-A channel', ...
    'HA02 tested on the CDL-B channel', ...
    'HA02 tested on the CDL-C channel'); 

xlabel('SNR in dB');
ylabel('MSE');
title('Generalization of the trained neural networks to CDL channels');
grid on;
hold off;