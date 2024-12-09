% 读取数据
filename1 = 'LQR_error.xlsx'; % 替换为您的实际文件路径
trajectory_array1 = readmatrix(filename1); % 读取 LQR 误差数据

filename2 = 'iLQR_error.xlsx'; % 替换为您的实际文件路径
trajectory_array2 = readmatrix(filename2); % 读取 iLQR 误差数据

% 绘制两个数组的数据
figure; % 创建一个新的图形窗口
plot(trajectory_array1, 'b-', 'LineWidth', 2); % 绘制 LQR 误差数据，使用蓝色线条，线宽为2
hold on; % 保持当前图形，允许在同一图上绘制多个数据集
plot(trajectory_array2, 'r--', 'LineWidth', 2); % 绘制 iLQR 误差数据，使用红色虚线，线宽为2
hold off; % 释放图形，不再添加新的数据集

% 添加图例
legend('LQR Error', 'iLQR Error');

% 添加标题和轴标签
title('Tracking Error Comparison');
xlabel('Time (s)');
ylabel('Tracking Error');

% 显示网格
grid on;