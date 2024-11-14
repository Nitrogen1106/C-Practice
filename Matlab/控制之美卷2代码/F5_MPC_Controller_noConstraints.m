%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷二》 代码
%% 作者：王天威，黄军魁
%% 清华大学出版社
%% 程序名称：F5_MPC_Controller_noConstraints %% [F5]无约束二次规划求解模块
%% 模块功能：利用二次规划求解模型预测控制中的系统控制量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 输入：二次规划矩阵 F，H； 系统控制量维度 p； 系统状态：x
%% 输出：系统控制（输入） U，u

function [U,u]= F5_MPC_Controller_noConstraints(x,F,H,p)

% 选取最优化求解模式
options = optimset('MaxIter', 200);
% 利用二次规划求解系统控制（输入）
[U, FVAL, EXITFLAG, OUTPUT, LAMBDA] = quadprog(H,F*x,[],[],[],[],[],[],[],options);
% 根据模型预测控制的策略，仅选取所得输入的第一项， 参考（5.3.18）
u = U(1:p,1);
end
