%% process CW vectors

% Input file
inputFilebase = '../data/rt10662/rt-polarity';
inputpos = [inputFilebase '.pos'];
inputneg = [inputFilebase '.neg'];
outputname = '../data/rt10662/allSStrRT.mat';


%Create hash table for the word list
fid = fopen(inputpos, 'r');
linespos = textscan(fid, '%s', 'delimiter', '\n', 'bufsize', 100000);
fclose(fid);
linespos=linespos{1};


fid = fopen(inputneg, 'r');
linesneg = textscan(fid, '%s', 'delimiter', '\n', 'bufsize', 100000);
fclose(fid);
linesneg=linesneg{1};

allSStrRT = {};
for i = 1:length(linespos)
    if mod(i, 10000) == 0; 
        fprintf('processing line %d of %d\n', i, length(lines));
    end
    
    line = regexp(strtrim(linespos{i}),' ','split');
    
    allSStrRT{end+1} = line;
    
end

for i = 1:length(linesneg)
    if mod(i, 10000) == 0; 
        fprintf('processing line %d of %d\n', i, length(lines));
    end
    
    line = regexp(strtrim(linesneg{i}),' ','split');
    allSStrRT{end+1} = line;
end
labels = false(1,length(allSStrRT));
labels(1:5331) = true;
save(outputname, 'allSStrRT', 'labels');