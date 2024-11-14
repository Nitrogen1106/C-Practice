% 创建模糊推理系统 (FIS)
fis = mamfis('Name', 'VehicleControl');

% 定义输入变量 FrontDis
fis = addInput(fis, [0 100], 'Name', 'FrontDis');
fis = addMF(fis, 'FrontDis', 'trapmf', [0, 0, 10, 20], 'Name', 'Close');
fis = addMF(fis, 'FrontDis', 'trapmf', [15, 30, 40, 55], 'Name', 'Moderate');
fis = addMF(fis, 'FrontDis', 'trapmf', [50, 70, 100, 100], 'Name', 'Far');

% 定义输入变量 LatDisLeft
fis = addInput(fis, [0 100], 'Name', 'LatDisLeft');
fis = addMF(fis, 'LatDisLeft', 'trapmf', [0, 0, 10, 20], 'Name', 'Close');
fis = addMF(fis, 'LatDisLeft', 'trapmf', [15, 30, 40, 55], 'Name', 'Moderate');
fis = addMF(fis, 'LatDisLeft', 'trapmf', [50, 70, 100, 100], 'Name', 'Far');

% 定义输入变量 LatDisRight
fis = addInput(fis, [0 100], 'Name', 'LatDisRight');
fis = addMF(fis, 'LatDisRight', 'trapmf', [0, 0, 10, 20], 'Name', 'Close');
fis = addMF(fis, 'LatDisRight', 'trapmf', [15, 30, 40, 55], 'Name', 'Moderate');
fis = addMF(fis, 'LatDisRight', 'trapmf', [50, 70, 100, 100], 'Name', 'Far');

% 定义输出变量 LaneChange
fis = addOutput(fis, [-1 1], 'Name', 'LaneChange');
fis = addMF(fis, 'LaneChange', 'trimf', [-0.5, 0, 0.5], 'Name', 'Stay');
fis = addMF(fis, 'LaneChange', 'trimf', [-1, -1, -0.5], 'Name', 'Left');
fis = addMF(fis, 'LaneChange', 'trimf', [0.5, 1, 1], 'Name', 'Right');

% 定义输出变量 MySpeed
fis = addOutput(fis, [0.5 3], 'Name', 'MySpeed');
fis = addMF(fis, 'MySpeed', 'trimf', [0.5, 1, 1.5], 'Name', 'Slow');
fis = addMF(fis, 'MySpeed', 'trimf', [1.5, 2, 2.5], 'Name', 'Moderate');
fis = addMF(fis, 'MySpeed', 'trimf', [2.5, 3, 3], 'Name', 'Fast');

% 定义19条模糊规则
ruleList = [
    3 0 0 0 3 1 1;   % 若 FrontDis 是 Far，忽略 LatDis，保持车道，速度 Fast
    2 2 3 1 3 1 1;   % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Moderate, LatDisRight 是 Far，向右变道，速度 Fast
    2 3 2 -1 3 1 1;  % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Far, LatDisRight 是 Moderate，向左变道，速度 Fast
    2 1 2 1 2 1 1;   % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Close, LatDisRight 是 Moderate，向右变道，速度 Moderate
    2 1 3 1 3 1 1;   % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Close, LatDisRight 是 Far，向右变道，速度 Fast
    2 2 1 -1 2 1 1;  % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Moderate, LatDisRight 是 Close，向左变道，速度 Moderate
    2 3 1 -1 3 1 1;  % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Far, LatDisRight 是 Close，向左变道，速度 Fast
    2 3 3 -1 3 1 1;  % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Far, LatDisRight 是 Far，向左变道，速度 Fast
    2 2 2 0 2 1 1;   % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Moderate, LatDisRight 是 Moderate，保持车道，速度 Moderate
    2 1 1 0 2 1 1;   % 若 FrontDis 是 Moderate 且 LatDisLeft 是 Close, LatDisRight 是 Close，保持车道，速度 Moderate
    1 3 3 0 3 1 1;   % 若 FrontDis 是 Close 且 LatDisLeft 是 Far, LatDisRight 是 Far，保持车道，速度 Fast
    1 3 2 -1 3 1 1;  % 若 FrontDis 是 Close 且 LatDisLeft 是 Far, LatDisRight 是 Moderate，向左变道，速度 Fast
    1 3 1 -1 3 1 1;  % 若 FrontDis 是 Close 且 LatDisLeft 是 Far, LatDisRight 是 Close，向左变道，速度 Fast
    1 2 3 1 3 1 1;   % 若 FrontDis 是 Close 且 LatDisLeft 是 Moderate, LatDisRight 是 Far，向右变道，速度 Fast
    1 2 2 -1 2 1 1;  % 若 FrontDis 是 Close 且 LatDisLeft 是 Moderate, LatDisRight 是 Moderate，向左变道，速度 Moderate
    1 2 1 -1 2 1 1;  % 若 FrontDis 是 Close 且 LatDisLeft 是 Moderate, LatDisRight 是 Close，向左变道，速度 Moderate
    1 1 3 1 3 1 1;   % 若 FrontDis 是 Close 且 LatDisLeft 是 Close, LatDisRight 是 Far，向右变道，速度 Fast
    1 1 2 1 2 1 1;   % 若 FrontDis 是 Close 且 LatDisLeft 是 Close, LatDisRight 是 Moderate，向右变道，速度 Moderate
    1 1 1 0 1 1 1;   % 若 FrontDis 是 Close 且 LatDisLeft 是 Close, LatDisRight 是 Close，保持车道，速度 Slow
];


% 将规则添加到模糊推理系统
fis = addRule(fis, ruleList);

% 显示模糊规则
showrule(fis);

% 保存模糊控制器为 FIS 文件
writeFIS(fis, 'VehicleControlFIS');

% 定义输入变量的范围
frontDisRange = linspace(0, 100, 20);
latDisLeftRange = linspace(0, 100, 20);
latDisRightRange = linspace(0, 100, 20);

% 生成网格
[FrontDisGrid, LatDisLeftGrid, LatDisRightGrid] = meshgrid(frontDisRange, latDisLeftRange, latDisRightRange);

% 评估模糊推理系统
MySpeedGrid = zeros(size(FrontDisGrid));
for i = 1:size(FrontDisGrid, 3)
    for j = 1:size(FrontDisGrid, 2)
        for k = 1:size(FrontDisGrid, 1)
            inputs = [FrontDisGrid(k, j, i), LatDisLeftGrid(k, j, i), LatDisRightGrid(k, j, i)];
            MySpeedGrid(k, j, i) = evalfis(fis, inputs);
        end
    end
end

% 生成图像
figure;
surf(FrontDisGrid, LatDisLeftGrid, MySpeedGrid);
xlabel('FrontDis');
ylabel('LatDisLeft');
zlabel('MySpeed');
title('3D Surface Plot of MySpeed Output');
