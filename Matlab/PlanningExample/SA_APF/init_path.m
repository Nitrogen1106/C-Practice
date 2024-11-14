function initial_path=init_path(model)
    load initial_path.mat
     
    x_max=model.xmax;
    y_max=model.ymax;
    x_min=model.xmin;
    y_min=model.ymin;

    n=model.n;
    
    initial_path.x=pth(1,2:21);
    initial_path.y=pth(2,2:21);
    
    initial_path.z=1000*ones(1,n);
    initial_path.x=min(initial_path.x,x_max);
    initial_path.x=max(initial_path.x,x_min);
    initial_path.y=min(initial_path.y,y_max);
    initial_path.y=max(initial_path.y,y_min);
end