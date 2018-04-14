close all

NumSources = 50;
data       = importdata('centres_sorted.dat');
[DG, hdr]  = readgadget('Data_019');

TotalSources = data(1);
data = data(2:end) * 10;
X = zeros(NumSources,1);
Y = zeros(NumSources,1);
Z = zeros(NumSources,1);
for i = 1 : NumSources;
    X(i) = data(3*i-2);
    Y(i) = data(3*i-1);
    Z(i) = data(3*i-0);
    %fprintf('%d & %.2f & %.2f & %.2f \\\\\n', i, X(i), Y(i), Z(i));
end

