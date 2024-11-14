%% 矢量绘制
% 加载图像数据
global data;
data = imread('ocean1.tif'); % 确保路径正确
global X;
global Y;
[X, Y] = meshgrid(1:size(data, 2), 1:size(data, 1));

color_data = data;
color_map = jet;

% 创建3D地形图
figure;
surf(X, Y, double(data), color_data, 'EdgeColor', 'none');
xlabel('X');
ylabel('Y');
zlabel('Elevation');
title('3D Ocean Elevation Map with Vortex Vector Field');
colormap(color_map);
colorbar;
hold on;

% 定义多个涡流中心坐标
lamb_pos = [100, 65; 90,200; 200, 180; 140, 120; 235, 235];

% 定义涡流参数
B = 1000;
r = 10;

% 创建覆盖整个环境的稀疏网格
[Xv, Yv] = meshgrid(1:5:size(data, 2), 1:5:size(data, 1)); % 稀疏化网格

% 初始化合成矢量场
uc_total = zeros(size(Xv));
vc_total = zeros(size(Xv));

% 计算并叠加多个涡流的矢量场
for i = 1:size(lamb_pos, 1)
    x0 = lamb_pos(i, 1);
    y0 = lamb_pos(i, 2);
    
    % 计算矢量场网格的距离矩阵
    Rv = sqrt((Xv - x0).^2 + (Yv - y0).^2);
    
    % 避免除以零，设置最小距离
    Rv(Rv == 0) = eps;
    
    % 计算涡流速度分量
uc = (-B * (Yv - y0) ./ (2 * pi * (Rv).^2)) .* (1 - exp(-((Rv).^2 / r^2)));
vc = (B * (Xv - x0) ./ (2 * pi * (Rv).^2)) .* (1 - exp(-((Rv).^2 / r^2)));
    
    % 累加矢量场
    uc_total = uc_total + uc;
    vc_total = vc_total + vc;
end

% 计算速度大小
speed = sqrt(uc_total.^2 + vc_total.^2);

% 获取颜色映射
cmap = colormap(jet);
n_colors = size(cmap, 1);

% 归一化速度值到颜色索引
speed_normalized = (speed - min(speed(:))) / (max(speed(:)) - min(speed(:)));
color_indices = round(speed_normalized * (n_colors - 1)) + 1;

% 绘制覆盖整个环境的合成涡流矢量场（俯视图）
figure;
imagesc(color_data); % 显示彩色图像数据作为背景
colormap(color_map); % 使用jet颜色映射
colorbar;
hold on;

% 绘制矢量并根据速度大小映射颜色
for i = 1:size(Xv, 1)
    for j = 1:size(Xv, 2)
        color = cmap(color_indices(i, j), :);
        quiver(Xv(i, j), Yv(i, j), uc_total(i, j), vc_total(i, j), 'Color', color, 'MaxHeadSize', 0.5, 'AutoScale', 'off');
    end
end

% 添加速度大小的颜色条
caxis([min(speed(:)) max(speed(:))]);
colorbar;
ylabel(colorbar, 'Speed');

% 确保绘制的圆形是正确的圆形
axis equal;

% 绘制涡流中心点附近的红色圆圈
theta = linspace(0, 2*pi, 100);
for i = 1:size(lamb_pos, 1)
    x_center = lamb_pos(i, 1);
    y_center = lamb_pos(i, 2);
    x_circle = x_center + 10 * cos(theta);
    y_circle = y_center + 10 * sin(theta);
    plot(x_circle, y_circle, 'r', 'LineWidth', 1.5);
end

title('俯视的合成洋流矢量图和涡流中心区域');
xlabel('X');
ylabel('Y');
hold off;

