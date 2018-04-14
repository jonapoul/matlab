close all
clear all

filename = '0627320.txt';
data = importdata(filename);

nH     = data(:,2) + data(:,3);

iter   = data(:,1);
nH1    = data(:,2) ./ nH;
nH2    = data(:,3) ./ nH;
nH1SS  = data(:,4) ./ nH;
nH2SS  = data(:,5) ./ nH;
dNH1dt = data(:,6);
dt     = data(:,7);
ne     = data(:,8);
alpha  = data(:,9);
IH1    = data(:,10);
fields = {'iter','nH1','nH2','nH1SS','nH2SS','dNH1dt','dt','ne','alpha','IH1'};

hold on;
minData = 2;
maxData = 5;
% for i = minData : maxData;
%     p = plot(iter, data(:,i));
%     p.LineWidth = 1.5;
% end
p = plot(iter, data(:,3));
p = plot(iter, data(:,5));
p.LineWidth = 1.5;
ax = gca;
xlabel('Iteration Number');
legend(fields(minData:maxData),'location','northeast');
% ax.XScale = 'log';
ax.YScale = 'log';
xlim([20 200]);
fig = gcf;
fig.Color = 'w';
grid on


hold off;
