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

 % P = S * (rho^gamma)
 P_adiabatic = times( D.Entropy, power(D.D, 5/3) );
 P_ideal     = times( plus(D.n_H, D.n_He), D.T ) * (1.38e-23);

 fig = figure;
 rect = get(fig,'Position'); 
 rect(1:2) = [0 0];
 fig = scatter(P_ideal, P_adiabatic, 2, log10(D.f_H1)); 
 set(gca,'XScale','log', 'YScale','log');
 c = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 c.Label.String = 'HII Fraction';
 colormap(jet(1024));
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 title([sprintf('t=%07.3fMa; nSources=%d',TimeDump, NumSources)]);
 xlabel('Ideal Pressure (Pa) $$P=(n_H + n_{He})kT$$','Interpreter','latex');
 ylabel('Adiabatic Pressure (Pa) $$P = S \rho^{\gamma}$$','Interpreter','latex');
 xlim([1e-22 1e-8]);
 ylim([1e-22 1e-8]);
 hold all; drawnow;
 writeVideo(Video, getframe(gcf,rect));
end

% Swap videos
close(Video); 