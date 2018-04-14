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
Gam = [];

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

 t   = [t,   TimeDump];
 Gam = [Gam, mean(D.Gamma_HI)];
end

% plot
loglog(t, Gam, '-', 'LineWidth', 2);
title(sprintf('Mean HI Photoionisation Rate; nSources=%d', NumSources));
% ylim([1e0 1e8]);
xlim([0 500]);
xlabel('t (Ma)');
ylabel('Gamma_{HI} (m^{3} s^{-1} Hz^{-1})');
eval(['print -dpng plots/',ScriptName,'.png']);