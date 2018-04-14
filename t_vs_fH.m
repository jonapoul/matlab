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
fH1 = [];
fH2 = [];

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
 fprintf('%s %2d/%2d Opening %s ...\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), Dir.name);
 D = readRTdata(DataDump);

 t   = [t,   TimeDump];
 fH1 = [fH1, mean(D.f_H1)];
 fH2 = [fH2, mean(D.f_H2)];
end

% plot
fig = figure;
fig = plot(t, fH1, '-', 'LineWidth', 2);
hold on;
fig = plot(t, fH2, '-', 'LineWidth', 2);
title(sprintf('Mean Hydrogen species fractions over time; nSources=%d', NumSources));
ylim([0 1]);
xlim([0 500]);
xlabel('t (Ma)');
ylabel('Fraction');
legend('HI', 'HII', 'Location', 'southeast');
eval(['print -dpng plots/',ScriptName,'.png']);
