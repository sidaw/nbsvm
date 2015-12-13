%% process CW vectors

% Input file
outputname = '../data/rt2k/allSStrRT2k.mat';

if ~exist(outputname, 'file')
allSStrRT2k = {};
path = '../data/rt2k/txt_sentoken/pos/*.txt';
names = dir(path);
for i = 1:length(names)
    fid = fopen(['../data/rt2k/txt_sentoken/pos/' names(i).name], 'r');
    content = textscan(fid, '%s', 'delimiter', ' ', 'bufsize', 100000);
    fclose(fid);

    allSStrRT2k{end+1} =  content{1};
end


path = '../data/rt2k/txt_sentoken/neg/*.txt';
names = dir(path);
for i = 1:length(names)
    fid = fopen(['../data/rt2k/txt_sentoken/neg/' names(i).name], 'r');
    content = textscan(fid, '%s', 'delimiter', ' ', 'bufsize', 100000);
    fclose(fid);

    allSStrRT2k{end+1} =  content{1};
end


labels = false(1,length(allSStrRT2k));
labels(1:1000) = true;
save(outputname, 'allSStrRT2k', 'labels');

else
    load(outputname);
end

%% 
allSStr = allSStrRT2k;
N = length(allSStr);
themap = containers.Map;

count = 1;
allSNumBi = {};
wordsbi = {};
for i = 1:N
    if mod(i,200) == 0
        fprintf('N %d %d\n', i, count);
    end
    allSNumBi{i} = [];
    for j = 1:length(allSStr{i})
        
        currentword = lower(allSStr{i}{j});
        try themap(currentword);
        catch
            themap(currentword) = count;
            wordsbi{count} = currentword;
            count = count + 1;
        end
        allSNumBi{i} = [allSNumBi{i} themap(currentword)];
    end
end

for i = 1:N
    if mod(i,1000) == 0
        fprintf('N %d %d\n', i, count);
    end
    for j = 0:length(allSStr{i})
        if j == 0
            cbigram = strcat('*start*', '-', allSStr{i}{j+1});
        elseif j==length(allSStr{i})
            cbigram = strcat(allSStr{i}{j}, '-', '*end*');
        else
            cbigram = strcat(allSStr{i}{j} ,'-', allSStr{i}{j+1});
        end
        cbigram = lower(cbigram);
        try themap(cbigram);
        catch
            themap(cbigram) = count;
            wordsbi{count} = cbigram;
            count = count + 1;
        end
        
        allSNumBi{i} = [allSNumBi{i} themap(cbigram)];
    end
    
end

save('../data/rt2k/rt2kbi.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels');
