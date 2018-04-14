function plot_sources(NumSources)
    plot_lines = 1;
    plot_labels = 1;
    
    if nargin ~= 1;
        error('Too few input arguments.');
    end
    
    centres = 'centres_sorted.dat';
    if ~exist(centres, 'file');
        error('"%s" doesn''t exist', centres);
    end
    
    data = importdata(centres);
    
    % cut off the number of sources from the top row
    TotalSources = data(1);
    data = data(2:end) * 10;
    if NumSources <= 0 || NumSources > TotalSources; 
        NumSources = TotalSources;
    end
    
    % grab the x/y/z values from the linear array
    X = zeros(NumSources,1);
    Y = zeros(NumSources,1);
    Z = zeros(NumSources,1);
    for i = 1 : NumSources;
        X(i) = data(3*i-2);
        Y(i) = data(3*i-1);
        Z(i) = data(3*i-0);
        %fprintf('%d & %.2f & %.2f & %.2f \\\\\n', i, X(i), Y(i), Z(i));
    end

    % For projecting each of the three planes
    Xproj = ones(NumSources,1) * 0;
    Yproj = ones(NumSources,1) * 10;
    Zproj = ones(NumSources,1) * 0;
    
    blue   = [0.000,  0.447,  0.741];
    yellow = [0.929,  0.694,  0.125];
    green  = [0.466,  0.674,  0.188];
    
    fig = figure;
    fig.Color = 'w';
    hold on;
    p = scatter3(X, Y, Z, 'filled');
    p.MarkerFaceColor = 'r';
    p.SizeData = 50;
    xyp = scatter3(X, Y, Zproj, 'filled');
    xyp.MarkerFaceColor = blue;
    xyp.SizeData = 25;
    xzp = scatter3(X, Yproj, Z, 'filled');
    xzp.MarkerFaceColor = yellow;
    xzp.SizeData = 25;
    yzp = scatter3(Xproj, Y, Z, 'filled');
    yzp.MarkerFaceColor = green;
    yzp.SizeData = 25;
    
    
    for idx = 1 : NumSources;
        if plot_lines;
            lineX = [X(idx) Xproj(idx)];
            lineY = [Y(idx) Y(idx)];
            lineZ = [Z(idx) Z(idx)];
            line(lineX, lineY, lineZ, 'Color',green);
            lineX = [X(idx) X(idx)];
            lineY = [Y(idx) Yproj(idx)];
            lineZ = [Z(idx) Z(idx)];
            line(lineX, lineY, lineZ, 'Color',yellow);
            lineX = [X(idx) X(idx)];
            lineY = [Y(idx) Y(idx)];
            lineZ = [Z(idx) Zproj(idx)];
            line(lineX, lineY, lineZ, 'Color',blue);
        end
        if plot_labels;
            text(X(idx),Y(idx),Z(idx)+1,sprintf('%d',idx),'FontWeight','bold');
        end
    end
    hold off;

    ax = gca;
    ax.XLabel.String = 'x (Mpc)';
    ax.YLabel.String = 'y (Mpc)';
    ax.ZLabel.String = 'z (Mpc)';
    ax.XLabel.FontWeight = 'bold';
    ax.YLabel.FontWeight = 'bold';
    ax.ZLabel.FontWeight = 'bold';
    ax.XLim = [0 10];
    ax.YLim = [0 10];
    ax.ZLim = [0 10];
    % Fixed grid values so it doesn't change when we move the camera
    ax.XTick = 0:2:10;
    ax.YTick = 0:2:10;
    ax.ZTick = 0:2:10;
    %ax.Title.String = sprintf('%d Sources', NumSources);
    % Fixed FOV
    ax.CameraViewAngleMode = 'manual';
    ax.CameraViewAngle = 11;
    % orthographic to make it easier to line up with the axis projections
    ax.Projection = 'orthographic';
    ax.Box = 'on';
    grid on;
    % start with x=0 y=0 in the front corner
    view(-45, 45);
    r = rotate3d;
    r.RotateStyle = 'orbit';
    r.Enable = 'on';
    %legend(ax,'Positions','X-Y Projection','X-Z Projection','Y-Z Projection','Location','Best');
end