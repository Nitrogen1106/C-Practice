% 清空环境
clear; clc; close all;

map();
hold on;

%% 1. 导入规划生成的轨迹

filename = 'Tra.xlsx'; % 替换为您的实际文件路径
trajectory_array = readmatrix(filename); % 读取 Excel 
n = size(trajectory_array, 1); % 获取轨迹点数

T =12;  % 总时间


time_traj = linspace(0, T, n)'; % 每个轨迹点的时间戳

% 仿真时间设置
dt = 0.1; % 仿真步长
time_sim = 0:dt:T; % 仿真时间向量

% 插值轨迹 (如果仿真步长与轨迹点数不一致)
trajectory_interp = interp1(time_traj, trajectory_array, time_sim, 'linear'); % 插值轨迹
trajectory_d_interp = gradient(trajectory_interp, dt); % 计算轨迹导数

%% 2. 初始化 LQR 控制器
% 定义运动学矩阵 B
phi_val = 0; theta_val = 0; psi_val = 0; % 初始角度
syms phi theta psi real

% 角速度矩阵 J
J = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
     0, cos(phi), -sin(phi);
     0, sin(phi)/cos(theta), cos(phi)/cos(theta)];
R = eye(3); % 假设初始旋转矩阵为单位阵
J_numeric = double(subs(J, {phi, theta}, {phi_val, theta_val}));
B = [R, zeros(3, 3); zeros(3, 3), J_numeric];

% 状态矩阵 A
A = zeros(6, 6); % 假设线性化后的 A 矩阵为零

% 定义 LQR 的 Q 和 R
% Q = eye(6); % 惩罚状态误差的权重
Q=[1,0,0,0,0,0;
    0,1,0,0,0,0;
    0,0,1,0,0,0;
    0,0,0,1,0,0;
    0,0,0,0,1,0;
    0,0,0,0,0,1;];
R = 0.01;  % 惩罚控制输入的权重

% 计算 LQR 增益矩阵 K
K = lqr(A, B, Q, R);
disp('LQR Gain Matrix K:');
disp(K);

XYmax_linear_speed = 60; % 最大平动速度
Zmax_linear_speed = 13000;    
max_angular_speed = 0.5; % 最大角速度 (rad/s)围


%% 3. 仿真轨迹跟踪
% 初始化状态
eta = [58; 28; -3290; 0; 0; 0]; % 实际状态
eta_history = [];
error_history = [];
control_input_history = []; % 记录控制输入的历史
% 仿真循环
for k = 1:length(time_sim)
    % 当前目标状态和导数
    eta_d_t = [trajectory_interp(k, :)'; 0; 0; 0]; % 插值轨迹点 (位置和姿态)
    eta_dot_d_t = [trajectory_d_interp(k, :)'; 0; 0; 0]; % 轨迹导数 (速度)
    
    % 计算误差
    e = eta - eta_d_t;
    
    % 计算控制输入
    nu = -K * e; % LQR 控制律F
    
    nu(1:2) = max(min(nu(1:2), XYmax_linear_speed), -XYmax_linear_speed); % 限制平动速度
    nu(3) = max(min(nu(3), Zmax_linear_speed), -Zmax_linear_speed); % 限制平动速度

    nu(4:6) = max(min(nu(4:6), max_angular_speed), -max_angular_speed); % 限制角速度

    % 更新实际状态
    eta_dot = B * nu; % 使用运动学模型更新状态
    eta = eta + eta_dot * dt; % 欧拉积分更新
    
    % 记录状态和误差
    eta_history = [eta_history; eta'];
    error_history = [error_history; norm(eta(1:3)-eta_d_t(1:3))];
    control_input_history = [control_input_history,nu];
end

%% 4. 可视化结果
% 实际轨迹
eta_history = eta_history(:, 1:3);

% 绘制轨迹

plot3(eta_history(:, 1), eta_history(:, 2), eta_history(:, 3), 'y', 'DisplayName', 'Actual Path');
hold on;
plot3(trajectory_interp(:, 1), trajectory_interp(:, 2), trajectory_interp(:, 3), 'r--', 'DisplayName', 'Desired Path');
xlabel('X'); ylabel('Y'); zlabel('Z');
legend;
title('3D Trajectory Tracking');
grid on;

% 绘制误差曲线
figure;
plot(time_sim, error_history, 'k', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Tracking Error');
title('Tracking Error Over Time');
grid on; 

writematrix(error_history, 'LQR_error.xlsx');