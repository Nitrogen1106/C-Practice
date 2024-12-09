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

%% 2.离散线性化
phi_val = 0; theta_val = 0; psi_val = 0; % 初始角度
syms phi theta psi real

A = zeros(6, 6); % 假设线性化后的 A 矩阵为零
J = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
    0, cos(phi), -sin(phi);
    0, sin(phi)/cos(theta), cos(phi)/cos(theta)];
% 定义旋转矩阵
Rx = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

% 定义总旋转矩阵
Rm = Rz * Ry * Rx;

J_numeric = double(subs(J, {phi, theta}, {phi_val, theta_val}));
Rm = double(subs(Rm, {phi, theta, psi}, {phi_val, theta_val, psi_val}));

% 控制矩阵B  NxP
B = [Rm, zeros(3, 3); zeros(3, 3), J_numeric];

C = zeros(6, 6);
D = zeros(6, 6);

% 创建状态空间连续时间模型
sys_cont = ss(A, B, C, D);

% 离散化系统，假设采样时间 Ts = 0.1 秒
Ts = 0.1;
sys_discrete = c2d(sys_cont, Ts);

% 提取离散时间系统的 A 和 B 矩阵
A = sys_discrete.A;
B = sys_discrete.B;
B=diag([1,1,1,1,1,1]);

%% 3.初始化MPC控制器

Pre_Step = 5;  % 预测控制区间
eta = trajectory_interp; % 初始轨迹X_k

eta_control = zeros(6, 121);  % 轨迹数组 xk
eta_control(:, 1) = [58; 28; -3.29; 0.01; 0.01; 0.01]; % 初始的xk

control = zeros(6, 121); % 控制数组

eta_error = [];

% 状态权重矩阵 NxN
Q = diag([15, 15, 15, 1, 1, 1]);

% 控制权重矩阵 PxP
R = diag([0.001, 0.001, 0.001, 0.001, 0.001, 0.001]);
p = 6;


% 终端误差矩阵S
% S = diag([150, 150, 150, 1, 1, 1]);
S = zeros(6,6);
dis_error=[];


XYmax_linear_speed = 60; % 最大平动速度
Zmax_linear_speed = 60;    
max_angular_speed = 0.5; % 最大角速度 (rad/s)围
%% 3.循环计算
[F, H] = MPC_Cal(A, B, Q, R, S, Pre_Step);

for k = 1:121
    eta_d_t = [trajectory_interp(k, :)']; % 插值轨迹点 (位置和姿态)
    eta_error(:, k) = eta_d_t - eta_control(:, k);
    

    control(:, k) = MPC_Predict(eta_d_t, F, H, Pre_Step, p);

    control(1:2) = max(min(control(1:2), XYmax_linear_speed), -XYmax_linear_speed); % 限制平动速度
    control(3) = max(min(control(3), Zmax_linear_speed), -Zmax_linear_speed); % 限制平动速度
    control(4:6) = max(min(control(4:6), max_angular_speed), -max_angular_speed); % 限制角速度

    eta_control(:, k+1) = - B * control(:, k);
    
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
title('MPC Tracking Error Over Time');
grid on;

%% 输出计算函数
function u_k = MPC_Predict(x_k, F, H, Pre_Step, p)
    % 强制转换为双精度
    F = double(F);
    H = double(H);
    x_k = double(x_k);
    
    % 处理优化结果
    I=eye(6);
    Z=zeros(6,6);
    u_k = -[I,Z,Z,Z,Z]*inv(H)*F*x_k;
    
end

%% FH矩阵计算函数
function [F, H] = MPC_Cal(A, B, Q, R, S, Pre_Step)
    n = size(A, 1); % 系统状态的维度
    p = size(B, 2); % 控制输入的维度
    
    tmp = eye(n); % 初始化一个n维单位矩阵
    rows = 1:n; % 用于迭代构建Phi和Gamma矩阵的行索引

    Phi = zeros(Pre_Step * n, n);  % 初始化Phi矩阵
    Gamma = zeros(Pre_Step * n, Pre_Step * p);  % 初始化Gamma矩阵

    % Gamma矩阵
    for i = 1:Pre_Step
        % 构建Phi矩阵
        Phi((i-1)*n+1:i*n, :) = A^i;

        % 构建Gamma矩阵
        Gamma(rows, :) = [tmp * B, Gamma(max(1, rows - n), 1:end-p)];

        % 更新rows行
        rows = i * n + (1:n);

        % 更新tmp矩阵
        tmp = A * tmp;
    end

    % 构建Omega矩阵，包含Q矩阵的部分
    Omega = kron(eye(Pre_Step - 1), Q);
    % 构建最终Omega矩阵，包含S矩阵
    Omega = blkdiag(Omega, S);
    % 构建Psi矩阵，其为R矩阵组成的对角阵
    Psi = kron(eye(Pre_Step), R);
    
    % F和H矩阵
    F = Gamma' * Omega * Phi;
    H = Psi + Gamma' * Omega * Gamma;
end


