more off
clear
clf reset

hdr.h100 = 1; SI = 'MKS'; Units
fprintf('PWD = ''%s''\n', pwd);

parts = strsplit(pwd, '/');
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
Limits   = [0 1 0 1 0 1];
N        = h_proj_3d(DG.r, ones(1,length(DG.h)), DG.h, Res, Limits);
X        = [0 hdr.BoxSize];
Y        = X;
PrintPNG = 1;
PrintEPS = 0;
logscale = [1e-27 1e-26 1e-25 1e-24 1e-23 1e-22];
logticks = cellstr(['1e-27'; '1e-26'; '1e-25'; '1e-24'; '1e-23'; '1e-22']);

mkdir('plots');
mkdir('plots/map');
mkdir('plots/map/rho');
D = readRTdata('save/RTData_t=000.001');

for z = 1 : Res;
 if mod(z, 4) ~= 0;
  continue;
 end
 % Load RT data dump
 fprintf('%s i=%d/%d z=%.1f kpc\n', datestr(now,'HH:MM:SS'), z, Res, z*hdr.BoxSize/Res);
 rho = h_proj_3d(DG.r, D.D, DG.h, Res, Limits);
 rho = rho./N;
 
 % Plot and save
 imagesc(X, Y, log10(rho(1:end, 1:end, z)) );
 c = colorbar('YTick',log10(logscale),'YTickLabel',logticks);
 c.Label.String = 'Density (kg m^{-3})';
 colormap(flipud(colourmap(1024)));    
 caxis( log10([logscale(1) logscale(length(logscale))]) );
 axis equal
 title(sprintf('Density Map; z=%d/%d = %.1f kpc', z, Res, z*hdr.BoxSize/Res));
 eval(['print -dpng plots/map/rho/z=',sprintf('%03d',z),'.png']);
end

% Initialise video
Video = VideoWriter(['plots/map/rho/rho.avi']);
Video.FrameRate = 3;
Video.Quality = 100;
open(Video);

% Read the PNG files, add to video
for z = 1 : Res;
 if mod(z, 4) ~= 0;
  continue;
 end
 FilePath = ['plots/map/rho/z=',sprintf('%03d',z),'.png'];
 if exist(FilePath, 'file') ~= 2 % if its not a regular file
  continue; % go to the next index
 end
 fprintf('%s z=%d/%d = %.1f kpc\n', datestr(now,'HH:MM:SS'), z, Res, z*hdr.BoxSize/Res);
 ImageFile = imread(FilePath);
 writeVideo(Video, ImageFile);
end
close(Video);

close all;
clear all;