more off
clf reset
clearvars -except ScriptIndex AllMatlabFiles

% Converts the string /foo/bar/Runs/whatever/010/ to the integer 10
Slashes = strfind(pwd, '/');
ParentDir = extractAfter( pwd, Slashes(length(Slashes)) );
Dot = strfind(ParentDir,'.');
if length(Dot) > 0
 NumSources = str2num( extractBefore(ParentDir, Dot(1)) );
else
 NumSources = str2num( ParentDir );
end
fprintf('PWD = ''%s''\n', pwd);
AllTimeDumps = load('output_times.dat');

Stack = dbstack();
ScriptName = Stack(1).file;
Dot = strfind(ScriptName, '.');
ScriptName = extractBefore( ScriptName, Dot(1) );

t   = [];
tot = [];
H1  = [];
He1 = [];
He2 = [];

% Read the PNG files, add to video
for i = 2 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if (TimeDump == 0.0)
  Dir=dir(['save/RTData_t=START']);
 else
  Dir=dir(['save/RTData_t=',sprintf('%07.3f',TimeDump)]);
 end
 DataDump=['save/',Dir.name];
 if exist(DataDump, 'file') ~= 2 % if its not a regular file
  continue;
 end
 fprintf('%s %2d/%2d t=%07.3fMa\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), AllTimeDumps(i));
 D = readRTdata(DataDump);

 t = [t, TimeDump];
 iTotal = mean(D.column_H1) + mean(D.column_He1) + mean(D.column_He2);
 tot = [tot, iTotal];
 H1  = [H1,  mean(D.column_H1)/iTotal];  
 He1 = [He1, mean(D.column_He1)/iTotal];
 He2 = [He2, mean(D.column_He2)/iTotal];
end

% plot
fig = figure;
fig = loglog(t, times(tot, H1),  '-', 'LineWidth', 2);
hold on;
fig = loglog(t, times(tot, He1), '-', 'LineWidth', 2);
fig = loglog(t, times(tot, He2), '-', 'LineWidth', 2);
fig = loglog(t, tot,             '-', 'LineWidth', 2);
title(sprintf('Mean species column densities over time; nSources=%d', NumSources));
xlim([0 500]);
xlabel('t (Ma)');
ylabel('Species Column Density (m^{-2})');
legend('HI', 'HeI', 'HeII', 'Total');
eval(['print -dpng plots/',ScriptName,'.png']);

t   = [t]';
H1  = [H1]';
He1 = [He1]';
He2 = [He2]';

fig = figure;
fig = area(t, [H1 He1 He2]);
% set(gca,'XScale','log', 'YScale','log');
xlim([0 500]);
ylim([0 1]);
title('Proportion of total column densities from each species');
xlabel('t (Ma)');
ylabel('Proportion');
legend('HI', 'HeI', 'HeII','Location','southeast');
eval(['print -dpng plots/',ScriptName,'_stacked_logY.png']);