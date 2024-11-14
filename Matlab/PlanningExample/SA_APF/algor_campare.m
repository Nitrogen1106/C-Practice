%% 参数比较
function []=algor_campare(path,apf_path,model)

% 将 path 转换为 fcost 所需的结构体格式
sample_path.x = path(1, :);
sample_path.y = path(2, :);
sample_path.z = path(3, :);

% 计算代价函数值
sa_cost = fcost(sample_path, model);

% 绘制适应度曲线
figure;
plot(sa_cost, '-o', 'LineWidth', 2);
title('SA适应度曲线');
xlabel('路径标号');
ylabel('代价函数值');
grid on;

% 检查变量名称
whos % 打印变量名称以检查是否正确载入

% 目标点数
num_points = 22;

% 原始路径点数
original_points = size(apf_path, 1);

% 生成原始路径点的索引
original_index = linspace(1, original_points, original_points);

% 生成重新采样后的路径点的索引
resampled_index = linspace(1, original_points, num_points);

% 对每个维度进行线性插值
resampled_x = interp1(original_index, apf_path(:, 1), resampled_index, 'linear');
resampled_y = interp1(original_index, apf_path(:, 2), resampled_index, 'linear');
resampled_z = interp1(original_index, apf_path(:, 3), resampled_index, 'linear');

% 将重新采样的结果组合成新的路径
resampled_apf_path = [resampled_x', resampled_y', resampled_z'];

% 打印重新采样后的路径数据
disp('重新采样后的 APF 路径:');
disp(resampled_apf_path);

% 可视化原始路径和重新采样后的路径
figure;
subplot(1, 2, 1);
plot3(apf_path(:, 1), apf_path(:, 2), apf_path(:, 3), 'b.-');
title('原始 APF 路径');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;

subplot(1, 2, 2);
plot3(resampled_apf_path(:, 1), resampled_apf_path(:, 2), resampled_apf_path(:, 3), 'r.-');
title('重新采样后的 APF 路径');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;


sample_path.x = resampled_apf_path(:, 1)';
sample_path.y = resampled_apf_path(:, 2)';
sample_path.z = resampled_apf_path(:, 3)';

% 计算代价函数值
apf_cost = fcost(sample_path, model);

% 绘制适应度曲线
figure;
plot(1, apf_cost, '-o', 'LineWidth', 2);
title('改进APF代价函数值');
xlabel('样本索引');
ylabel('代价函数值');
grid on;


ch_rate=(apf_cost-sa_cost)*100/sa_cost;
fprintf('百分率波动: %d\n',ch_rate);

save('paths.mat', 'path');
save('apf_paths.mat', 'resampled_apf_path');

end