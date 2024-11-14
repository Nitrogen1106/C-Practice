%% 代价函数
function cost = fcost(sol, model)

    J_inf = 10^12;
    n = model.n;
    H = model.H;

    % Input solution
    x = sol.x;
    y = sol.y;
    z = sol.z;

    x_all = sol.x;
    y_all = sol.y;
    z_all = sol.z;

    N = size(x_all, 2); % Full path length

    % Altitude wrt sea level = z_relative + ground_level
    z_abs = zeros(1, N);

    for i = 1:N
        z_abs(i) = z_all(i) + H(round(y_all(i)), round(x_all(i)));
    end

    %============================================
    % F1 - 路径长度代价
    F1 = 0;
    for i = 1:N-1
        diff = [x_all(i+1) - x_all(i); y_all(i+1) - y_all(i); z_abs(i+1) - z_abs(i)];
        F1 = F1 + norm(diff);
    end
    % 打印 F1 值
    disp(['F1 (路径长度代价): ', num2str(F1)]);

    %==============================================
    % F2 - 能耗
    lambn = size(model.lamb, 1);
    F2 = 0;
    q = 1; % 水密度
    t = 1;
    r = 10;
    for i = 1:N-1
        vc = zeros(lambn, 2);
        di = [x_all(i+1)-x_all(i), y_all(i+1)-y_all(i)];
        vg = di / t;
        for j = 1:lambn
            if norm([x_all(i), y_all(i)] - [model.lamb(j, 1), model.lamb(j, 2)]) < r
                F2 = F2 + J_inf;
            end
            vc(j, :) = Lamb(x_all(i), y_all(i), model.lamb(j, 1), model.lamb(j, 2));
            va = vg - vc(j, :);
            if norm(vg) ~= 0
                F2 = F2 + (norm(q * va)^3) * (norm(di) / norm(vg));
            else
                F2 = F2 + 0;
            end

        end
    end
    % 打印 F2 值
    disp(['F2 (能耗): ', num2str(F2)]);

    %==============================================
    % F3 - 地形
    F3 = 0;
    J3_node = 0;
    for i = 1:n
        if z(i) < 0 % crash into ground
            J3_node = J_inf;
         % elseif z(i) >4000
         %     J3_node = J_inf;

        end
        F3 = F3 + J3_node;
    end
    % 打印 F3 值
    disp(['F3 (地形): ', num2str(F3)]);

    %==============================================
    % F4 - 平滑度
    F4 = 0;
    % 设置最大限制角
    turning_max = 45;
    climb_max = 45;

    % 计算投影至XY面
    for i = 1:N-2
        for j = i:-1:1
            segment1_proj = [x_all(j+1); y_all(j+1); 0] - [x_all(j); y_all(j); 0];
            if nnz(segment1_proj) ~= 0
                break;
            end
        end

        for j = i:N-2
            segment2_proj = [x_all(j+2); y_all(j+2); 0] - [x_all(j+1); y_all(j+1); 0];
            if nnz(segment2_proj) ~= 0
                break;
            end
        end

        % 两端路径转向角
        climb_angle1 = atan2d(z_abs(i+1) - z_abs(i), norm(segment1_proj));
        climb_angle2 = atan2d(z_abs(i+2) - z_abs(i+1), norm(segment2_proj));
        turning_angle = atan2d(norm(cross(segment1_proj, segment2_proj)), dot(segment1_proj, segment2_proj));

        if abs(turning_angle) > turning_max
            F4 = F4 + abs(turning_angle);
        end
        if abs(climb_angle2 - climb_angle1) > climb_max
            F4 = F4 + abs(climb_angle2 - climb_angle1);
        end
    end
    % 打印 F4 值
    disp(['F4 (平滑度): ', num2str(F4)]);

    %============================================
    % 目标函数权重
    k1 = 300;
    k2 = 20;
    k3 = 5;
    k4 = 100;

    % Overall cost
    cost = k1 * F1 + k2 * F2 + k4 * F4;
    disp(['Overall cost: ', num2str(cost)]);
end


