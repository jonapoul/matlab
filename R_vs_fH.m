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
Video1 = VideoWriter(['plots/',ScriptName,'1.avi']);
Video2 = VideoWriter(['plots/',ScriptName,'2.avi']);
Video1lin = VideoWriter(['plots/',ScriptName,'1_lin.avi']);
Video2lin = VideoWriter(['plots/',ScriptName,'2_lin.avi']);
Video1.FrameRate = 3; Video2.FrameRate = 3; Video1lin.FrameRate = 3; Video2lin.FrameRate = 3;
Video1.Quality   = 70; Video2.Quality  = 70; Video1lin.Quality  = 70; Video2lin.Quality  = 70;
open(Video1); open(Video2); open(Video1lin); open(Video2lin);

logscale=[1e0 1e1 1e2 1e3 1e4 1e5 1e6 1e7 1e8];
logticks=cellstr(['1e0'; '1e1'; '1e2'; '1e3'; '1e4'; '1e5'; '1e6'; '1e7'; '1e8']);
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

 divided = rdivide(D.R, Rmax);

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(divided, D.f_H1, 2, log10(D.T));
 set(gca,'YScale','log','XScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature (K)')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('HI Fraction');
 xlim([0 1]);
 ylim([1e-9, 1]);
 hold all; drawnow;
 writeVideo(Video1, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(divided, D.f_H2, 2, log10(D.T));
 set(gca,'YScale','log','XScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature (K)')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('HII Fraction');
 xlim([0 1]);
 ylim([1e-9, 1]);
 hold all; drawnow;
 writeVideo(Video2, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(divided, D.f_H1, 2, log10(D.T));
 set(gca,'YScale','log','XScale','linear');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature (K)')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('HI Fraction');
 xlim([0 1]);
 ylim([1e-9, 1]);
 hold all; drawnow;
 writeVideo(Video1lin, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(divided, D.f_H2, 2, log10(D.T));
 set(gca,'YScale','log','XScale','linear');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature (K)')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('R/L');
 ylabel('HII Fraction');
 xlim([0 1]);
 ylim([1e-9, 1]);
 hold all; drawnow;
 writeVideo(Video2lin, getframe(gcf,rect));

 close all;
 clear D;
end

% Close the videos
close(Video1); close(Video2); close(Video1lin); close(Video2lin);