more off

hdr.h100 = 1; SI = 'MKS'; Units

% Converts the string /foo/bar/Runs/whatever/010/ to the integer 10
parts = strsplit(pwd, '/');
ParentDir = parts{end};
if strcmpi(parts{end-1}, 'Cosmological');
 Dot = strfind(ParentDir,'.');
 if ~isempty(Dot)
  NumSources = str2double( extractBefore(ParentDir, Dot(1)) );
 else
  NumSources = str2double( ParentDir );
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
gas = 1 : hdr.npart(1);
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

logscale = 36 : 1 : 45;
logticks = sprintfc('1e%+d', logscale)';
logscale = 10.^logscale;

mkdir('plots');
mkdir('plots/map');
mkdir('plots/map/MJ');

for i = 2 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if (TimeDump == 0.0)
  Dir = dir('save/RTData_t=START');
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
 timeStr = strrep(sprintf('%07.3f',TimeDump),'.','_'); % '123.456' -> '123_456'
 
 A    = 5.1409e-19;
 ne_array = plus(times(D.f_H2,D.n_H),times(plus(D.f_He2,2*D.f_He3),D.n_He));
 n    = D.n_H + D.n_He + ne_array;
 M_H  = 1.6726219e-27 .* D.n_H;
 M_He = 6.6464764e-27 .* D.n_He;
 M_e  = 9.10938356e-31 .* ne_array;
 mbar = (M_H + M_He + M_e) ./ n;
 MJ_t = A.*(n .^ -0.5).*(D.T .^ 1.5).*(mbar .^ -2);
 
 MJ = h_proj_3d(DG.r, MJ_t, DG.h, Res, Limits);
 MJ = MJ ./ N;
 
 % Plot and save
 imagesc(X, Y, log10(MJ(1:end, 1:end, Slice)) );
 c = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 c.Label.String = 'M_J (kg)';
 colormap(flipud(colourmap(1024)));    
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 axis equal
 title(sprintf('Jeans Mass; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 eval(['print -dpng plots/map/MJ/t=',timeStr,'.png']);
end

% Initialise videos
Video = VideoWriter('plots/map/MJ/MJ.avi');
Video.FrameRate = 3;
Video.Quality = 100;
open(Video);

% Read the PNG files, add to video
for i = 2 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if (TimeDump == 0.0)
  Dir=dir('save/RTData_t=START');
 else
  Dir=dir(['save/RTData_t=',sprintf('%07.3f',TimeDump)]);
 end
 DataDump=['save/',Dir.name];
 if exist(DataDump, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 fprintf('%s %2d/%2d t=%07.3f Ma\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), TimeDump);

 FilePath = ['plots/map/MJ/t=',strrep(sprintf('%07.3f',TimeDump),'.','_'),'.png'];
 if exist(FilePath, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 ImageFile = imread(FilePath);
 writeVideo(Video, ImageFile);
end
close(Video);

close all;