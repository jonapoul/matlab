more off
clf reset

hdr.h100=1; SI='MKS'; Units

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
 [DG,hdr]=readgadget('../../../ICs/Cosmological/Data_019');
else 
 [DG,hdr]=readgadget('../../../ICs/Test2/gadget_glass_L13.2_N128_001');
end

% Isolate Gas
gas = 1 : hdr.npart(1);
DG.r=DG.r(:,gas);

% Normalize all lengths by BoxSize
DG.r   = DG.r/hdr.BoxSize;
DG.h   = DG.h/hdr.BoxSize/2; % extra factor of 1/2 because Gadget's kernel is compact over h, not 2h.
Res    = 256;
Slice  = 128;
Limits = [0 1 0 1 0 1];
N      = h_proj_3d(DG.r, ones(1,length(DG.h)), DG.h, Res, Limits);

mkdir('plots');
mkdir('plots/map');
mkdir('plots/map/fH');
mkdir('plots/map/fH/log10');
mkdir('plots/map/fH/linear');

if exist('./save', 'dir') ~= 7 % if we're not in the right place
 fprintf('./save/ directory doesn''t exist, exiting...\n'); 
 return;
end

PrintPNG = 1;
PrintEPS = 0;

for i = 2 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if TimeDump == 0.0
  Dir=dir('save/RTData_t=START');
 else
  Dir=dir(['save/RTData_t=',sprintf('%07.3f',TimeDump)]);
 end
 DataDump=['save/',Dir.name];
 if exist(DataDump, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 
 % Load RT data dump
 fprintf('%s %2d/%2d t=%07.3fMa\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), AllTimeDumps(i));
 D = readRTdata(DataDump);
 
 % Project the ionisation fractions
 F_H1 = h_proj_3d(DG.r, D.f_H1, DG.h, Res, Limits);
 F_H2 = h_proj_3d(DG.r, D.f_H2, DG.h, Res, Limits);
 F_H1 = F_H1./N;
 F_H2 = F_H2./N;
 X    = [0 hdr.BoxSize];
 Y    = X;
 logscale = [1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1e+0];
 logticks = cellstr(['1e-8'; '1e-7'; '1e-6'; '1e-5'; '1e-4'; '1e-3'; '1e-2'; '1e-1'; '1e+0']);

 % log10 H1
 imagesc(X, Y, log10(F_H1(1:end, 1:end, Slice)) );
 H1bar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 colormap(flipud(jet(1024)));    
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 axis equal
 title(sprintf('HI Fraction; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 timeStr=strrep(sprintf('%07.3f',TimeDump),'.','_'); % '123.456' -> '123_456'
 if (PrintEPS == 1)
  EPSFileName=['plots/map/fH/log10/xH1_t=',timeStr,'.eps'];
  eval(['print -depsc ',EPSFileName]);
 end
 if (PrintPNG == 1)
  PNGFileName=['plots/map/fH/log10/xH1_t=',timeStr,'.png'];
  eval(['print -dpng ',PNGFileName]);
 end
 
 % log10 H2
 imagesc(X, Y, log10(F_H2(1:end, 1:end, Slice)) );
 H2bar=colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 colormap(flipud(jet(1024)));    
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 axis equal
 title(sprintf('HII Fraction; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 timeStr=strrep(sprintf('%07.3f',TimeDump),'.','_'); % '123.456' -> '123_456'
 if (PrintEPS == 1)
  EPSFileName=['plots/map/fH/log10/xH2_t=',timeStr,'.eps'];
  eval(['print -depsc ',EPSFileName]);
 end
 if (PrintPNG == 1)
  PNGFileName=['plots/map/fH/log10/xH2_t=',timeStr,'.png'];
  eval(['print -dpng ',PNGFileName]);
 end

 % linear H2
 imagesc(X, Y, F_H2(1:end, 1:end, Slice));
 H2bar=colorbar;
 colormap(flipud(jet(1024)))
 caxis([0 1])
 axis equal
 title(sprintf('HII Fraction; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 timeStr=strrep(sprintf('%07.3f',TimeDump),'.','_'); % '123.456' -> '123_456'
 if (PrintEPS == 1)
  EPSFileName=['plots/map/fH/linear/xH2_t=',timeStr,'.eps'];
  eval(['print -depsc ',EPSFileName]);
 end
 if (PrintPNG == 1)
  PNGFileName=['plots/map/fH/linear/xH2_t=',timeStr,'.png'];
  eval(['print -dpng ',PNGFileName]);
 end

 % linear H1
 imagesc(X, Y, F_H1(1:end, 1:end, Slice));
 H1bar=colorbar;
 colormap(flipud(jet(1024)))
 caxis([0 1])
 axis equal
 title(sprintf('HI Fraction; t=%07.3fMa; nSources=%d; z=%d',TimeDump, NumSources, Slice));
 timeStr=strrep(sprintf('%07.3f',TimeDump),'.','_'); % '123.456' -> '123_456'
 if (PrintEPS == 1)
  EPSFileName=['plots/map/fH/linear/xH1_t=',timeStr,'.eps'];
  eval(['print -depsc ',EPSFileName]);
 end
 if (PrintPNG == 1)
  PNGFileName=['plots/map/fH/linear/xH1_t=',timeStr,'.png'];
  eval(['print -dpng ',PNGFileName]);
 end
end

return

Specifiers = ['log10/xH1 '; 'log10/xH2 '; 'linear/xH1'; 'linear/xH2'];
Specifiers = cellstr(Specifiers);
% Initialise videos
Videos = VideoWriter.empty;
for i = 1 : length(Specifiers);
 VideoFilename = ['plots/map/fH/', char(Specifiers(i)) ,'.avi'];
 Videos(i) = VideoWriter(VideoFilename);
 Videos(i).FrameRate = 3;
 open(Videos(i));
end

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
 fprintf('%s %2d/%2d t=%07.3f Ma\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), TimeDump);
 
 for j = 1 : length(Specifiers);
  FilePath=['plots/map/fH/',char(Specifiers(j)),'_t=',strrep(sprintf('%07.3f',TimeDump),'.','_'),'.png'];
  if exist(FilePath, 'file') ~= 2 % if its not a regular file
   continue; % go to the next index
  end
  ImageFile = imread(FilePath);
  writeVideo(Videos(j), ImageFile);
 end
end
for i = 1 : length(Specifiers);
 close(Videos(i));
end

close all;
clear all;