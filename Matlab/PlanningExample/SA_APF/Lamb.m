%涡流生成
function [Vc]=Lamb(X,Y,x0,y0)   
% 设置参数
% 涡流强度系数
B=1000;
r = 50;          % 涡流半径
R=norm([X Y]-[x0 y0]);
% 
% uc = (-B * (Y - y0) / (2 * pi * (R - r)^2) )* (1 - exp(-((R-r)^2/ r^2)));
% vc = (-B * (X - x0) / (2 * pi * (R - r)^2) )* (1 - exp(-((R-r)^2/ r^2)));

uc = (-B * (Y - y0) ./ (2 * pi * (R).^2)) .* (1 - exp(-((R).^2 / r^2)));
vc = (B * (X - x0) ./ (2 * pi * (R).^2)) .* (1 - exp(-((R).^2 / r^2)));

% omega =(B / (pi * r^2)) * exp(-((R-r)^2/ r^2));   %涡流的涡度
omega =(B / (pi * r^2)) * exp(-((R)^2/ r^2));   %涡流的涡度
Vc=[uc vc];

end