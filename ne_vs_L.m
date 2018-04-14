more off
clf reset
clearvars -except ScriptIndex AllMatlabFiles

hdr.h100=1; SI='MKS'; Units

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
VideoTotal = VideoWriter(['plots/',ScriptName,'_Total.avi']);
VideoEH    = VideoWriter(['plots/',ScriptName,'_eH.avi']);
VideoC     = VideoWriter(['plots/',ScriptName,'_C.avi']);
VideoH1    = VideoWriter(['plots/',ScriptName,'_H1.avi']);
VideoHe1   = VideoWriter(['plots/',ScriptName,'_He1.avi']);
VideoHe2   = VideoWriter(['plots/',ScriptName,'_He2.avi']);
VideoTotal.FrameRate = 3; VideoEH.FrameRate = 3; VideoC.FrameRate = 3; 
VideoH1.FrameRate = 3; VideoHe1.FrameRate = 3; VideoHe2.FrameRate = 3;
VideoTotal.Quality = 100; VideoEH.Quality = 100; VideoC.Quality = 100;
VideoH1.Quality = 100; VideoHe1.Quality = 100; VideoHe2.Quality = 100;
open(VideoTotal); open(VideoEH); open(VideoC); open(VideoH1); open(VideoHe1); open(VideoHe2);

logscale=[1e0 1e1 1e2 1e3 1e4 1e5 1e6 1e7 1e8];
logticks=cellstr(['1e0'; '1e1'; '1e2'; '1e3'; '1e4'; '1e5'; '1e6'; '1e7'; '1e8']);

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

 nH1  = times(D.n_H, D.f_H1);
 nH2  = times(D.n_H, D.f_H2);
 nHe1 = times(D.n_He, D.f_He1);
 nHe2 = times(D.n_He, D.f_He2);
 nHe3 = times(D.n_He, D.f_He3);
 ne = nH2 + nHe2 + times(2.0, nHe3);

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0];
 positive = find(D.L>0);
 if isempty(positive)
     continue;
 end
 fig = scatter(ne(positive), D.L(positive), 2, log10(D.T(positive)));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('Electron density (m^{-3})');
 ylabel('Total Cooling Rate (J m^{-3} s^{-1})');
 ylim([1e-23 1e0]);
 xlim([1e-8 1e6]);
 % annotation('textbox','String',sprintf('Fraction = %6.3f', length(D.L(D.L>0))/D.NumCells),'FitBoxToText','on');
 hold all; drawnow;
 writeVideo(VideoTotal, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(ne, D.L_eH, 2, log10(D.T));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('Electron density (m^{-3})');
 ylabel('Cooling via Collisional Excitation of HI (J m^{-3} s^{-1})');
 ylim([1e-23 1e0]);
 xlim([1e-8 1e6]);
 hold all; drawnow;
 writeVideo(VideoEH, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 positive = find(D.L_C>0);
 fig = scatter(ne(positive), D.L_C(positive), 2, log10(D.T(positive)));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('Electron density (m^{-3})');
 ylabel('Inverse Compton Cooling (J m^{-3} s^{-1})');
 ylim([1e-23 1e0]);
 xlim([1e-8 1e6]);
 hold all; drawnow;
 writeVideo(VideoC, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(ne, D.L_H1, 2, log10(D.T));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('Electron density (m^{-3})');
 ylabel('Cooling by Recombination of HII (J m^{-3} s^{-1})');
 ylim([1e-23 1e0]);
 xlim([1e-8 1e6]);
 hold all; drawnow;
 writeVideo(VideoH1, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(ne, D.L_He1, 2, log10(D.T));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('Electron density (m^{-3})');
 ylabel('Cooling by Recombination of HeII (J m^{-3} s^{-1})');
 ylim([1e-23 1e0]);
 xlim([1e-8 1e6]);
 hold all; drawnow;
 writeVideo(VideoHe1, getframe(gcf,rect));

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0]; 
 fig = scatter(ne, D.L_He2, 2, log10(D.T));
 set(gca,'XScale','log', 'YScale','log');
 colourbar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Temperature')
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa, nSources=%d',TimeDump, NumSources)]);
 xlabel('Electron density (m^{-3})');
 ylabel('Cooling by Recombination of HeIII (J m^{-3} s^{-1})');
 ylim([1e-23 1e0]);
 xlim([1e-8 1e6]);
 hold all; drawnow;
 writeVideo(VideoHe2, getframe(gcf,rect));
end

% Close the videos
close(VideoTotal);
close(VideoEH);
close(VideoC);
close(VideoH1);
close(VideoHe1);
close(VideoHe2);