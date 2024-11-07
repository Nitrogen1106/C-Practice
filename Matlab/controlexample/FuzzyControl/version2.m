% 加载模糊控制器
fis = readfis('VehicleControlFIS');

% 初始化地图和车辆属性
figure;
RoadLength = 200;
axis([0 RoadLength 0 60]);
hold on;
grid on;

% 画出地图背景和车道线
plot([0, RoadLength], [10, 10], 'k', 'LineWidth', 2); % 上车道边界
plot([0, RoadLength], [50, 50], 'k', 'LineWidth', 2); % 下车道边界
plot([0, RoadLength], [30, 30], '--k', 'LineWidth', 1); % 中心车道线

% 生成汽车
CarNum = 6;
lane_centers = [15, 25, 35, 45];
CarPos = struct('x', [], 'y', []);
CarSpeed = zeros(1, CarNum);

for i = 1:CarNum
    CarPos(i).x = randi([0, RoadLength]);
    CarPos(i).y = lane_centers(randi([1, 4]));
    CarSpeed(i) = randi([1, 2]);
    Car(i) = rectangle('Position', [CarPos(i).x-2, CarPos(i).y-1, 4, 2], 'FaceColor', 'r');
end

% AUV 本体参数
SensorDis = 50;
TrackDis = 12;
MySpeed = 0.5;
MyAcc = 0.2; % 小幅加速和减速控制，加速值调小以确保平滑
MyPos = [0, 15]; % 初始位置在车道中心
AUV = rectangle('Position', [MyPos(1)-2, MyPos(2)-1, 4, 2], 'FaceColor', 'g');

% 动态更新车辆位置，模拟运动
for t = 1:150
    % 更新车辆位置
    for i = 1:CarNum
        CarPos(i).x = CarPos(i).x + CarSpeed(i); 
        if CarPos(i).x > RoadLength
            CarPos(i).x = 0; % 循环回到起点
        end
        Car(i).Position = [CarPos(i).x-2, CarPos(i).y-1, 4, 2];
    end
    
    % 检测前方车辆
    [FrontDetected, FrontDis] = GetFroDis(MyPos, CarPos, CarNum, SensorDis);
    disp(['前方检测状态: ', num2str(FrontDetected), ', 前方距离: ', num2str(FrontDis)]);
    [LatDetected, LatDis] = GetLatDis(MyPos, CarPos, CarNum, lane_centers, SensorDis);
    
    % 使用模糊控制器计算 LaneChange 和 MySpeed
    output = evalfis(fis, [FrontDis, LatDis]);
    LaneChange = output(1);
    MySpeed = output(2);

    % 执行变道或保持车道
    if LaneChange >= 0.5
        % 变道操作，确保变道平滑
        if  LatDis(1) > TrackDis && Dir == -1 % 向左变道
            MyPos(2) = MyPos(2) - 10;
            disp('变道成功，左侧绕行前方车辆');
        elseif LatDis(2) > TrackDis && Dir == 1 % 向右变道
            MyPos(2) = MyPos(2) + 10;
            disp('变道成功，右侧绕行车辆');
        end
    end
    disp(['速度：',num2str(MySpeed)]);
    % 更新 AUV 的位置
    MyPos(1) = MyPos(1) + MySpeed;
    % if MyPos(1) > RoadLength
    %     MyPos(1) = 0; % 循环回到起点
    % end
    AUV.Position = [MyPos(1)-2, MyPos(2)-1, 4, 2];

    % 刷新图像
    drawnow;
    pause(0.1);
end

hold off;


% 判断前方最近车辆距离（基于探测距离 SensorDis）
function [FrontDetected, FrontDis] = GetFroDis(MyPos, CarPos, CarNum, SensorDis)
    FrontDis = inf; % 初始化前向距离为无穷大
    FrontDetected = false; % 初始化前方检测状态为未检测到

    for i = 1:CarNum
        if CarPos(i).y == MyPos(2) && CarPos(i).x > MyPos(1)
            Dis = norm([CarPos(i).x - MyPos(1), CarPos(i).y - MyPos(2)]);
            if Dis < FrontDis && Dis <= SensorDis  % 只在探测范围内更新距离
                FrontDis = Dis;
                FrontDetected = true;
            end
        end
    end
end

% 判断侧向最近车辆距离（基于探测距离 SensorDis）
function [LatDetected, LatDis,Dir] = GetLatDis(MyPos, CarPos, CarNum, lane_centers, SensorDis)
    LatDis = [inf,inf];
    LatDetected = false;
    Dir=0;
    %计算当前车道索引
    [~, current_lane] = min(abs(MyPos(2) - lane_centers));
    adjacent_lanes = [0 0];

    if current_lane > 1
        adjacent_lanes(1) =lane_centers(current_lane - 1);
    end
    if current_lane < length(lane_centers)
        adjacent_lanes(2)=lane_centers(current_lane + 1);
    end

    for i = 1:CarNum
        if ismember(CarPos(i).y, adjacent_lanes) && CarPos(i).x > MyPos(1)
            Dis = norm([CarPos(i).x - MyPos(1), CarPos(i).y - MyPos(2)]);
            if Dis < min(LatDis) && Dis <= SensorDis  % 只在探测范围内更新距离
                LatDetected = true;
                %获取车道索引
                [~, lane_index] = min(abs(CarPos(i).y - lane_centers));
                %左侧距离赋值
                if lane_index>current_lane 
                    LatDis(1)=Dis;
                end
                %右侧距离赋值
                if lane_index<current_lane  
                    LatDis(2)=Dis;
                end
                %向左变道
                if LatDis(1)>LatDis(2) 
                    Dir = 1;
                end

                 if LatDis(1)<LatDis(2) 
                    Dir = -1;
                end
            end
        end
    end
end



