%% process CW vectors

% Input file
inputFilebase = '../data/subj/subj';
inputpos = [inputFilebase '.subjective'];
inputneg = [inputFilebase '.objective'];
outputname = '../data/subj/allSStrSUB.mat';


%Create hash table for the word list
fid = fopen(inputpos, 'r');
linespos = textscan(fid, '%s', 'delimiter', '\n', 'bufsize', 100000);
fclose(fid);
linespos=linespos{1};


fid = fopen(inputneg, 'r');
linesneg = textscan(fid, '%s', 'delimiter', '\n', 'bufsize', 100000);
fclose(fid);
linesneg=linesneg{1};

allSStrSUB = {};
for i = 1:length(linespos)
    if mod(i, 1000) == 0; 
        fprintf('processing line %d of %d\n', i, length(lines));
    end
    
    line = regexp(strtrim(linespos{i}),' ','split');
    
    allSStrSUB{end+1} = line;
    
end

for i = 1:length(linesneg)
    if mod(i, 1000) == 0; 
        fprintf('processing line %d of %d\n', i, length(lines));
    end
    
    line = regexp(strtrim(linesneg{i}),' ','split');
    allSStrSUB{end+1} = line;
end

assert(length(allSStrSUB) == 10000);

labels = false(1,length(allSStrSUB));
labels(1:5000) = true;
save(outputname, 'allSStrSUB', 'labels');
