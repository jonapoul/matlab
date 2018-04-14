more off
clf reset
clearvars -except ScriptIndex AllMatlabFiles

hdr.h100=1; SI='MKS'; Units

% Converts the string /foo/bar/Runs/whatever/010/ to the integer 10
Slashes = strfind(pwd, '/');
ParentDir = extractAfter( pwd, Slashes(length(Slashes)) );
Dot = strfind(ParentDir,'.');
if ~isempty(Dot)
 NumSources = str2double( extractBefore(ParentDir, Dot(1)) );
else
 NumSources = str2double( ParentDir );
end
fprintf('PWD = ''%s''\n', pwd);
AllTimeDumps = load('output_times.dat');

Stack = dbstack();
ScriptName = Stack(1).file;
Dot = strfind(ScriptName, '.');
ScriptName = extractBefore( ScriptName, Dot(1) );

coolingmatches = regexp(ParentDir, '(cooling)', 'match')';
noheliummatches = regexp(ParentDir, '(nohelium)', 'match')';
if ~isempty(noheliummatches) % nohelium run
    LFactor = 365.25 * 86400 * 1e6;
elseif isempty(coolingmatches) % old run
    LFactor = Mpc;
else % full L range run
    LFactor = 1;
end

t    = [];
Ltot = [];
LH1  = [];
LHe1 = [];
LHe2 = [];
LeH  = [];
LC   = [];

% Read the PNG files, add to video
for i = 2 : length(AllTimeDumps);
 TimeDump = AllTimeDumps(i);
 if (TimeDump == 0.0)
  Dir=dir('save/RTData_t=START');
 else
  Dir=dir(['save/RTData_t=',sprintf('%07.3f',TimeDump)]);
 end
 DataDump=['save/',Dir.name];
 if exist(DataDump, 'file') ~= 2 % if its not a regular file
  fprintf('TimeDump = %07.3f Ma doesn''t exist\n', TimeDump); 
  continue;
 end
 fprintf('%s %2d/%2d t=%07.3fMa\n', datestr(now,'HH:MM:SS'), i-1, AllTimeDumps(1), AllTimeDumps(i));
 D = readRTdata(DataDump);

 t    = [t    TimeDump];
 Ltot = [Ltot mean(D.L)];
 LH1  = [LH1  mean(D.L_H1)/mean(D.L)];
 LHe1 = [LHe1 mean(D.L_He1)/mean(D.L)];
 LHe2 = [LHe2 mean(D.L_He2)/mean(D.L)];
 LC   = [LC   mean(D.L_C)/mean(D.L)];
 LeH  = [LeH  mean(D.L_eH)/mean(D.L)];
end

% plot
t    = t';
Ltot = Ltot';
LH1  = LH1';
LHe1 = LHe1';
LHe2 = LHe2';
LC   = LC';
LeH  = LeH';

fig = figure;
fig.Color = 'w';
area(t, [LH1 LHe1 LHe2 LC LeH]);
set(gca,'XScale','log', 'YScale','log');
xlim([1e-3 500]);
ylim([0 1]);
title('Proportion of total cooling rate from each process');
xlabel('t (Ma)');
ylabel('Proportion');
legend('L_{H1}', 'L_{He1}', 'L_{He2}', 'L_{C}', 'L_{eH}', 'Location','northwest');
eval(['print -dpng plots/',ScriptName,'_stacked_logY.png']);

fig = figure;
fig.Color = 'w';
area(t, [LH1 LHe1 LHe2 LC LeH]);
set(gca,'XScale','log');
xlim([1e-3 500]);
ylim([0 1]);
title('Proportion of total cooling rate from each process');
xlabel('t (Ma)');
ylabel('Proportion');
legend('L_{H1}', 'L_{He1}', 'L_{He2}', 'L_{C}', 'L_{eH}', 'Location','northwest');
eval(['print -dpng plots/',ScriptName,'_stacked_linY.png']);

fig = figure;
fig.Color = 'w';
loglog(t, Ltot*LFactor, '-', 'LineWidth', 2);
set(gca,'XScale','log');
xlim([1e-3 500]);
% ylim([0 1]);
title('Mean total cooling rate over time');
xlabel('t (Ma)');
ylabel('L_{tot} (J m^{-3} s^{-1})');
eval(['print -dpng plots/',ScriptName,'_total.png']);

fig = figure;
fig.Color = 'w';
loglog(t, times(LH1,Ltot)*LFactor,  '-', 'LineWidth', 2);
hold on;
loglog(t, times(LHe1,Ltot)*LFactor, '-', 'LineWidth', 2);
loglog(t, times(LHe2,Ltot)*LFactor, '-', 'LineWidth', 2);
loglog(t, times(LeH,Ltot)*LFactor,  '-', 'LineWidth', 2);
loglog(t, times(LC,Ltot)*LFactor,   '-', 'LineWidth', 2);
loglog(t, Ltot*LFactor,         '-', 'LineWidth', 2);
set(gca,'XScale','log','YScale','log');
xlim([1e-3 500]);
ylim([1e-16 1e-3]);
title('Mean cooling rates over time');
xlabel('t (Ma)');
ylabel('Species cooling rate (J m^{-3} s^{-1})');
legend('L_{H1}', 'L_{He1}', 'L_{He2}', 'L_{eH}', 'L_{C}', 'L_{total}', 'Location','southeast');
eval(['print -dpng plots/',ScriptName,'.png']);
