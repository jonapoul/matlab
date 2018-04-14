runs = {'001','002','005','010','020','050'};
parent = '/home/jonapoul/mphys/Runs/Cosmological';

for iRun = 1 : length(runs);
    directory = sprintf('%s/%s.sm30.kenneth',parent,runs{iRun});
    eval(sprintf('cd %s',directory));
    eval('histograms');
    %eval('MapFH');
    %eval('MapJeans');
    %eval(sprintf('copyfile plots/hist_t_vs_FH2_lo.png ../FH2_lo_%s.png',runs{iRun}));
    %eval(sprintf('copyfile plots/hist_t_vs_FH2_hi.png ../FH2_hi_%s.png',runs{iRun}));
    %eval(sprintf('copyfile plots/hist_t_vs_FH2.png ../FH2_%s.png',runs{iRun}));
    eval(sprintf('copyfile plots/hist_t_vs_T.png ../T_%s.png',runs{iRun}));
    %eval(sprintf('copyfile plots/hist_t_vs_MJ.png ../MJ_%s.png',runs{iRun}));
    %eval(sprintf('copyfile plots/hist_t_vs_L.png ../L_%s.png',runs{iRun}));
end

eval(sprintf('cd %s',parent));
