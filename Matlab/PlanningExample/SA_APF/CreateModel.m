function model=CreateModel()

    H = imread('ocean1.tif'); % Get elevation data
    MAPSIZE_X = size(H,2); % x index: columns of H
    MAPSIZE_Y = size(H,1); % y index: rows of H
    [X,Y] = meshgrid(1:MAPSIZE_X,1:MAPSIZE_Y); % Create all (x,y) points to plot
    
    % Map limits
    xmin= 1;
    xmax= MAPSIZE_X;
    
    ymin= 1;
    ymax= MAPSIZE_Y;
    
%     zmin = 1000;
%     zmax = 2000;  
 
    % Start and end position
    start_location = [50;10;1000];
    end_location = [250;250;1000];
    
    % Number of path nodes (not including the start position (start node))
    n=20;

    %%%涡流
    lamb_pos=[100,65;90,200;200,180;140,120;235,235];
    lamb_num=size(lamb_pos,1);
%     for i =1:lamb_num
%         Lamb
%     end

    % Incorporate map and searching parameters to a model
    model.start=start_location;
    model.end=end_location;
    model.n=n;
    model.xmin=xmin;
    model.xmax=xmax;

    model.ymin=ymin;
    model.ymax=ymax;

    model.MAPSIZE_X = MAPSIZE_X;
    model.MAPSIZE_Y = MAPSIZE_Y;
    model.X = X;
    model.Y = Y;
    model.H = H;
    model.lamb=lamb_pos;
%     PlotModel(model);
end
