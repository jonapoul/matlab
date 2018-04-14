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
VideoHe1 = VideoWriter(['plots/',ScriptName,'1.avi']);
VideoHe2 = VideoWriter(['plots/',ScriptName,'2.avi']);
VideoHe1.FrameRate = 3; VideoHe2.FrameRate = 3;
VideoHe1.Quality = 100; VideoHe2.Quality = 100;
open(VideoHe1); open(VideoHe2);

% logscale = [1e0 1e1 1e2 1e3 1e4 1e5 1e6 1e7 1e8];
% logticks = cellstr(['1e0'; '1e1'; '1e2'; '1e3'; '1e4'; '1e5'; '1e6'; '1e7'; '1e8']);
logscale = [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1 1e2 1e3 1e4 1e5 1e6];
logticks = cellstr(['1e-8'; '1e-7'; '1e-6'; '1e-5'; '1e-4'; '1e-3'; '1e-2'; '1e-1'; '1e0 '; '1e1 '; '1e2 '; '1e3 '; '1e4 '; '1e5 '; '1e6 ';]);


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

 n_e = plus( times(D.n_H, D.f_H2), times(D.n_He, plus(D.f_He2, 2*D.f_He3)) );

 fig = scatter(D.column_H1, D.column_He1, 2, log10(n_e));
 set(gca,'XScale','log', 'YScale','log');
 c = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 c.Label.String = 'Electron Density (m^{}-3)';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d', TimeDump, NumSources)]);
 xlabel('H_1 Column Density (m^{-2})');
 ylabel('He_1 Column Density (m^{-2})');
 xlim([1e16 1e26]);
 ylim([1e11 1e25]);
 hold all; drawnow;
 writeVideo(VideoHe1, getframe(gcf,rect));

 fig = scatter(D.column_H1, D.column_He2, 2, log10(n_e));
 set(gca,'XScale','log', 'YScale','log');
 c = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 c.Label.String = 'Electron Density (m^{}-3)';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d', TimeDump, NumSources)]);
 xlabel('H_1 Column Density (m^{-2})');
 ylabel('He_2 Column Density (m^{-2})');
 xlim([1e16 1e26]);
 ylim([1e11 1e25]);
 hold all; drawnow;
 writeVideo(VideoHe2, getframe(gcf,rect));
end

% Close the videos
close(VideoHe1); close(VideoHe2);
