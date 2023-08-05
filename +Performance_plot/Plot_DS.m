figure;
loglog([100,500,1000,2000,5000,7000,10000,20000,30000],MSE_DNN_over_SNR_CDL_A, 'Marker', 'o', 'LineWidth', 1);
hold on
loglog([100,500,1000,2000,5000,7000,10000,20000,30000],MSE_DNN_over_SNR_CDL_B, 'Marker', 'h', 'LineWidth', 1);
hold on
loglog([100,500,1000,2000,5000,7000,10000,20000,30000],MSE_DNN_over_SNR_CDL_C, 'Marker', '+', 'LineWidth', 1);
hold on
loglog([100,500,1000,2000,5000,7000,10000,20000,30000],MSE_HA02_over_SNR_CDL_A, 'Marker', 'o', 'LineWidth', 1, 'LineStyle', '--');
hold on
loglog([100,500,1000,2000,5000,7000,10000,20000,30000],MSE_HA02_over_SNR_CDL_B, 'Marker', 'h', 'LineWidth', 1, 'LineStyle', '--');
hold on
loglog([100,500,1000,2000,5000,7000,10000,20000,30000],MSE_HA02_over_SNR_CDL_C, 'Marker', '+', 'LineWidth', 1, 'LineStyle', '--');

xlim([1e2 3e4])
ylim([1e-3 1e2])

legend('InterpolateNets tested on CDL-A', ...
    'InterpolateNets tested on CDL-B', ...
    'InterpolateNets tested on CDL-C', ...
    'HA02 tested on CDL-A', ...
    'HA02 tested on CDL-B', ...
    'HA02 tested on CDL-C'); 

xlabel('DS in ns');
ylabel('MSE');
title('Trained HA02 and InterpolateNet tested on the CDL channels');
grid on;
hold off;
