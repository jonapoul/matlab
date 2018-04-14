close all
%filename = 'eric.t2.161018.txt';
filename = 'eric.t1.161014.txt';
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

hold on;
plot(t, dt, 'LineWidth',1, 'Color','r');

%filename = 'me.t2.180329.txt';
filename = 'me.t1.180330.txt';
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
plot(t, dt, 'LineWidth',1, 'Color','b');
hold off;

xlim([min(t) max(t)]);
ylim([1e-5 2e1]);
ylabel('Timestep (Myr)');
xlabel('Simulation time (Myr)');
ax = gca;
set(ax, 'FontSize', 14);
set(ax, 'FontWeight', 'bold');
ax.XScale = 'log';
ax.YScale = 'log';
legend('Before', 'After', 'location','northwest');
grid on

fig = gcf;
fig.Color = 'w';
% fig.PaperPosition(3) = 200;
% fig.PaperPosition(4) = 200;