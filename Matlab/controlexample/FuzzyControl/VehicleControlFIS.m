% 创建模糊推理系统 (FIS)
fis = mamfis('Name', 'VehicleControl');


% 1. 定义输入变量 FrontDis（前方距离）
fis = addInput(fis, [0 50], 'Name', 'FrontDis'); % 假设距离范围为0到100
fis = addMF(fis, 'FrontDis', 'trapmf', [0 0 5 12], 'Name', 'Close');
fis = addMF(fis, 'FrontDis', 'trapmf', [12 18 24 30], 'Name', 'Moderate');
fis = addMF(fis, 'FrontDis', 'trapmf', [30 35 40 50], 'Name', 'Far');

% 2. 定义输入变量 LatDis（侧向距离）
fis = addInput(fis, [0 50], 'Name', 'LatDis'); % 假设距离范围为0到100
fis = addMF(fis, 'LatDis', 'trapmf', [0 4 8 12], 'Name', 'Close');
fis = addMF(fis, 'LatDis', 'trapmf', [12 18 24 30], 'Name', 'Moderate');
fis = addMF(fis, 'LatDis', 'trapmf', [30 35 40 50], 'Name', 'Far');

% 3. 定义输出变量 LaneChange（变道决策）
fis = addOutput(fis, [0 1], 'Name', 'LaneChange'); % 0: 不变道, 1: 变道
fis = addMF(fis, 'LaneChange', 'trimf', [0 0 0.5], 'Name', 'Stay');
fis = addMF(fis, 'LaneChange', 'trimf', [0.5 1 1], 'Name', 'Change');

% 4. 定义输出变量 MySpeed（速度调整）
fis = addOutput(fis, [1 3], 'Name', 'MySpeed'); % 假设速度范围为0到2
fis = addMF(fis, 'MySpeed', 'trimf', [1 1.2 2], 'Name', 'Slow');
fis = addMF(fis, 'MySpeed', 'trimf', [2 2.25 2.5], 'Name', 'Moderate');
fis = addMF(fis, 'MySpeed', 'trimf', [2.5 2.75 3], 'Name', 'Fast');

% 5. 定义模糊规则
ruleList = [
    % FrontDis     LatDis     LaneChange     MySpeed     权重    操作方式
    1 1 1 1 1 1;   % 如果 FrontDis 是 Close 且 LatDis 是 Close, 则 LaneChange 是 Stay, MySpeed 是 Slow
    1 2 2 2 1 1;   % 如果 FrontDis 是 Close 且 LatDis 是 Moderate, 则 LaneChange 是 Change, MySpeed 是 Moderate
    1 3 2 3 1 1;   % 如果 FrontDis 是 Close 且 LatDis 是 Far, 则 LaneChange 是 Change, MySpeed 是 Fast
    2 1 1 2 1 1;   % 如果 FrontDis 是 Moderate 且 LatDis 是 Close, 则 LaneChange 是 Stay, MySpeed 是 Moderate
    2 2 1 2 1 1;   % 如果 FrontDis 是 Moderate 且 LatDis 是 Moderate, 则 LaneChange 是 Stay, MySpeed 是 Moderate
    2 3 2 3 1 1;   % 如果 FrontDis 是 Moderate 且 LatDis 是 Far, 则 LaneChange 是 Change, MySpeed 是 Fast
    3 1 1 3 1 1;   % 如果 FrontDis 是 Far 且 LatDis 是 Close, 则 LaneChange 是 Stay, MySpeed 是 Fast
    3 2 1 3 1 1;   % 如果 FrontDis 是 Far 且 LatDis 是 Moderate, 则 LaneChange 是 Stay, MySpeed 是 Fast
    3 3 1 3 1 1;   % 如果 FrontDis 是 Far 且 LatDis 是 Far, 则 LaneChange 是 Stay, MySpeed 是 Fast
];

fis = addRule(fis, ruleList);

% 显示模糊规则
showrule(fis);

% 保存模糊控制器为 FIS 文件
writeFIS(fis, 'VehicleControlFIS');



