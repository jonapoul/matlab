close all;

filename = 'Log';
if exist(filename, 'file') ~= 2
    fprintf('File doesn''t exist\n');
    return
end
Myr = 31556926 * 1e6;

t_pattern_new = '(?<=\s{5}t = )(\d\.\d{3}e\+\d{2})'; % new
t_pattern_old = '(?<=t=)(\d\.\d{5}e\+\d{2})'; % old
t_str_new = regexp(fileread(filename), t_pattern_new, 'match')';
t_str_old = regexp(fileread(filename), t_pattern_old, 'match')';
if (length(t_str_new) > length(t_str_old)) 
 t_str = t_str_new;
else 
 t_str = t_str_old;
end
t = str2double(t_str) ./ Myr;

dt_pattern_new = '(?<=\s{4}dt = )(\d\.\d{3}e\+\d{2})'; % new
dt_pattern_old = '(?<=dt_RT=)(\d\.\d{3}e\+\d{2})'; % old
dt_str_new = regexp(fileread(filename), dt_pattern_new, 'match')';
dt_str_old = regexp(fileread(filename), dt_pattern_old, 'match')';
if (length(dt_str_new) > length(dt_str_old)) 
 dt_str = dt_str_new;
else 
 dt_str = dt_str_old;
end
dt = str2double(dt_str) ./ Myr;

loglog(t, dt, 'LineWidth',1, 'Color','c');
xlim([min(t) max(t)]);
% ylim([1e-4 1e0]);
xlabel('Time (Myr)')
ylabel({'Timestep'; '(Myr)'});

grey = [47/255 56/255 72/255];
ax = gca;
set(ax, 'Color', grey);
set(ax, 'XColor', 'w');
set(ax, 'YColor', 'w');
set(ax, 'FontSize', 14);
set(ax, 'FontWeight', 'bold');
label = get(ax, 'YLabel');
set(label, 'Rotation', 0);
fig = gcf;
set(fig, 'Color', grey);
set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperPosition', [0 0 10 6]);

% t = title('Timestep Oscillation in Test 2');
% t.Color = 'w';
% t.FontSize = 20;

set(fig, 'InvertHardcopy', 'off');
print -dpng testT1.png
