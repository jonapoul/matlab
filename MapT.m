more off
clear
clf reset

hdr.h100 = 1; SI = 'MKS'; Units

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

if strcmpi(parts{end-1}, 'Cosmological');
 [DG,hdr] = readgadget('../../../ICs/Cosmological/Data_019');
else 
 [DG,hdr] = readgadget('../../../ICs/Test2/gadget_glass_L13.2_N128_001');
end

% Isolate Gas
gas = [1:hdr.npart(1)];
DG.r = DG.r(:,gas);

% Normalize all lengths by BoxSize
DG.r     = DG.r/hdr.BoxSize;
DG.h     = DG.h/hdr.BoxSize/2; % extra factor of 1/2 because Gadget's kernel is compact over h, not 2h.
Res      = 256;
Slice    = 128;
Limits   = [0 1 0 1 0 1];
N        = h_proj_3d(DG.r, ones(1,length(DG.h)), DG.h, Res, Limits);
X        = [0 hdr.BoxSize];
Y        = X;
PrintPNG = 1;
PrintEPS = 0;
logscale = [1e0 1e1 1e2 1e3 1e4 1e5];
logticks = cellstr(['1e+0'; '1e+1'; '1e+2'; '1e+3'; '1e+4'; '1e+5']);

mkdir('plots');
mkdir('plots/map');
mkdir('plots/map/T');
mkdir('plots/map/T/log10');
mkdir('plots/map/T/linear');

for i = 2 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if (TimeDump == 0.0)
  Dir = dir(['save/RTData_t=START']);
 else
  Dir = dir(['save/RTData_t=',sprintf('%07.3f',TimeDump)]);
 end
 DataDump = ['save/',Dir.name];
 if exist(DataDump, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 
 % Load RT data dump
 fprintf('%s %2d/%2d t=%07.3fMa\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), AllTimeDumps(i));
 D = readRTdata(DataDump);
 
 % Project the ionisation fractions
 T = h_proj_3d(DG.r, D.T, DG.h, Res, Limits);
 T = T./N;
 timeStr = strrep(sprintf('%07.3f',TimeDump),'.','_'); % '123.456' -> '123_456'

 % Plot and save
 imagesc(X, Y, log10(T(1:end, 1:end, Slice)) );
 c = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 c.Label.String = 'Temperature (K)';
 colormap(flipud(colourmap(1024)));    
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 axis equal
 title(sprintf('Temperature; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 eval(['print -dpng plots/map/T/log10/T_t=',timeStr,'.png']);

 imagesc(X, Y, T(1:end, 1:end, Slice));
 c = colorbar;
 c.Label.String = 'Temperature (K)';
 colormap(flipud(colourmap(1024)))
 caxis([0 1e5])
 axis equal
 fig = gcf;
 fig.Color = 'w';
 title(sprintf('Temperature; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 eval(['print -dpng plots/map/T/linear/T_t=',timeStr,'.png']);
end

VideoLog = VideoWriter(['plots/map/T/log10/T_log.avi']);
VideoLin = VideoWriter(['plots/map/T/linear/T_lin.avi']);
VideoLog.FrameRate = 3; VideoLin.FrameRate = 3;
VideoLog.Quality = 100; VideoLin.Quality = 100;
open(VideoLog); open(VideoLin);

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
  continue; % go to the next index
 end
 FilePath = ['plots/map/T/log10/T_t=',strrep(sprintf('%07.3f',TimeDump),'.','_'),'.png'];
 if exist(FilePath, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 fprintf('%s %2d/%2d t=%07.3f Ma\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), TimeDump);
 ImageFile = imread(FilePath);
 writeVideo(VideoLog, ImageFile);
 FilePath = ['plots/map/T/linear/T_t=',strrep(sprintf('%07.3f',TimeDump),'.','_'),'.png'];
 if exist(FilePath, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 ImageFile = imread(FilePath);
 writeVideo(VideoLin, ImageFile);
end
close(VideoLog); close(VideoLin);

close all;
clear all;