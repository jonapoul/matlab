close all;

% [ha, pos] = tight_subplot(6,1,0,[.1 .01],[.01 .01]);
% for ii = 1:6; 
%     axes(ha(ii)); 
%     plot(randn(10,ii)); 
% end 
% set(ha(1:5),'XTickLabel','');
% set(ha,'YTickLabel','')
% return

Myr     = 86400 * 365.25 * 1e6;
dir     = 'cosmo_timesteps';
runs    = {'001','002','005','010','020','050'};
orange  = [255/255 165/255 0/255];
blue    = [100/255 100/255 255/255];
yellow  = [230/255 230/255 0/255];
colours = {'r', orange, yellow, 'g', 'c', blue};

fig = figure;
[handle, pos] = tight_subplot(length(runs), 1, 0, [.1 .05], [.1 .05]);

hold on;
for i = 1 : length(runs);
    file = fileread(sprintf('%s/%s.log', dir, runs{i}));
    
    t_pattern  = '(?<=\s{5}t = )(\d\.\d{3}e\+\d{2})';
    t_str = regexp(file, t_pattern, 'match')';
    t = str2double(t_str) ./ Myr;

    dt_pattern = '(?<=\s{4}dt = )(\d\.\d{3}e\+\d{2})';
    dt_str = regexp(file, dt_pattern, 'match')';
    dt = str2double(dt_str) ./ Myr;
    
    axes(handle(i));
    p(i) = plot(t, dt);
    p(i).LineWidth = 1.5;
    p(i).Color = colours{i};
    handle(i) = gca;
    handle(i).FontSize = 10;
    handle(i).XScale = 'log';
    handle(i).YScale = 'log';
    %handle(i).YTick = ;
    
    xlim([1e-3 5e2]);
    ylim([2e-6 3e0]);
    legend_label = sprintf('%d Sources', str2double(runs{i}));
    text(1e-3,1e-2,'','FontWeight','bold')
end
set(handle(1:end-1),'XTickLabel','');
set(handle(1:end-1),'YTick',[1e-4 1e-2 1e0]);
handle(end).XLabel.String = 'Simulation time (Myr)';