close all;

load mri
imagesc(D(:,:,1,11))
colormap hot
colormapeditor

return

Myr = 86400 * 365.25 * 1e6;
kpc = 3.08567758e19;

alpha = 2.5475695e-19; % from printfing during test1
n = 1e3;
N = 5e48;
Rs = (3 * N) / (4 * pi * n * n * alpha);
Rs = (Rs^(1/3)) / kpc;

t = 0 : 0.5 : 600;
Rt = Rs .* ( 1 - exp(-alpha .* n .* t .* Myr) ).^(1/3);

hold on;
plot(t, Rt, 'LineWidth', 2);
plot([min(t) max(t)], [Rs Rs], 'LineWidth', 2, 'LineStyle', '--');
hold off;
ax = gca;
ax.FontSize = 18;
xlim([min(t) max(t)]);
ylim([0 Rs*1.2]);
xlabel('$t$ (Myr)', 'interpreter', 'latex');
ylabel('$R(t)$ (kpc)', 'interpreter', 'latex');
fig = gcf;
fig.Color = 'w';
grid on;
legend('R(t)', 'R_S', 'location', 'southeast');
title('');