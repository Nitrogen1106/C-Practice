%------------------------------绘图-----------------------------------
% 初始化地图和车辆属性

fis = readfis('VehicleControlFIS_ori');

car_length=4;
car_width=2;

figure;
RoadLength = 200;

axis([0 RoadLength 0 60]);
hold on;
grid on;

% 画出地图背景和车道线
plot([0, RoadLength], [10, 10], 'k', 'LineWidth', 2); % 上车道边界
plot([0, RoadLength], [50, 50], 'k', 'LineWidth', 2); % 下车道边界
plot([0, RoadLength], [30, 30], '--k', 'LineWidth', 1); % 中心车道线


v_r=zeros(1,100);

front_text = text(5, 57, '', 'FontSize', 10, 'Color', 'blue', 'FontWeight', 'bold');
lat_text = text(5, 52, '', 'FontSize', 10, 'Color', 'blue', 'FontWeight', 'bold');
speed_text = text(140, 55, '', 'FontSize', 10, 'Color', 'blue', 'FontWeight', 'bold');


%---------------------------------汽车生成------------------------------
CarNum = 6;
% 定义车道中心位置
lane_centers = [15, 25, 35, 45]; % 四条车道的中心位置
CarPos = struct('x', [], 'y', []); % 初始化汽车位置结构体
CarSpeed = zeros(1, CarNum); % 初始化速度数组

for i = 1:CarNum
    % 随机生成车辆x坐标，并分配到随机车道中心
    CarPos(i).x = randi([20,RoadLength]);
    CarPos(i).y = lane_centers(randi([1, 4])); % 随机分配到车道中心位置

    % 随机生成车辆速度
    CarSpeed(i) = randi([1, 2]);

    % 初始化车辆模型
    Car(i) = rectangle('Position', [CarPos(i).x-2, CarPos(i).y-1, car_length, car_width], ...
        'FaceColor', 'r');
end

%-----------------------AUV本体参数------------------------------
% 探测距离
SensorDis = 100;

% 跟踪距离
TrackDis = 30;

% % 初始速度和加速度
% MySpeed = 0.5;
% MyAcc = 0.3;

% 当前位置
MyPos = [0, 25];
AUV = rectangle('Position', [MyPos(1)-2, MyPos(2)-1, car_length, car_width], 'FaceColor', 'g');

%----------------------运行过程----------------------------------------
% 动态更新车辆位置，模拟运动
for t = 1:100

    % 更新车辆位置
    for i = 1:CarNum
        CarPos(i).x = CarPos(i).x + CarSpeed(i); 
        Car(i).Position = [CarPos(i).x-2, CarPos(i).y-1, car_length, car_width];
    end
    
    % 检测前方车辆（在探测距离内）
    [FrontDetected, FrontDis] = GetFroDis(MyPos, CarPos, CarNum, SensorDis);

    % 检测侧向车辆（在探测距离内）
    [LatDetected, LatDis,Dir] = GetLatDis(MyPos, CarPos, CarNum, lane_centers, SensorDis);


    
    LatDisLim(1)=min(100,LatDis(1));
    LatDisLim(2)=min(LatDis(2),100); 
    FrontDisLim=min(FrontDis,100);

    inputs = [FrontDisLim, LatDisLim(1), LatDisLim(2)]; % 将前方距离和侧向距离输入到模糊控制系统
    outputs = evalfis(fis, inputs); % 使用模糊控制器计算输出
    LaneChange = outputs(1); % 第一个输出为变道决策
    MySpeed = outputs(2);    % 第二个输出为速度
    
    if FrontDis <= TrackDis
        % 根据模糊控制器的变道决策更新位置
        if LaneChange <= 0 
            MyPos(2) = max(MyPos(2) - 10, lane_centers(1));
        elseif LaneChange >=0 
            MyPos(2) = min(MyPos(2) + 10, lane_centers(end));
        end
    end
    MyPos(1) = MyPos(1) + MySpeed;
    % 更新 AUV 位置
    AUV.Position = [MyPos(1)-2, MyPos(2)-1, car_length, car_width];
    
    set(front_text, 'String', ['前方检测状态: ', num2str(FrontDetected), ', 前方距离: ', num2str(FrontDis)]);
    set(lat_text, 'String', ['侧方检测状态: ', num2str(LatDetected), ', 侧向距离: [', num2str(LatDis(1)), ', ', num2str(LatDis(2)), ']']);
    set(speed_text, 'String', ['当前速度: ', num2str(MySpeed)]);

    v_r(t)=MySpeed;
    

    % 刷新图像
    drawnow;
    pause(0.1); % 控制刷新频率
end

hold off;

v_avg=mean(v_r);

% 运行过程结束后绘制速度变化曲线
figure;
plot(1:t, v_r(1:t), '-o'); % 使用迭代次数作为x轴，速度v_r作为y轴
hold on;

% 绘制平均速度的水平线
yline(v_avg, '--', 'Average Speed', 'LabelHorizontalAlignment', 'left');
xlabel('Iteration');
ylabel('Speed');
title('Speed Variation Over Time with Average Speed');
grid on;
hold off;


%--------------------------函数部分-------------------------------------

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

            if LatDis(1) == inf && LatDis(2) == inf
                % 当左右两侧距离均为 inf 时
                if adjacent_lanes(1) ~= 0  % 左侧车道存在
                    Dir = -1;  % 向左变道
                elseif adjacent_lanes(2) ~= 0  % 右侧车道存在
                    Dir = 1;  % 向右变道
                end
            end

            %变道标识符
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

