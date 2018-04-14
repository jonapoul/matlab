more off
clf reset
clearvars -except ScriptIndex AllMatlabFiles

hdr.h100=1; SI='MKS'; Units

% Converts the string /foo/bar/Runs/whatever/010/ to the integer 10
parts = strsplit(pwd, '/');
ParentDir = parts{end};
if strcmpi(parts{end-1}, 'Cosmological');
 Dot = strfind(ParentDir,'.');
 if length(Dot) > 0
  NumSources = str2num( extractBefore(ParentDir, Dot(1)) );
 else
  NumSources = str2num( ParentDir );
 end
else
 NumSources = 1;
end
fprintf('PWD = ''%s''\n', pwd);
AllTimeDumps = load('output_times.dat');

% Initialise video
Stack = dbstack();
ScriptName = Stack(1).file;
Dot = strfind(ScriptName, '.');
ScriptName = extractBefore( ScriptName, Dot(1) );
VideoLog = VideoWriter(['plots/',ScriptName,'_log.avi']);
VideoLin = VideoWriter(['plots/',ScriptName,'_lin.avi']);
VideoLog.FrameRate = 3; VideoLin.FrameRate = 3;
VideoLog.Quality = 100; VideoLin.Quality = 100;
open(VideoLog); open(VideoLin);

logscale=[1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e+0];
logticks=cellstr(['1e-8'; '1e-7'; '1e-6'; '1e-5'; '1e-4'; '1e-3'; '1e-2'; '1e-1'; '1e+0']);
D = readRTdata('save/RTData_t=000.001');
Rmax = max(D.R);
clear D;

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
 divided = rdivide(D.R, Rmax);

 fig = scatter(divided, D.T, 2, log10(D.f_H2));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','HII Fraction')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('T (K)');
 xlim([0 1]);
 ylim([1e0 1e10]);
 hold all; drawnow;
 writeVideo(VideoLog, getframe(gcf,rect));

 fig = scatter(divided, D.T, 2, log10(D.f_H2));
 set(gca,'XScale','linear', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','HII Fraction')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('T (K)');
 xlim([0 1]);
 ylim([1e0 1e10]);
 hold all; drawnow;
 writeVideo(VideoLin, getframe(gcf,rect));

 close;
 clear D;
end

% Close the Videos
close(VideoLog); close(VideoLin);