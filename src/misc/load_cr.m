%% process CW vectors

% Input file
inputFilebase = '../data/customerr/custrev';
inputpos = [inputFilebase '.pos'];
inputneg = [inputFilebase '.neg'];
outputname = '../data/customerr/allSStrCR.mat';


%Create hash table for the word list
fid = fopen(inputpos, 'r');
linespos = textscan(fid, '%s', 'delimiter', '\n', 'bufsize', 100000);
fclose(fid);
linespos=linespos{1};


fid = fopen(inputneg, 'r');
linesneg = textscan(fid, '%s', 'delimiter', '\n', 'bufsize', 100000);
fclose(fid);
linesneg=linesneg{1};

allSStrCR = {};
for i = 1:length(linespos)
    if mod(i, 500) == 0; 
        fprintf('processing line %d of %d\n', i, length(lines));
    end
    
    line = regexp(strtrim(linespos{i}),' ','split');
    
    allSStrCR{end+1} = line;
    
end

for i = 1:length(linesneg)
    if mod(i, 500) == 0; 
        fprintf('processing line %d of %d\n', i, length(lines));
    end
    
    line = regexp(strtrim(linesneg{i}),' ','split');
    allSStrCR{end+1} = line;
end
labels = false(1,length(allSStrCR));
labels(1:length(linespos)) = true;
save(outputname, 'allSStrCR', 'labels');