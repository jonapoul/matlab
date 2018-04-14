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

% Initialise video
Stack = dbstack();
ScriptName = Stack(1).file;
Dot = strfind(ScriptName, '.');
ScriptName = extractBefore( ScriptName, Dot(1) );
Video = VideoWriter(['plots/',ScriptName,'.avi']);
Video.FrameRate = 3; 
Video.Quality = 100; 
open(Video);

logscale = [1e-3 1e-2 1e-1 1e0 1e1 1e2 1e3];
logticks = cellstr(['1e-3'; '1e-2'; '1e-1'; '1e0 '; '1e1 '; '1e2 '; '1e3 ']);

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

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0];
 fig = scatter(D.f_H1, D.f_He2, 2, log10(D.D ./ mean(D.D))); 
 set(gca,'XScale','log', 'YScale','log');
 colourbar = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','$$\rho/\bar{\rho}$$','interpreter','latex')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa; nSources=%d',TimeDump, NumSources)]);
 xlabel('HI Fraction');
 ylabel('HeII Fraction');
 xlim([1e-9 1]);
 ylim([1e-9 1]);
 hold all; drawnow;
 writeVideo(Video, getframe(gcf,rect));
 close
end

% Swap videos
close(Video); 
close all