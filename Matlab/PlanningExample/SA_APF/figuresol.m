%% 涡流与路径设置
function path=figuresol(sol,model,smooth)

    %% Plot 3D view
    figure(1)
%     PlotModel(model)
%     map();
    hold on
    x=sol.x;
    y=sol.y;
    z=sol.z;
    
    % Start location
    xs=model.start(1);
    ys=model.start(2);
    zs=model.start(3);
    
    % Final location
    xf=model.end(1);
    yf=model.end(2);
    zf=model.end(3);
    
    x_all = [xs x xf];
    y_all = [ys y yf];
    z_all = [zs z zf];
    
    N = size(x_all,2); % real path length
    
   % Path height is relative to the ground height
    for i = 1:N
        z_map = model.H(round(y_all(i)),round(x_all(i)));
        z_all(i) = z_all(i) + z_map;
    end
    
    % given data in a point matrix, xyz, which is 3 x number of points
    xyz = [x_all;y_all;z_all];
    [ndim,npts]=size(xyz);
    xyzp=zeros(size(xyz));
    for k=1:ndim
       xyzp(k,:)=ppval(csaps(1:npts,xyz(k,:),smooth),1:npts);
    end
    path=xyzp;

    hold on


    lamb_num=size(model.lamb,1);
    for i = 1:lamb_num
        lamb = model.lamb(i,:);
        lamb_x = lamb(1);
        lamb_y = lamb(2);
        lamb_z = -4000;
        threat_radius = 10;
        h=4000;

        [xc,yc,zc]=cylinder(threat_radius); % create a unit cylinder
        % set the center and height 
        xc=xc+lamb_x;  
        yc=yc+lamb_y;
        zc=zc*h+lamb_z;
        c=mesh(xc,yc,zc); % plot the cylinder 
        set(c,'edgecolor','none','facecolor','#FF0000','FaceAlpha',.3); % set color and transparency
    end
 


end