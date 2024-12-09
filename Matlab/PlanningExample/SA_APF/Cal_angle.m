% 读取Excel数据，假设Excel表格包含n行3列的数据（每行是一个点的x, y, z坐标）
filename = 'Tra.xlsx'; % 替换为您的实际文件路径
data = readmatrix(filename); % 读取 Excel 

n = size(data, 1);  % 点的数量

% 初始化结果数组（n行6列：3列位置，3列姿态角）
result = zeros(n, 6);

% 将原始位置信息存入结果数组的前3列
result(:, 1:3) = data;

for i = 1:n-1
    % 获取当前点和下一个点的坐标
    x1 = data(i, 1); y1 = data(i, 2); z1 = data(i, 3);
    x2 = data(i+1, 1); y2 = data(i+1, 2); z2 = data(i+1, 3);
    
    % 计算两个点的方向向量（单位化）
    v1 = [x1, y1, z1] / norm([x1, y1, z1]);
    v2 = [x2, y2, z2] / norm([x2, y2, z2]);

    % 检查向量是否为零向量
    if norm(v1) < 1e-6 || norm(v2) < 1e-6
        disp(['Warning: One of the vectors at index ', num2str(i), ' is too small or zero.']);
        continue;  % 跳过这次迭代
    end

    % 计算旋转轴
    axis = cross(v1, v2);
    
    % 检查旋转轴是否为零向量
    if norm(axis) < 1e-6
        disp(['Warning: The rotation axis is zero (vectors are parallel) at index ', num2str(i)]);
        result(i, 4:6) = result(i-1, 4:6);  % 如果轴为零，继承上一个点的姿态角
        continue;  % 跳过这次迭代
    end
    axis = axis / norm(axis);  % 单位化旋转轴
    
    % 计算旋转角度
    angle = acos(dot(v1, v2));
    
    % 检查角度是否有效
    if isnan(angle) || angle > pi || angle < -pi
        disp(['Warning: Invalid rotation angle at index ', num2str(i)]);
        continue;  % 跳过这次迭代
    end
    
    % 构造旋转矩阵
    R = axisAngleToRotationMatrix(axis, angle);
    
    % 检查旋转矩阵是否有效
    if any(isnan(R(:))) || any(isinf(R(:)))
        disp(['Warning: Invalid rotation matrix at index ', num2str(i)]);
        continue;  % 跳过这次迭代
    end
    
    % 提取欧拉角
    theta = atan2(-R(3, 1), sqrt(R(1, 1)^2 + R(2, 1)^2));
    if isnan(theta)
        disp('Warning: Invalid pitch angle.');
        continue;
    end

    phi = atan2(R(2, 1), R(1, 1));
    if isnan(phi)
        disp('Warning: Invalid roll angle.');
        continue;
    end

    psi = atan2(R(3, 2), R(3, 3));
    if isnan(psi)
        disp('Warning: Invalid yaw angle.');
        continue;
    end
    
    % 存储欧拉角到结果数组（第4至第6列）
    result(i, 4:6) = [phi, theta, psi];
end

% 对最后一个点，设置与上一个点相同的姿态角
result(n, 4:6) = result(n-1, 4:6);  % 最后一个点的姿态角与倒数第二个点相同

% 将结果保存为Excel表格
writematrix(result, 'euler_angles_with_position.xlsx');

% 输出计算结果
disp(result);

% 轴角转旋转矩阵的函数
function R = axisAngleToRotationMatrix(axis, angle)
    % 计算旋转矩阵
    c = cos(angle);
    s = sin(angle);
    t = 1 - c;
    
    % 轴的三个分量
    x = axis(1);
    y = axis(2);
    z = axis(3);
    
    % 旋转矩阵公式
    R = [t*x^2 + c, t*x*y - s*z, t*x*z + s*y;
         t*x*y + s*z, t*y^2 + c, t*y*z - s*x;
         t*x*z - s*y, t*y*z + s*x, t*z^2 + c];
end
