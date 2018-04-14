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
Video1 = VideoWriter(['plots/',ScriptName,'_1.avi']);
Video2 = VideoWriter(['plots/',ScriptName,'_2.avi']);
Video1.FrameRate = 3; Video2.FrameRate = 3;
Video1.Quality = 100; Video2.Quality = 100;
open(Video1); open(Video2);

logscale=[1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e+0];
logticks=cellstr(['1e-8'; '1e-7'; '1e-6'; '1e-5'; '1e-4'; '1e-3'; '1e-2'; '1e-1'; '1e+0']);

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

 fig = scatter(times(D.n_H, D.f_H1), D.n_HI_Equilibrium, 2, log10(D.f_H1));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','HI Fraction');
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d', TimeDump, NumSources)]);
 xlabel('n_{HI} (m^{-3})');
 ylabel('n_{HI} Equilibrium value (m^{-3})');
 xlim([1e-7 1e6])
 ylim([1e-7 1e6])
 hold all; drawnow;
 writeVideo(Video1, getframe(gcf,rect));

 fig = scatter(times(D.n_H, D.f_H2), D.n_HII_Equilibrium, 2, log10(D.f_H2));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','HII Fraction');
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d', TimeDump, NumSources)]);
 xlabel('n_{HII} (m^{-3})');
 ylabel('n_{HII} Equilibrium value (m^{-3})');
 xlim([1e-7 1e6])
 ylim([1e-7 1e6])
 hold all; drawnow;
 writeVideo(Video2, getframe(gcf,rect));
end

% Close the videos
close(Video1); close(Video2);