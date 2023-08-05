figure;
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_LOS, 'Marker', 'o', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_EPA, 'Marker', '+', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_EVA, 'Marker', 'd', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_ETU, 'Marker', 'v', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_DC1, 'Marker', 'h', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_DC2, 'Marker', 's', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_DC3, 'Marker', '*', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_SimpleNet_over_SNR_2, 'Marker', 'x', 'LineWidth', 1);
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_LOS, 'Marker', 'o', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_EPA, 'Marker', '+', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_EVA, 'Marker', 'd', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_ETU, 'Marker', 'v', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_DC1, 'Marker', 'h', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_DC2, 'Marker', 's', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_DC3, 'Marker', '*', 'LineWidth', 1, 'LineStyle', '--');
hold on
semilogy(SNR_Range,MSE_DNN_over_SNR_2, 'Marker', 'x', 'LineWidth', 1, 'LineStyle', '--');

ylim([1e-3 1e2])

legend('HA02 trained on the flat fading channel', ...
    'HA02 trained on the EPA channel', ...
    'HA02 trained on the EVA channel', ...
    'HA02 trained on the ETU channel', ...
    'HA02 trained on the defined channel 1', ...
    'HA02 trained on the defined channel 2', ...
    'HA02 trained on the defined channel 3', ...
    'HA02 trained on the Two-path channel', ...
    'InterpolateNet trained on the flat fading channel', ...
    'InterpolateNet trained on the EPA channel', ...
    'InterpolateNet trained on the EVA channel', ...
    'InterpolateNet trained on the ETU channel', ...
    'InterpolateNet trained on the defined channel 1', ...
    'InterpolateNet trained on the defined channel 2', ...
    'InterpolateNet trained on the defined channel 3', ...
    'InterpolateNet trained on the Two-path channel'); 

xlabel('SNR in dB');
ylabel('MSE');
title('Trained HA02s and InterpolateNets tested on the designed channel');
grid on;
hold off;
