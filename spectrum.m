clear all;
close all;

h = 6.626e-34;
c = 3e8;
k = 1.38e-23;

T = 1e5;
lambda = 0 : 1e-10 : 2e-7;
B = (2*h*c*c)./((lambda.^5).*(exp((h.*c)./(k.*T.*lambda))-1));

plot(lambda, B, 'LineWidth', 3);
hold on;
[maxval,maxidx] = max(B);
lambda_ion = (h*c)/(13.6*1.6e-19);
idx = lambda > lambda_ion;
area(lambda(idx), B(idx));

p1 = [lambda_ion 0];
p2 = [lambda_ion maxval];

a = arrow(p1, p2,'Width',2,'Color','r');

%line = plot([lambda_ion lambda_ion],[0 maxval*1.2],'LineWidth', 3,'color','r');
ylim([0 maxval*1.2]);
xlim([lambda(1) lambda(end)]);
xlabel('Wavelength (m)');
ylabel('Spectral Radiance (J s^{-1} m^{-2} sr^{-1} Hz^{-1})');