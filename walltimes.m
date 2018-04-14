filename = 'eric.t1.161014.txt';
if exist(filename, 'file') ~= 2
    fprintf('File doesn''t exist\n');
    return
end
file = fileread(filename);

pattern_new = '(?<=Iteration walltime = )(\d{1,}.\d{1,})';
pattern_old = '(?<=Iteration walltime  = )(\d{1,}.\d{1,})';

matches_new = str2double(regexp(file, pattern_new, 'match')');
matches_old = str2double(regexp(file, pattern_old, 'match')');
if (length(matches_new) > length(matches_old)) 
 matches = matches_new;
else 
 matches = matches_old;
end

plot(matches)