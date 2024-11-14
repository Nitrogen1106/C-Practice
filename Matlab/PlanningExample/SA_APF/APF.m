function VAPF = APF(x, y,z, x_goal, y_goal,z_goal, obstacle)
    

    % 参数设置
    VAPF.zeta = 1.1547; %引力系数
    VAPF.eta = 2000;     %斥力系数
    VAPF.dstar = 800;     %引力范围
    VAPF.Qstar = 90;     %斥力范围
   
  
    VAPF.x = x;
    VAPF.y = y;
    VAPF.z = z;
    Obstacle_count = size(obstacle,1);
    % VAPF.obsd=ones(1,Obstacle_count)*inf;

    nablaU_att = [0 0 0];
    % 吸引力
    if norm([x y z]-[x_goal y_goal z_goal]) <= VAPF.dstar
        nablaU_att =  VAPF.zeta*([x y z]-[x_goal y_goal z_goal]);
    else 
        nablaU_att = VAPF.dstar/norm([x y z]-[x_goal y_goal z_goal]) * VAPF.zeta*([x y z]-[x_goal y_goal z_goal]);
    end

    % 斥力
    obst_dist = zeros(1,Obstacle_count);
    nablaU_rep = [0 0 0];
    for i=1:Obstacle_count
        obst_dist(i) = norm([obstacle(i,1),obstacle(i,2),obstacle(i,3)]-[x,y,z]);
        if obst_dist(i) <= VAPF.Qstar     
                nablaU_rep = nablaU_rep + (VAPF.eta*(1/VAPF.Qstar - 1/obst_dist(i)) * 1/obst_dist(i)^2)*([x y z] - [obstacle(i,1) obstacle(i,2) obstacle(i,3)]);
        end
    end
      
    % 总势场


    nablaU = nablaU_att+nablaU_rep.*5;

    % 更新位置
    v=0.2;
    VAPF.x = VAPF.x -nablaU(1)*v;
    VAPF.y = VAPF.y -nablaU(2)*v;
    VAPF.z = VAPF.z -nablaU(3)*v;
    
   
end