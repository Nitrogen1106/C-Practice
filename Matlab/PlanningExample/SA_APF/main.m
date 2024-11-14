clc;clear;close all;
%%%地图
map();
model = CreateModel(); 


%%%%SA参数
idx=0;
step=1.2;
k=2;
initial_path=init_path(model);
path=figuresol(initial_path,model,0.9);

% 绘制初始路径线和航路点
plot3(path(1, :), path(2, :), path(3, :), '-o', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'r'); % 绘制路径线
scatter3(path(1, :), path(2, :), path(3, :), 'filled'); % 绘制航路点


n=model.n;
x_max=model.xmax;
y_max=model.ymax;
x_min=model.xmin;
y_min=model.ymin;
tem=1000000;
c=0.99;

SA_icost_history=[];


%%%%SA%%%%%
while(tem>1)


    dx=-step*ones(1,n)+2.1*step*rand(1,n);
    dy=-step*ones(1,n)+2.5*step*rand(1,n);
    dz=-step*ones(1,n)+4*step*rand(1,n);

    next_path.x=initial_path.x+dx;
    next_path.y=initial_path.y+dy;
    next_path.z=initial_path.z+dz;
    next_path.x=min(next_path.x,x_max);
    next_path.x=max(next_path.x,x_min);
    next_path.y=min(next_path.y,y_max);
    next_path.y=max(next_path.y,y_min);
    %%%目标函数
    icost=fcost(initial_path,model);
    ncost=fcost(next_path,model);
    SA_icost_history = [SA_icost_history icost];

    %%%退火
    if ncost<icost
        initial_path=next_path;
    else
        dE=ncost-icost;
        P=exp(dE/k/tem);
        if rand>P
           initial_path=next_path; 
        end
    end
    idx=idx+1;
    tem=tem*c;
    end


    path=initial_path;



path=figuresol(path,model,0.9);


% 绘制SA的路径线和航路点
plot3(path(1, :), path(2, :), path(3, :), '-o', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'b'); % 绘制路径线
scatter3(path(1, :), path(2, :), path(3, :), 'filled','r'); % 绘制航路点
hold on


% 鱼群参数
fish_pos=[120,145,-3050;150,50,-150;230,30,-1000];
fish1=[];
fish2=[];
fish3=[];

pos_x=path(1,1);
pos_y=path(2,1);
pos_z=path(3,1);
gi=2;
position_accuracy=40;
apf_path=[pos_x pos_y pos_z];
% f=[];
while norm([pos_x pos_y pos_z]-[path(1,22) path(2,22) path(3,22)])>position_accuracy
    fish1=[fish_pos(1,:)];
    fish2=[fish_pos(2,:)];
    fish3=[fish_pos(3,:)];
    scatter3(fish1(1),fish1(2),fish1(3),'r*');
    hold on
    scatter3(fish2(1),fish2(2),fish2(3),'y*');
    scatter3(fish3(1),fish3(2),fish3(3),'g*');
    fish_pos=fish(fish_pos);

    % APF
    goal_x=path(1,gi);
    goal_y=path(2,gi);
    goal_z=path(3,gi);
    if norm([pos_x pos_y pos_z]-[goal_x goal_y goal_z])>position_accuracy
        VAPF=APF(pos_x,pos_y,pos_z,goal_x,goal_y,goal_z,fish_pos);
        pos_x=VAPF.x;
        pos_y=VAPF.y;
        pos_z=VAPF.z;
    else
        VAPF=APF(pos_x,pos_y,pos_z,goal_x,goal_y,goal_z,fish_pos);
        gi=gi+1;
        goal_x=path(1,gi);
        goal_y=path(2,gi);
        goal_z=path(3,gi);
    end
    newp=[pos_x pos_y pos_z];

    apf_path=[apf_path;newp];

    scatter3(pos_x,pos_y,pos_z,'c')
      pause(0.1);
end

%绘制APF航路点
plot3(apf_path(:,1),apf_path(:,2),apf_path(:,3),'r','LineWidth',2)


% 计算最小值和最大值
min_icost = min(SA_icost_history);
max_icost = max(SA_icost_history);

% 归一化处理
normalized_icost_history = (SA_icost_history - min_icost) / (max_icost - min_icost);

% 绘制归一化的icost折线图
figure;
plot(normalized_icost_history, 'LineWidth', 2);
title('Normalized Cost Function Value over Iterations');
xlabel('Iteration');
ylabel('Normalized Cost Function Value');
grid on;

%% SA与APF代价函数比较
algor_campare(path,apf_path,model);


