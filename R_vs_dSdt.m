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

logscale=[-1 1];
logticks=cellstr(['Negative'; 'Positive']);
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
 dSdt = times((2/3)*power(D.D,-5/3), D.G-D.L*Mpc);
 Mag = abs(dSdt);
 Sign = rdivide(dSdt, Mag);

 fig = scatter(divided, Mag, 2, Sign);
 set(gca,'XScale','log','YScale','log');
 colourbar=colorbar('YTick',logscale,'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Direction');
 colormap(jet(1024));
 caxis( [-1 1] );
 title([sprintf('t=%07.3fMa, nSources=%d', TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('Entropy Rate (Magnitude) (J K^{-1} s^{-1})');
 xlim([0 1]);
 ylim([1e24 1e38]);
 hold all; drawnow;
 writeVideo(VideoLog, getframe(gcf,rect));

 fig = scatter(divided, Mag, 2, Sign);
 set(gca,'XScale','linear', 'YScale','log');
 colourbar=colorbar('YTick',logscale,'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Direction');
 colormap(jet(1024));
 caxis( [-1 1] );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('Entropy Rate (Magnitude) (J K^{-1} s^{-1})');
 xlim([0 1]);
 ylim([1e24 1e38]);
 hold all; drawnow;
 writeVideo(VideoLin, getframe(gcf,rect));

 close all;
 clear D dSdt Mag Sign;
end

% Close the videos
close(VideoLog);