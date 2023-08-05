figure;
semilogy(SNR_Range,MSE_LS_over_SNR, 'Marker', '*', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_MMSE_over_SNR, 'Marker', 's', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_training, 'Marker', 'o', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_LOS, 'Marker', '+', 'LineWidth', 1, 'LineStyle', ':');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_Delayed_Two_path, 'Marker', 'v', 'LineWidth', 1, 'LineStyle', '-.');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_EPA, 'Marker', 'd', 'LineWidth', 1, 'LineStyle', ':');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_EVA, 'Marker', 'h', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_ETU, 'Marker', 'h', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_1, 'Marker', 'x', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_2, 'Marker', 's', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_3, 'Marker', 'd', 'LineWidth', 1);

ylim([1e-3 1e2])

legend('LS estimate tested on the designed channel', ...
    'MMSE estimate tested on the designed channel', ...
    'InterpolateNet tested on the designed channel', ...
    'InterpolateNet tested on the flat fading channel', ...
    'InterpolateNet tested on the Two-path channel', ...
    'InterpolateNet tested on the EPA channel', ...
    'InterpolateNet tested on the EVA channel', ...
    'InterpolateNet tested on the ETU channel', ...
    'InterpolateNet tested on the Defined channel 1', ...
    'InterpolateNet tested on the Defined channel 2', ...
    'InterpolateNet tested on the Defined channel 3'); 

xlabel('SNR in dB');
ylabel('MSE');
title('Generalization of InterpolateNet');
grid on;
hold off;
