more off
clf reset
%clearvars -except ScriptIndex AllMatlabFiles

hdr.h100=1; SI='MKS'; Units

Slashes = strfind(pwd, '/');
ParentDir = extractAfter( pwd, Slashes(length(Slashes)) );
Dot = strfind(ParentDir,'.');
if ~isempty(Dot)
 NumSources = str2double( extractBefore(ParentDir, Dot(1)) );
else
 NumSources = str2double( ParentDir );
end
fprintf('PWD = ''%s''\n', pwd);
AllTimeDumps = load('output_times.dat');
NTimeDumps = AllTimeDumps(1);
AllTimeDumps = AllTimeDumps(2:end);

coolingmatches = regexp(ParentDir, '(cooling)', 'match')';
noheliummatches = regexp(ParentDir, '(nohelium)', 'match')';
if ~isempty(noheliummatches) % nohelium run
    LFactor = 365.25 * 86400 * 1e6;
    GFactor = LFactor;
elseif isempty(coolingmatches) % old run
    LFactor = Mpc;
    GFactor = 1;
else % full L range run
    LFactor = 1;
	GFactor = 1;
end

counter = 1;

fprintf('%s Allocating arrays\n', datestr(now,'HH:MM:SS'));
D = readRTdata('save/RTData_t=START');
rhobar = mean(D.D);
t    = zeros(NTimeDumps*D.NumCells, 1);
% n_e  = zeros(NTimeDumps*D.NumCells, 1);
% G    = zeros(NTimeDumps*D.NumCells, 1);
% Gam  = zeros(NTimeDumps*D.NumCells, 1);
% L    = zeros(NTimeDumps*D.NumCells, 1);
T    = zeros(NTimeDumps*D.NumCells, 1);
% CH1  = zeros(NTimeDumps*D.NumCells, 1);
% FH1  = zeros(NTimeDumps*D.NumCells, 1);
FH2  = zeros(NTimeDumps*D.NumCells, 1);
% FHe1 = zeros(NTimeDumps*D.NumCells, 1);
% FHe2 = zeros(NTimeDumps*D.NumCells, 1);
% FHe3 = zeros(NTimeDumps*D.NumCells, 1);
% MJ   = zeros(NTimeDumps*D.NumCells, 1);
% rho  = zeros(NTimeDumps*D.NumCells, 1);

median_t    = zeros(NTimeDumps, 1);
median_ne   = zeros(NTimeDumps, 1);
median_G    = zeros(NTimeDumps, 1);
median_Gam  = zeros(NTimeDumps, 1);
median_L    = zeros(NTimeDumps, 1);
median_T    = zeros(NTimeDumps, 1);
median_CH1  = zeros(NTimeDumps, 1);
median_FH1  = zeros(NTimeDumps, 1);
median_FH2  = zeros(NTimeDumps, 1);
median_FHe1 = zeros(NTimeDumps, 1);
median_FHe2 = zeros(NTimeDumps, 1);
median_FHe3 = zeros(NTimeDumps, 1);
median_MJ   = zeros(NTimeDumps, 1);
stdev_T     = zeros(NTimeDumps, 1);
stdev_FH2   = zeros(NTimeDumps, 1);
stdev_MJ    = zeros(NTimeDumps, 1);
clear D;


% Read the PNG files, add to video
for i = 1 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if (TimeDump == 0.0)
  Dir=dir('save/RTData_t=START');
 else
  Dir=dir(['save/RTData_t=',sprintf('%07.3f',TimeDump)]);
 end
 DataDump=['save/',Dir.name];
 if exist(DataDump, 'file') ~= 2 % if its not a regular file
  continue;
 end
 fprintf('%s %2d/%2d t=%07.3fMa\n', datestr(now,'HH:MM:SS'), i, NTimeDumps, AllTimeDumps(i));
 D = readRTdata(DataDump);

 t   ((i-1)*D.NumCells+1 : i*D.NumCells) = TimeDump;
%  ne_array = plus(times(D.f_H2,D.n_H),times(plus(D.f_He2,2*D.f_He3),D.n_He));
%  n_e ((i-1)*D.NumCells+1 : i*D.NumCells) = ne_array;
%  G   ((i-1)*D.NumCells+1 : i*D.NumCells) = D.G .* GFactor;
%  Gam ((i-1)*D.NumCells+1 : i*D.NumCells) = D.Gamma_HI;
%  L   ((i-1)*D.NumCells+1 : i*D.NumCells) = D.L .* LFactor;
 T   ((i-1)*D.NumCells+1 : i*D.NumCells) = D.T;
%  CH1 ((i-1)*D.NumCells+1 : i*D.NumCells) = D.column_H1;
%  FH1 ((i-1)*D.NumCells+1 : i*D.NumCells) = D.f_H1;
 FH2 ((i-1)*D.NumCells+1 : i*D.NumCells) = D.f_H2;
%  FHe1((i-1)*D.NumCells+1 : i*D.NumCells) = D.f_He1;
%  FHe2((i-1)*D.NumCells+1 : i*D.NumCells) = D.f_He2;
%  FHe3((i-1)*D.NumCells+1 : i*D.NumCells) = D.f_He3;
%  rho ((i-1)*D.NumCells+1 : i*D.NumCells) = D.D;
 
%  A    = 5.1409e-19;
%  n    = D.n_H + D.n_He + ne_array;
%  M_H  = 1.6726219e-27 .* D.n_H;
%  M_He = 6.6464764e-27 .* D.n_He;
%  M_e  = 9.10938356e-31 .* ne_array;
%  mbar = (M_H + M_He + M_e) ./ n;
%  MJ_t = A.*(n .^ -0.5).*(D.T .^ 1.5).*(mbar .^ -2);
%  MJ  ((i-1)*D.NumCells+1 : i*D.NumCells) = MJ_t;
 median_t(i)    = TimeDump;
%  median_ne(i)   = median(ne_array);
%  median_G(i)    = median(D.G) * GFactor;
%  median_Gam(i)  = median(D.Gamma_HI);
%  median_L(i)    = median(D.L) * LFactor;
 median_T(i)    = median(D.T);
%  median_CH1(i)  = median(D.column_H1);
%  median_FH1(i)  = median(D.f_H1);
 median_FH2(i)  = median(D.f_H2);
%  median_FHe1(i) = median(D.f_He1);
%  median_FHe2(i) = median(D.f_He2);
%  median_FHe3(i) = median(D.f_He3);
%  median_MJ(i)   = median(MJ_t);
 stdev_FH2(i)   = std(log10(D.f_H2));
 stdev_T(i)     = std(log10(D.T));
%  stdev_MJ(i)    = std(log10(MJ));
end

logscale = -5 : 1 : 0;
logticks = sprintfc('10^{%+d}', logscale)';
logscale = 10.^logscale;

% T_file   = fopen(sprintf('../%03d_T.txt',NumSources),'w');
% FH2_file = fopen(sprintf('../%03d_FH2.txt',NumSources),'w');
% for iPrint = 1 : length(stdev_T);
%     fprintf(T_file,  '%07.3f %f\n',AllTimeDumps(iPrint),stdev_T(iPrint));
%     fprintf(FH2_file,'%07.3f %f\n',AllTimeDumps(iPrint),stdev_FH2(iPrint));
% end
% fclose(T_file);
% fclose(FH2_file);
% return

% FH2_lo = log10(FH2(rho < rhobar));
% tFH2_lo = t(rho < rhobar);
% filtered = find(FH2_lo~=-inf & FH2_lo~=inf & tFH2_lo~=-inf & tFH2_lo~=inf);
% FH2_lo = FH2_lo(filtered);
% tFH2_lo = tFH2_lo(filtered);
% t_ctrs = AllTimeDumps(2:end);
% ctrs = { t_ctrs -10:0.2:0 };
% hist3([tFH2_lo, FH2_lo],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
% S = findobj('type','surf');
% data = get(S,'zdata');
% normalised = data / (length(FH2_lo)/40);
% logged = log10(normalised);
% set(S,'zdata', logged);
% xlabel('$\boldmath{t}$ (Ma)','Interpreter','latex');
% ylabel('$\boldmath{log_{10} X_{HII}}$','Interpreter','latex');
% %title(sprintf('HII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
% %title(sprintf('%d Sources', NumSources),'Color','w','FontSize',20);
% c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
% c.Label.String = 'Normalised Frequency';
% colormap(jet(1024));
% caxis( log10([logscale(1) logscale(end)]) );
% view(2);
% grid off;
% xlim([0 5e2]);
% hold on;
% plot(median_t, log10(median_FH2), 'LineWidth', 2, 'Color', 'black');
% fig = gcf;
% fig.Color = 'w';
% set(fig, 'InvertHardcopy', 'off');
% print -dpng plots/hist_t_vs_FH2_lo.png
% close;
% fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
% close all

% FH2_hi = log10(FH2(rho > rhobar));
% tFH2_hi = t(rho > rhobar);
% filtered = find(FH2_hi~=-inf & FH2_hi~=inf & tFH2_hi~=-inf & tFH2_hi~=inf);
% FH2_hi = FH2_hi(filtered);
% tFH2_hi = tFH2_hi(filtered);
% t_ctrs = AllTimeDumps(2:end);
% ctrs = { t_ctrs -10:0.2:0 };
% hist3([tFH2_hi, FH2_hi],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
% S = findobj('type','surf');
% data = get(S,'zdata');
% normalised = data / (length(FH2_hi)/40);
% logged = log10(normalised);
% set(S,'zdata', logged);
% xlabel('$\boldmath{t}$ (Ma)','Interpreter','latex');
% ylabel('$\boldmath{log_{10} X_{HII}}$','Interpreter','latex');
% %title(sprintf('HII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
% %title(sprintf('%d Sources', NumSources),'Color','w','FontSize',20);
% c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
% c.Label.String = 'Normalised Frequency';
% colormap(jet(1024));
% caxis( log10([logscale(1) logscale(end)]) );
% view(2);
% grid off;
% xlim([0 5e2]);
% hold on;
% plot(median_t, log10(median_FH2), 'LineWidth', 2, 'Color', 'black');
% fig = gcf;
% fig.Color = 'w';
% set(fig, 'InvertHardcopy', 'off');
% print -dpng plots/hist_t_vs_FH2_hi.png
% close;
% fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;

if 0;
tFH2 = t;
filtered = find(FH2~=-inf & FH2~=inf & tFH2~=-inf & tFH2~=inf);
FH2 = FH2(filtered);
tFH2 = tFH2(filtered);
t_ctrs = AllTimeDumps(2:end);
fH2_ctrs = -10 : 0.2 : 0;
fH2_ctrs = 10 .^ (fH2_ctrs);
ctrs = { t_ctrs fH2_ctrs };
fprintf('%d hist\n', counter);
hist3([tFH2, FH2],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
S = findobj('type','surf');
data = get(S,'zdata');
normalised = data / D.NumCells;
logged = log10(normalised);
set(S,'zdata', logged);
%title(sprintf('HII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
%title(sprintf('%d Sources', NumSources),'Color','w','FontSize',20);
c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
c.Label.String = 'Normalised Frequency';
c.Label.FontSize = 12;
c.Color = 'w';
colormap(jet(1024));
caxis( log10([logscale(1) logscale(end)]) );
view(2);
grid off;
xlim([0 5e2]);
ylim([1e-10 1e0]);
hold on;
plot(median_t, median_FH2, 'LineWidth', 2, 'Color', 'black');
fig = gcf;
set(fig, 'InvertHardcopy', 'off');
ax = gca;
ax.YScale = 'log';
ax.XColor = 'w';
ax.YColor = 'w';
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.Color = 'none';
ax.LineWidth = 2;
ax.XLabel.String = 'Time (Myr)';
ax.XLabel.FontWeight = 'bold';
ax.XLabel.FontSize = 14;
ax.YLabel.String = 'HII Fraction';
ax.YLabel.FontWeight = 'bold';
ax.YLabel.FontSize = 14;
fprintf('%d export\n', counter);
export_fig plots/hist_t_vs_FH2.png -transparent
%print -dpng plots/hist_t_vs_FH2.png
close;
fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

% tT = log10(t);
tT = t;
filtered = find(T~=-inf & T~=inf & tT~=-inf & tT~=inf);
T = T(filtered);
tT = tT(filtered);
if (max(T) > min(T))
 t_ctrs = AllTimeDumps(2:end);
 T_ctrs = 0 : 0.2 : 10;
 T_ctrs = 10 .^ (T_ctrs);
 ctrs = { t_ctrs T_ctrs };
 fprintf('%d hist\n', counter);
 hist3([tT, T],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 %title(sprintf('Temperature distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
%  c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
%  c.Label.String = 'Normalised Frequency';
%  c.Label.FontSize = 12;
%  c.Color = 'w';
 map = colormap(hot(1024));
 idx = find(map(:,1)>0.3);
 map = map(idx:end, :);
 map = colormap(map);
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim([0 5e2]);
 ylim([1e0 1e10]);
 hold on;
%  plot(median_t, median_T, 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.InvertHardcopy = 'off';
 fig.Position(3) = fig.Position(3) * 1.25 * 1.25;
 ax = gca;
 ax.Color = 'none';
 ax.YScale = 'log';
 ax.XColor = 'w';
 ax.YColor = 'w';
 ax.FontSize = 12;
 ax.FontWeight = 'bold';
 ax.LineWidth = 2;
%  ax.XLabel.String = 'Time (Myr)';
%  ax.XLabel.FontWeight = 'bold';
%  ax.XLabel.FontSize = 14;
%  ax.YLabel.String = 'Temperature (K)';
%  ax.YLabel.FontWeight = 'bold';
%  ax.YLabel.FontSize = 14;
 fprintf('%d export\n', counter);
 export_fig plots/hist_t_vs_T.png -transparent
%  print -dpng plots/hist_t_vs_T.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

return

G = log10(G);
tG = log10(t);
filtered = find(G~=-inf & G~=inf & tG~=-inf & tG~=inf);
G = G(filtered);
tG = tG(filtered);
if ~isempty(G)
 t_ctrs = log10(AllTimeDumps(2:end));
 minG = floor(min(G));
 maxG = ceil(max(G));
 %ctrs = { t_ctrs -18:0.6:0 };
 ctrs = { t_ctrs minG:(maxG-minG)/50:maxG };
 hist3([tG, G],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
 ylabel('$\log_{10} G$ (J m\textsuperscript{-3} s\textsuperscript{-1})','Interpreter','latex');
 %title(sprintf('Heating rate distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
 c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
 c.Label.String = 'Normalised Frequency';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim(log10([1e-3 5e2]));
 ylim([-15 1]);
 hold on;
 plot(log10(median_t), log10(median_G), 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.Color = 'w';
 set(fig, 'InvertHardcopy', 'off');
 print -dpng plots/hist_t_vs_G.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

L(L<0) = 0;
L = log10(L);
tL = log10(t);
filtered = find(L~=-inf & L~=inf & tL~=-inf & tL~=inf);
L = L(filtered);
tL = tL(filtered);
if ~isempty(L)
 t_ctrs = log10(AllTimeDumps(2:end));
 minL = floor(min(L));
 maxL = ceil(max(L));
 %ctrs = { t_ctrs -18:0.6:0 };
 ctrs = { t_ctrs minL:(maxL-minL)/50:maxL };
 hist3([tL, L],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
 ylabel('$\log_{10} L$ (J m\textsuperscript{-3} s\textsuperscript{-1})','Interpreter','latex');
 %title(sprintf('Cooling rate distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
 c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
 c.Label.String = 'Normalised Frequency';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim(log10([1e-3 5e2]));
 ylim([-30 1]);
 hold on;
 plot(log10(median_t), log10(median_L), 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.Color = 'w';
 set(fig, 'InvertHardcopy', 'off');
 print -dpng plots/hist_t_vs_L.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

MJ = log10(MJ);
tMJ = log10(t);
filtered = find(MJ~=-inf & MJ~=inf & tMJ~=-inf & tMJ~=inf);
MJ = MJ(filtered);
tMJ = tMJ(filtered);
t_ctrs = log10(AllTimeDumps(2:end));
ctrs = { t_ctrs 34 : 0.2 : 48 };
hist3([tMJ, MJ],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
S = findobj('type','surf');
data = get(S,'zdata');
normalised = data / D.NumCells;
logged = log10(normalised);
set(S,'zdata', logged);
xlabel('$\boldmath{t}$ (Ma)','Interpreter','latex');
ylabel('$\boldmath{log_{10} M_{J}}$','Interpreter','latex');
%title(sprintf('HII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
%title(sprintf('%d Sources', NumSources),'Color','w','FontSize',20);
c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
c.Label.String = 'Normalised Frequency';
colormap(jet(1024));
caxis( log10([logscale(1) logscale(end)]) );
view(2);
grid off;
xlim(log10([1e-3 5e2]));
hold on;
plot(log10(median_t), log10(median_MJ), 'LineWidth', 2, 'Color', 'black');
fig = gcf;
fig.Color = 'w';
set(fig, 'InvertHardcopy', 'off');
print -dpng plots/hist_t_vs_MJ.png
close;
fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;

n_e = log10(n_e);
tne = log10(t);
filtered = find(n_e~=-inf & n_e~=inf & tne~=-inf & tne~=inf);
n_e = n_e(filtered);
tne = tne(filtered);
t_ctrs = log10(AllTimeDumps(2:end));
ctrs = { t_ctrs -8:0.5:5 };
hist3([tne, n_e],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
S = findobj('type','surf');
data = get(S,'zdata');
normalised = data / D.NumCells;
logged = log10(normalised);
set(S,'zdata', logged);
xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
ylabel('$\log_{10} n_e$ (m\textsuperscript{-3})','Interpreter','latex');
%title(sprintf('Electron density distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
c.Label.String = 'Normalised Frequency';
colormap(jet(1024));
caxis( log10([logscale(1) logscale(end)]) );
view(2);
grid off;
xlim(log10([1e-3 5e2]));
hold on;
plot(log10(median_t), log10(median_ne), 'LineWidth', 2, 'Color', 'black');
fig = gcf;
fig.Color = 'w';
set(fig, 'InvertHardcopy', 'off');
print -dpng plots/hist_t_vs_ne.png
close;
fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;

Gam = log10(Gam);
tGam = log10(t);
filtered = find(Gam~=-inf & Gam~=inf & tGam~=-inf & tGam~=inf);
Gam = Gam(filtered);
tGam = tGam(filtered);
if ~isempty(Gam)
 t_ctrs = log10(AllTimeDumps(2:end));
 ctrs = { t_ctrs -23:0.5:-6 };
 hist3([tGam, Gam],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
 ylabel('$\log_{10} \Gamma_{HI}$ (m\textsuperscript{-3} s\textsuperscript{-1} Hz\textsuperscript{-1})','Interpreter','latex');
 %title(sprintf('HI Photoionisation rate distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
 c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
 c.Label.String = 'Normalised Frequency';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim(log10([1e-3 5e2]));
 hold on;
 plot(log10(median_t), log10(median_Gam), 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.Color = 'w';
 set(fig, 'InvertHardcopy', 'off');
 print -dpng plots/hist_t_vs_GammaHI.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

CH1 = log10(CH1);
tCH1 = log10(t);
filtered = find(CH1~=-inf & CH1~=inf & tCH1~=-inf & tCH1~=inf);
CH1 = CH1(filtered);
tCH1 = tCH1(filtered);
t_ctrs = log10(AllTimeDumps(2:end));
ctrs = { t_ctrs 17:0.2:27 };
hist3([tCH1, CH1],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
S = findobj('type','surf');
data = get(S,'zdata');
normalised = data / D.NumCells;
logged = log10(normalised);
set(S,'zdata', logged);
xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
ylabel('$\log_{10} N_{HI}$ (m\textsuperscript{-2})','Interpreter','latex');
%title(sprintf('HI column density distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
c.Label.String = 'Normalised Frequency';
colormap(jet(1024));
caxis( log10([logscale(1) logscale(end)]) );
view(2);
grid off;
xlim(log10([1e-3 5e2]));
hold on;
plot(log10(median_t), log10(median_CH1), 'LineWidth', 2, 'Color', 'black');
fig = gcf;
fig.Color = 'w';
set(fig, 'InvertHardcopy', 'off');
print -dpng plots/hist_t_vs_CH1.png
close;
fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;

FH1 = log10(FH1);
tFH1 = t;
filtered = find(FH1~=-inf & FH1~=inf & tFH1~=-inf & tFH1~=inf);
FH1 = FH1(filtered);
tFH1 = tFH1(filtered);
t_ctrs = AllTimeDumps(2:end);
ctrs = { t_ctrs -8:0.2:0 };
hist3([tFH1, FH1],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
S = findobj('type','surf');
data = get(S,'zdata');
normalised = data / D.NumCells;
logged = log10(normalised);
set(S,'zdata', logged);
xlabel('$\boldmath{t}$ (Ma)','Interpreter','latex');
ylabel('$\boldmath{log_{10} X_{HI}}$','Interpreter','latex');
%title(sprintf('HII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
%title(sprintf('%d Sources', NumSources),'Color','w','FontSize',20);
c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
c.Label.String = 'Normalised Frequency';
colormap(jet(1024));
caxis( log10([logscale(1) logscale(end)]) );
view(2);
grid off;
xlim([1e-3 5e2]);
hold on;
plot(median_t, log10(median_FH1), 'LineWidth', 2, 'Color', 'black');
fig = gcf;
fig.Color = 'w';
set(fig, 'InvertHardcopy', 'off');
print -dpng plots/hist_t_vs_FH1.png
close;
fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;

FHe1 = log10(FHe1);
tFHe1 = log10(t);
filtered = find(FHe1~=-inf & FHe1~=inf & tFHe1~=-inf & tFHe1~=inf);
FHe1 = FHe1(filtered);
tFHe1 = tFHe1(filtered);
if ~isempty(FHe1) && max(FHe1) > min(FHe1)
 t_ctrs = log10(AllTimeDumps(2:end));
 ctrs = { t_ctrs -15:0.5:0 };
 hist3([tFHe1, FHe1],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
 ylabel('$\log_{10} X_{HeI}$','Interpreter','latex');
 %title(sprintf('HeI fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
 c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
 c.Label.String = 'Normalised Frequency';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim(log10([1e-3 5e2]));
 ylim([-15 0]);
 hold on;
 plot(log10(median_t), log10(median_FHe1), 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.Color = 'w';
 set(fig, 'InvertHardcopy', 'off');
 print -dpng plots/hist_t_vs_FHe1.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

FHe2 = log10(FHe2);
tFHe2 = log10(t);
filtered = find(FHe2~=-inf & FHe2~=inf & tFHe2~=-inf & tFHe2~=inf);
FHe2 = FHe2(filtered);
tFHe2 = tFHe2(filtered);
if ~isempty(FHe2) && max(FHe2) > min(FHe2)
 t_ctrs = log10(AllTimeDumps(2:end));
 ctrs = { t_ctrs -15:0.5:0 };
 hist3([tFHe2, FHe2],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
 ylabel('$\log_{10} X_{HeII}$','Interpreter','latex');
 %title(sprintf('HeII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
 c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
 c.Label.String = 'Normalised Frequency';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim(log10([1e-3 5e2]));
 ylim([-15 0]);
 hold on;
 plot(log10(median_t), log10(median_FHe2), 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.Color = 'w';
 set(fig, 'InvertHardcopy', 'off');
 print -dpng plots/hist_t_vs_FHe2.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end

FHe3 = log10(FHe3);
tFHe3 = log10(t);
filtered = find(FHe3~=-inf & FHe3~=inf & tFHe3~=-inf & tFHe3~=inf);
FHe3 = FHe3(filtered);
tFHe3 = tFHe3(filtered);
if ~isempty(FHe3) && max(FHe3) > min(FHe3)
 t_ctrs = log10(AllTimeDumps(2:end));
 ctrs = { t_ctrs -15:0.5:0 };
 hist3([tFHe3, FHe3],'CDataMode','auto','Ctrs',ctrs,'EdgeColor','interp');
 S = findobj('type','surf');
 data = get(S,'zdata');
 normalised = data / D.NumCells;
 logged = log10(normalised);
 set(S,'zdata', logged);
 xlabel('$\log_{10} t$ (Ma)','Interpreter','latex');
 ylabel('$\log_{10} X_{HeIII}$','Interpreter','latex');
 %title(sprintf('HeIII fraction distribution over time; nSources=%d', NumSources),'Color','w','FontSize',20);
 c = colorbar('Ticks',log10(logscale),'TickLabels',logticks);
 c.Label.String = 'Normalised Frequency';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(end)]) );
 view(2);
 grid off;
 xlim(log10([1e-3 5e2]));
 ylim([-15 0]);
 hold on;
 plot(log10(median_t), log10(median_FHe3), 'LineWidth', 2, 'Color', 'black');
 fig = gcf;
 fig.Color = 'w';
 set(fig, 'InvertHardcopy', 'off');
 print -dpng plots/hist_t_vs_FHe3.png
 close;
 fprintf('%s done %d\n', datestr(now,'HH:MM:SS'),counter); counter=counter+1;
end