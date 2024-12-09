% 清空环境
clear; clc; close all;

map();
hold on;

%% 1. 导入规划生成的轨迹

filename = 'Tra_complete.xlsx'; % 替换为您的实际文件路径
trajectory_array = readmatrix(filename); % 读取 Excel 
trajectory_array(:,3)=trajectory_array(:,3)/1000;
n = size(trajectory_array, 1); % 获取轨迹点数

T = 12;  % 总时间
time_traj = linspace(0, T, n)'; % 每个轨迹点的时间戳

% 仿真时间设置
dt = 0.1; % 仿真步长
time_sim = 0:dt:T; % 仿真时间向量

% 插值轨迹 (如果仿真步长与轨迹点数不一致)
trajectory_interp = interp1(time_traj, trajectory_array, time_sim, 'linear'); % 插值轨迹
trajectory_d_interp = gradient(trajectory_interp, dt); % 计算轨迹导数


%% 3. 初始化 iLQR 参数
N = length(time_sim); % 轨迹时间步数
state_dim = 6; % 状态维度
control_dim = 6; % 控制维度

% **使用提供的初始状态**
eta = [58; 28; -3.29; 0; 0; 0]; % 初始状态
eta_history = []; % 历史状态记录
control_input_history = []; % 控制输入记录
error_history = []; % 误差历史记录

% % 初始控制输入
 nu_sequence = zeros(control_dim, N); % 初始化控制输入序列
% nu_sequence(4:6, :) = 0.4; % 初始化角速度输入

 %nu_sequence(:,1) =[1.77;6.23;-0.55;1.18;8.4;-5.86]; % 初始化控制输入序列
 nu_sequence(:,1) =[0;0;0;0;0;0]; % 初始化控制输入序列

XYmax_linear_speed = 70; % 最大平动速度
Zmax_linear_speed = 50;    
max_angular_speed = 0.5; % 最大角速度 (rad/s)围

% 定义代价函数权重
Q = diag([150, 150, 150, 1, 1, 1]); % 状态误差权重
R = diag([0.01, 0.01, 0.01, 0.01, 0.01, 0.01]); % 控制输入权重

% 迭代优化参数
max_iterations = 200; % 最大迭代次数
convergence_threshold = 1e-17; % 收敛阈值

%% 3. iLQR 迭代优化
for iter = 1:max_iterations
    % 初始化前向传播
    eta_sequence = zeros(state_dim, N);
    eta_sequence(:, 1) = eta; % **从提供的初始状态开始**

    % 前向传播：基于当前控制输入生成轨迹
    for k = 1:N-1
        % 当前状态
        phi = eta_sequence(4, k);
        theta = eta_sequence(5, k);
        psi = eta_sequence(6, k);

        % 更新 B 矩阵 (基于当前姿态)
        J = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
             0, cos(phi), -sin(phi);
             0, sin(phi)/cos(theta), cos(phi)/cos(theta)];

        % 定义旋转矩阵
        Rx = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
        Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
        Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

        % 定义总旋转矩阵
        Rm = Rz * Ry * Rx;
        B_t = [Rm, zeros(3, 3); zeros(3, 3), J];

      
        A = zeros(6, 6); % 假设线性化后的 A 矩阵为零
            
        C=zeros(6, 6);

        D=zeros(6,6);
        

        [A,B_t]=dis(A,B_t,C,D);

        % 当前控制输入

        nu = nu_sequence(:, k);
        
        nu(1:2) = max(min(nu(1:2), XYmax_linear_speed), -XYmax_linear_speed); % 限制平动速度
        nu(3) = max(min(nu(3), Zmax_linear_speed), -Zmax_linear_speed); % 限制平动速度

        nu(4:6) = max(min(nu(4:6), max_angular_speed), -max_angular_speed); % 限制角速度



        % 更新状态
        eta_sequence(:, k+1) = A*eta_sequence(:, k) + B_t * nu;
    end

    % 反向传播：计算控制增量
    Vx = zeros(state_dim, 1); % 值函数的一阶导
    Vxx = Q; % 值函数的二阶导

    for k = N:-1:1
        % 当前状态和目标状态
        phi = eta_sequence(4, k);
        theta = eta_sequence(5, k);
        psi = eta_sequence(6, k);
        eta_d_t = [trajectory_interp(k, :)']; % 插值的目标状态

        % 更新 B 矩阵
        J = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
             0, cos(phi), -sin(phi);
             0, sin(phi)/cos(theta), cos(phi)/cos(theta)];
        
                % 定义旋转矩阵
        Rx = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
        Ry = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
        Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

        % 定义总旋转矩阵
        Rm = Rz * Ry * Rx;
        B_t = [Rm, zeros(3, 3); zeros(3, 3), J];
        
   
        % 计算误差
        delta_eta = eta_sequence(:, k) - eta_d_t;
        

        % 线性化系统矩阵
        A_t = zeros(state_dim, state_dim); 
        
        % 控制增益矩阵和修正量
        Qx = Q * delta_eta;
        Qu = R * nu_sequence(:, k);

        Qux = B_t' * Vxx * A_t;
        Quu = R + B_t' * Vxx * B_t;

        % 确保 Quu 可逆
        if rcond(Quu) < 1e-6
            Quu = Quu + eye(control_dim) * 1e-6;
        end

        % 控制增益和修正量
        K_t = -inv(Quu) * Qux;
        k_t = -inv(Quu) * (Qu + B_t' * Vx);

        % 更新值函数
        Vx = Qx + K_t' * Quu * k_t;
        Vxx = Q + K_t' * Quu * K_t;

        % 更新控制输入
        nu_sequence(:, k) = nu_sequence(:, k) + K_t * delta_eta + k_t;
    end

    % 检查收敛
    if norm(delta_eta) < convergence_threshold
        disp(['Converged at iteration ', num2str(iter)]);
        break;
    end
end

%% 4. 仿真和可视化
for k = 1:N
    eta_history = [eta_history; eta_sequence(1:6, k)'];
    error_history = [error_history; norm(eta_sequence(1:6, k) - trajectory_interp(k, :)')];
    control_input_history = [control_input_history, nu_sequence(:, k)];
end


% 绘制轨迹
plot3(eta_history(:, 1), eta_history(:, 2), eta_history(:, 3)*1000, 'y', 'DisplayName', 'Actual Path');
hold on;
plot3(trajectory_interp(:, 1), trajectory_interp(:, 2), trajectory_interp(:, 3)*1000, 'r--', 'DisplayName', 'Desired Path');
xlabel('X'); ylabel('Y'); zlabel('Z');
legend;
title('3D Trajectory Tracking with iLQR');
grid on;

% 绘制误差曲线
figure;
plot(time_sim, error_history, 'k', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Tracking Error');
title('iLQR Tracking Error Over Time');
grid on;

writematrix(error_history, 'iLQR_error.xlsx');


%% 5.离散化计算
function [A,B]=dis(A,B,C,D)

    A = double(A);
    B = double(B);
    C = double(C);
    D = double(D);
% 创建状态空间连续时间模型
sys_cont = ss(A, B, C, D);

% 离散化系统，假设采样时间 Ts = 0.1 秒
Ts = 0.1;
sys_discrete = c2d(sys_cont, Ts);

% 提取离散时间系统的 A 和 B 矩阵
A = sys_discrete.A;
B = sys_discrete.B;
end