% 创建模糊推理系统 (FIS)
fis = mamfis('Name', 'VehicleControl');

% 1. 定义输入变量 FrontDis（前方距离）
fis = addInput(fis, [0 100], 'Name', 'FrontDis'); % 假设距离范围为0到100
fis = addMF(fis, 'FrontDis', 'trapmf', [0 10 20 35], 'Name', 'Close');
fis = addMF(fis, 'FrontDis', 'trapmf', [35 45 55 65], 'Name', 'Moderate');
fis = addMF(fis, 'FrontDis', 'trapmf', [65 75 85 100], 'Name', 'Far');

% 2. 定义输入变量 LatDisLeft（左侧向距离）
fis = addInput(fis, [0 100], 'Name', 'LatDisLeft'); % 假设距离范围为0到100
fis = addMF(fis, 'LatDisLeft', 'trapmf', [0 10 20 35], 'Name', 'Close');
fis = addMF(fis, 'LatDisLeft', 'trapmf', [35 45 55 65], 'Name', 'Moderate');
fis = addMF(fis, 'LatDisLeft', 'trapmf', [65 75 85 100], 'Name', 'Far');

% 3. 定义输入变量 LatDisRight（右侧向距离）
fis = addInput(fis, [0 100], 'Name', 'LatDisRight'); % 假设距离范围为0到100
fis = addMF(fis, 'LatDisRight', 'trapmf', [0 10 20 35], 'Name', 'Close');
fis = addMF(fis, 'LatDisRight', 'trapmf', [35 45 55 65], 'Name', 'Moderate');
fis = addMF(fis, 'LatDisRight', 'trapmf', [65 75 85 100], 'Name', 'Far');

% 4. 定义输出变量 LaneChange（变道决策）
fis = addOutput(fis, [-1 1], 'Name', 'LaneChange'); % -1: 左变道, 1: 右变道, 0: 不变道
fis = addMF(fis, 'LaneChange', 'trimf', [-0.5 0 0.5], 'Name', 'Stay');
fis = addMF(fis, 'LaneChange', 'trimf', [-1 -1 -0.5], 'Name', 'Left');
fis = addMF(fis, 'LaneChange', 'trimf', [0.5 1 1], 'Name', 'Right');

% 5. 定义输出变量 MySpeed（速度调整）
fis = addOutput(fis, [0.5 3], 'Name', 'MySpeed'); % 假设速度范围为0.5到3
fis = addMF(fis, 'MySpeed', 'trimf', [0.5 1.2 2], 'Name', 'Slow');
fis = addMF(fis, 'MySpeed', 'trimf', [2 2.25 2.5], 'Name', 'Moderate');
fis = addMF(fis, 'MySpeed', 'trimf', [2.5 2.75 3], 'Name', 'Fast');

% 6. 定义模糊规则
ruleList = [
    3 0 0 0 3 1 1;   % 如果 FrontDis 是 Far, 则 LaneChange 是 Stay, MySpeed 是 Fast
    2 1 1 0 2 1 1;   % 如果 FrontDis 是 Moderate 且左右侧均 Close, 则 LaneChange 是 Stay, MySpeed 是 Moderate
    2 3 1 -1 2 1 1;  % 如果 FrontDis 是 Moderate 且左侧距离更大，则 LaneChange 是 Left, MySpeed 是 Moderate
    2 1 3 1 2 1 1;   % 如果 FrontDis 是 Moderate 且右侧距离更大，则 LaneChange 是 Right, MySpeed 是 Moderate
    2 3 3 -1 2 1 1;  % 如果 FrontDis 是 Moderate 且左右侧均 Far，左侧更大，则 LaneChange 是 Left, MySpeed 是 Moderate
    1 3 1 -1 1 1 1;  % 如果 FrontDis 是 Close 且左侧距离更大，则 LaneChange 是 Left, MySpeed 是 Slow
    1 1 3 1 1 1 1;   % 如果 FrontDis 是 Close 且右侧距离更大，则 LaneChange 是 Right, MySpeed 是 Slow
    1 3 3 -1 1 1 1;  % 如果 FrontDis 是 Close 且左右均 Far，左侧更大，则 LaneChange 是 Left, MySpeed 是 Slow
    1 1 1 0 1 1 1;   % 如果 FrontDis 是 Close 且左右均 Close，则 LaneChange 是 Stay, MySpeed 是 Slow
];

% 将规则添加到模糊推理系统
fis = addRule(fis, ruleList);

% 显示模糊规则
showrule(fis);

% 保存模糊控制器为 FIS 文件
writeFIS(fis, 'VehicleControlFIS');



