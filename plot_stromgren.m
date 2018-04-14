T = 1e4;
alpha = (2.065e-17 / sqrt(T)) *(5.62  - log(T)/2 + (8.68e-3) * T^(1/3) + 2.01e-5 * T^(0.8) );
A = -2;
n = 10^3;
N = 5e48;
P = (alpha * n)/3;
Q = N/(4 * pi * n);
ratio = Q/P;

kpc = 3.08567758e19;
Myr = 3600 * 24 * 365.25 * 1e6;

t = 0 : 0.5 : 600;
R3 = ratio - ratio .* exp( (-P*(1-A)) .* t .* Myr);
R = R3 .^ (1/3);
R = R ./ kpc;
Rs = (Q/P)^(1/3) / kpc;
hold on;
plot(t, R, 'LineWidth', 2);
plot([min(t) max(t)], [Rs Rs], 'LineWidth', 2);
xlabel('$t$ (Myr)', 'interpreter', 'latex');
ylabel('$R(t)$ (kpc)', 'interpreter', 'latex');
legend('Ionisation front', 'Stromgren radius','location','southeast');
fig = gcf;
fig.Color = 'w';
ax = gca;
ax.FontSize = 14;
grid on;
