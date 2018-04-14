if 0;
    AllMatlabFiles = dir('~/mphys/Runs/Cosmological/scripts/*_*.m');
    % AllMatlabFiles = dir('~/mphys/Runs/Cosmological/scripts/t_*.m');

    mkdir('plots')

    % Change this if the script is killed midway through so you don't have to redo everything
    START_SCRIPT = 1;

    for ScriptIndex = START_SCRIPT : length(AllMatlabFiles)
    % Convert "myscript.m" to "myscript"
    Script = char(AllMatlabFiles(ScriptIndex).name);
    Dot = strfind(Script, '.');
    Script = extractBefore( Script, Dot(length(Dot)) );
    fprintf('\n\nRunning ''%s'' = %d/%d\n', Script, ScriptIndex, length(AllMatlabFiles));
    % Actually run the script
    eval(Script);
    close all;
    end

    clear all;
    close all;

    fprintf('Plotting Histograms...\n');
    eval('histograms');
end

fprintf('Plotting fH Maps...\n');
eval('MapFH');

fprintf('Plotting fHe Maps...\n');
eval('MapFHe');

fprintf('Plotting T Maps...\n');
eval('MapT');

fprintf('Plotting L Maps...\n');
eval('MapL');

fprintf('Plotting L_eH Maps...\n');
eval('MapL_eH');

fprintf('Plotting L_C Maps...\n');
eval('MapL_C');

fprintf('Plotting G Maps...\n');
eval('MapG');

fprintf('Plotting Rho Maps...\n');
eval('MapRho');

fprintf('Plotting MJ Maps...\n');
eval('MapJeans');

clear all;
close all;