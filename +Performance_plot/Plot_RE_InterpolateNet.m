figure;
image(abs(H_DNN_frame - RS).^2,'CDataMapping','scaled')
set(gca,'ColorScale','log')
clim([1e-3 1e0])
colorbar

xlabel('Index of symbols');
ylabel('Index of subcarriers');
title('MSE value of InterpolateNet at each resource element');
grid on;
hold off;