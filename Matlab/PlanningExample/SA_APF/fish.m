%% 鱼群设置
function [fish_pos]=fish(fish_pos)
    speed_dir=[0,1,0];
    fish_speed=0.5;
    num=size(fish_pos,1);
    for i=1:num
        fish_pos(i,:)=fish_pos(i,:)+speed_dir*fish_speed;
    end
end