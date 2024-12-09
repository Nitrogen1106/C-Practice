% MPC轨迹跟踪代码

clear; clc; close all;
map();
hold on;

%% 1.导入轨迹
filename = 'Tra_complete.xlsx'; % 替换为您的实际文件路径
trajectory_array = readmatrix(filename); % 读取 Excel 
trajectory_array(:,3)=trajectory_array(:,3)/1000;
n = size(trajectory_array, 1); % 获取轨迹点数

T = 12;
time_traj = linspace(0, T, n)'; % 每个轨迹点的时间戳
% 仿真时间设置
dt = 0.1; % 仿真步长
time_sim = 0:dt:T; % 仿真时间向量

% 插值轨迹 (如果仿真步长与轨迹点数不一致)
trajectory_interp = interp1(time_traj, trajectory_array, time_sim, 'linear'); % 插值轨迹

N = length(time_sim);

%% 2.离散化


A = eye(6); 
J = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
    0, cos(phi), -sin(phi);
    0, sin(phi)/cos(theta), cos(phi)/cos(theta)];
% 定义旋转矩阵
Rx = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

% 定义总旋转矩阵
Rm = Rz * Ry * Rx;

% 控制矩阵B  NxP
B = [Rm, zeros(3, 3); zeros(3, 3), J];


%% 3.初始化MPC控制器

Pre_Step = 5;  % 预测控制区间
eta = trajectory_interp; % 初始轨迹X_k

eta_control = zeros(6, 121);  % 轨迹数组 xk
eta_control(:, 1) = [58; 28; -3.29; 0.01; 0.01; 0.01]; % 初始的xk

control = zeros(6, 121); % 控制数组

eta_error = [];

% 状态权重矩阵 NxN
Q = diag([150, 150, 150, 1, 1, 1]);

% 控制权重矩阵 PxP
R = diag([0.01, 0.01, 0.01, 0.01, 0.01, 0.01]);
p = 6;

% 终端误差矩阵S
S = diag([150, 150, 150, 1, 1, 1]);

dis_error=[];


XYmax_linear_speed = 60; % 最大平动速度
Zmax_linear_speed = 60;    
max_angular_speed = 0.5; % 最大角速度 (rad/s)围
%% 3.循环计算


for k = 1:121
    eta_d_t = [trajectory_interp(k, :)']; % 插值轨迹点 (位置和姿态)

    phi = eta_d_t(4, k);
    theta = eta_d_t(5, k);
    psi = eta_d_t(6, k);

    
    A = eye(6);
    J = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
        0, cos(phi), -sin(phi);
        0, sin(phi)/cos(theta), cos(phi)/cos(theta)];

    % 定义旋转矩阵
    Rx = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
    Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
    Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
    Rm = Rz * Ry * Rx;

    % 控制矩阵B  NxP
    B = 0.1*[Rm, zeros(3, 3); zeros(3, 3), J];



    eta_error(:, k) = eta_d_t - eta_control(:, k);
    
    


    control(1:2) = max(min(control(1:2), XYmax_linear_speed), -XYmax_linear_speed); % 限制平动速度
    control(3) = max(min(control(3), Zmax_linear_speed), -Zmax_linear_speed); % 限制平动速度
    control(4:6) = max(min(control(4:6), max_angular_speed), -max_angular_speed); % 限制角速度

    %z状态更新
    eta_control(:, k+1) =  A*eta_control(k)+B * control(:, k);
    
    eta_error = [eta_error, eta_error(:, k)];
    
    dis_error=[dis_error,norm(eta_d_t(1:3)-eta_control(1:3,k))];


end

%% 4.轨迹绘制
eta_history = eta_control(1:3, :);

% 绘制轨迹
plot3(eta_history(1, :), eta_history(2, :), eta_history(3, :)*1000, 'b', 'DisplayName', 'Actual Path');
hold on;
plot3(trajectory_interp(:, 1), trajectory_interp(:, 2), trajectory_interp(:, 3)*1000, 'r--', 'DisplayName', 'Desired Path');
xlabel('X'); ylabel('Y'); zlabel('Z');
legend;
title('3D Trajectory Tracking');
grid on;


% 绘制误差曲线
figure;
plot(time_sim, dis_error, 'k', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Tracking Error');
title('NMPC Tracking Error Over Time');
grid on;
