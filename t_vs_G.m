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

t    = [];
Gtot = [];
GH1  = [];
GHe1 = [];
GHe2 = [];

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
  fprintf('TimeDump = %07.3f Ma doesn''t exist\n', TimeDump); 
  continue;
 end
 fprintf('%s %2d/%2d t=%07.3fMa\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), AllTimeDumps(i));
 D = readRTdata(DataDump);

 t    = [t    TimeDump];
 Gtot = [Gtot mean(D.G)];
 GH1  = [GH1  mean(D.G_H1)/mean(D.G)];
 GHe1 = [GHe1 mean(D.G_He1)/mean(D.G)];
 GHe2 = [GHe2 mean(D.G_He2)/mean(D.G)];
end

t    = [t]';
Gtot = [Gtot]';
GH1  = [GH1]';
GHe1 = [GHe1]';
GHe2 = [GHe2]';

fig = figure;
fig = area(t, [GH1 GHe1 GHe2]);
set(gca,'XScale','log', 'YScale','log');
xlim([1e-3 500]);
ylim([0 1]);
title('Proportion of total heating rate from each process');
xlabel('t (Ma)');
ylabel('Proportion');
legend('G_{H1}', 'G_{He1}', 'G_{He2}', 'Location','northwest');
eval(['print -dpng plots/',ScriptName,'_stacked_logY.png']);

fig = figure;
fig = area(t, [GH1 GHe1 GHe2]);
set(gca,'XScale','log');
xlim([1e-3 500]);
ylim([0 1]);
title('Proportion of total heating rate from each process');
xlabel('t (Ma)');
ylabel('Proportion');
legend('G_{H1}', 'G_{He1}', 'G_{He2}', 'Location','northwest');
eval(['print -dpng plots/',ScriptName,'_stacked_linY.png']);

fig = figure;
fig = loglog(t, times(GH1,Gtot),  '-', 'LineWidth', 2);
hold on;
fig = loglog(t, times(GHe1,Gtot), '-', 'LineWidth', 2);
fig = loglog(t, times(GHe2,Gtot), '-', 'LineWidth', 2);
fig = loglog(t, Gtot,             '-', 'LineWidth', 2);
set(gca,'XScale','log','YScale','log');
xlim([1e-3 500]);
title('Mean heating rates over time');
xlabel('t (Ma)');
ylabel('Species heating rate (J m^{-3} s^{-1})');
legend('G_{H1}', 'G_{He1}', 'G_{He2}', 'G_{total}', 'Location','northwest');
eval(['print -dpng plots/',ScriptName,'_total.png']);
