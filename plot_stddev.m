close all
basedir = 'M:/MATLAB/FH2_T';
runs = {'001','002','005','010','020','050'};
numruns = str2double(runs)';
titles = {'1 Source','2 Sources','5 Sources','10 Sources','20 Sources','50 Sources'};
orange = [255/255 165/255 0/255];
blue = [100/255 100/255 255/255];
yellow = [230/255 230/255 0/255];
colours = {'r',orange,yellow,'g','c',blue};

fig = figure;
hold on;
fH2ends = zeros(length(runs),1);
for i = 1 : length(runs);
    fH2 = importdata(sprintf('%s/%s_FH2.txt',basedir,runs{i}));
    t = fH2(:,1);
    fH2 = fH2(:,2);
    fH2ends(i) = fH2(end);
    p = plot(t, fH2);
    p.LineWidth = 3;
    p.Color = colours{i};
end
ax = gca;
% ax.Title.String = 'HII Fraction distribution width over time';
% ax.XScale = 'log';
ax.XLim = [0 5e2];
ax.FontWeight = 'bold';
xlabel('Time (Myr)');
ylabel('Standard Deviation of log_{10}(X_{HII}) distribution');
l = legend(titles);
l.Location = 'northeast';
legend('boxoff');
fig.InvertHardcopy = 'off';
% fig.Color = 'w';
fig.Position(3) = 1100;
fig.Position(4) = 380;
% eval(['print -depsc ' sprintf('%s/FH2_width.eps',basedir)]);
%eval(['print -dpng ' sprintf('%s/FH2_width.png',basedir)]);

fig = figure;
ax = gca;
hold(ax, 'on');
subax = axes;
hold(subax, 'on');
Tends = zeros(length(runs),1);
for i = 1 : length(runs);
    T = importdata(sprintf('%s/%s_T.txt',basedir,runs{i}));
    t = T(:,1);
    T = T(:,2);
    Tends(i) = T(end);
	p = plot(ax, t, T);
    p.LineWidth = 1.5;
    p.Color = colours{i};
    subp = plot(subax, t, T);
    subp.LineWidth = 3;
    subp.Color = colours{i};
end
% ax.Title.String = 'Temperature distribution width over time';
ax.XScale = 'log';
ax.XLim = [1e-3 5e2];
ax.XLabel.String = 'Time (Myr)';
ax.YLabel.String = 'Standard Deviation of log_{10}(T) distribution';
ax.FontWeight = 'bold';
l = legend(ax,titles);
l.Location = 'northeast';
l.Box = 'off';

% ybox2 = 0.25;
% ybox1 = 0.11;
% xbox2 = 500;
% xbox1 = 100;
% x = [xbox1, xbox1, xbox2, xbox2, xbox1];
% y = [ybox1, ybox2, ybox2, ybox1, ybox1];
% boxplot = plot(ax, x, y);
% boxplot.LineWidth = 1;
% boxplot.Color = 'black';
% boxplot.LineStyle = '-';

subax.Position = [0.2 0.2 0.3 0.5];
subax.XScale = 'log';
subax.FontWeight = 'bold';
subax.XLim = [xbox1 xbox2];
subax.YLim = [ybox1 ybox2];
box on;

fig.InvertHardcopy = 'off';
fig.Position(3) = 1100;
fig.Position(4) = 380;

% eval(['print -depsc ' sprintf('%s/T_width.eps',basedir)]);
%eval(['print -dpng ' sprintf('%s/T_width.png',basedir)]);

close all;