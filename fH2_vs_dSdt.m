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
Video = VideoWriter(['plots/',ScriptName,'.avi']);
Video.FrameRate = 3;
Video.Quality = 100;
open(Video);

logscale=[-1 1];
logticks=cellstr(['Negative'; 'Positive']);

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

 dSdt = times((2/3)*power(D.D,-5/3), D.G-D.L*Mpc);
 Mag = abs(dSdt);
 Sign = rdivide(dSdt, Mag);

 fig = scatter(D.f_H2, Mag, 2, Sign);
 set(gca,'XScale','log','YScale','log');
 colourbar=colorbar('YTick',logscale,'YTickLabel',logticks);
 set(get(colourbar,'Title'),'String','Direction');
 colormap(jet(1024));
 caxis( [-1 1] );

 title([sprintf('t=%07.3fMa, nSources=%d', TimeDump, NumSources)]);
 xlabel('Hydrogen Ionisation Fraction');
 ylabel('Entropy Rate (Magnitude) (J K^{-1} s^{-1})');
 xlim([1e-8 1e0]);
 ylim([1e24 1e38]);

 hold all; drawnow;
 writeVideo(Video, getframe(gcf,rect));
end

% Close the videos
close(Video);