%% 地图绘制
function [X,Y,data,color_data,color_map]=map()
    global data;
    data = imread('ocean1.tif');
    global X;
    global Y;
    [X,Y]=meshgrid(1:size(data,2),1:size(data,1));

    color_data=data;
    color_map=jet;

    figure;
    surf(X,Y,data,color_data,'EdgeColor','none');
    xlabel('X');
    ylabel('Y');
    zlabel('Elevation');
    title('三维水下环境图');
    colormap(color_map);
    colorbar;
end