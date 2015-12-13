outputname = '../data/mrl/allSStrmrltok3.mat';

if ~exist(outputname, 'file')
allSStrmrl = {};
path = '../data/mrl/train/pos/*.tod3';
names = dir(path);
for i = 1:length(names)
    if isempty(strfind(names(i).name, '.tod3'))
        continue;
    end
    fid = fopen(['../data/mrl/train/pos/' names(i).name], 'r');
    content = textscan(fid, '%s',  'bufsize', 100000);
    fclose(fid);

    allSStrmrl{end+1} =  content{1};
end


path = '../data/mrl/train/neg/*.tod3';
names = dir(path);
for i = 1:length(names)
    if isempty(strfind(names(i).name, '.tod3'))
        continue;
    end
    fid = fopen(['../data/mrl/train/neg/' names(i).name], 'r');
    content = textscan(fid, '%s', 'bufsize', 100000);
    fclose(fid);

    allSStrmrl{end+1} =  content{1};
end

path = '../data/mrl/test/pos/*.txt';
names = dir(path);
for i = 1:length(names)
    fid = fopen(['../data/mrl/test/pos/' names(i).name], 'r');
    content = textscan(fid, '%s', 'bufsize', 100000);
    fclose(fid);

    allSStrmrl{end+1} =  content{1};
end

path = '../data/mrl/test/neg/*.txt';
names = dir(path);
for i = 1:length(names)
    fid = fopen(['../data/mrl/test/neg/' names(i).name], 'r');
    content = textscan(fid, '%s', 'bufsize', 100000);
    fclose(fid);

    allSStrmrl{end+1} =  content{1};
end


labels = false(1,length(allSStrmrl));
labels(1:12500) = true;
labels(25001:37500) = true;
save(outputname, 'allSStrmrl', 'labels');

else
    load(outputname);
end

%%
allSStr = allSStrmrl;
N = length(allSStr);
themap = containers.Map;
collection = [];
count = 1;
allSNumBi = {};
wordsbi = {};
for i = 1:N
    if mod(i,200) == 0
        fprintf('N %d %d\n', i, count);
    end
    allSNumBi{i} = [];
    for j = 1:length(allSStr{i})
        
        str = lower(allSStr{i}{j});
        collection = [collection str(~ismember(str,['a':'z' '-' '']))];
        currentword = str;
        
        try themap(currentword);
        catch
            themap(currentword) = count;
            wordsbi{count} = currentword;
            count = count + 1;
        end
        allSNumBi{i} = [allSNumBi{i} themap(currentword)];
    end
end

save('collection.mat', 'collection');

save('../data/mrl/unigram_mrl2tok3.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels', 'themap');


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
%         cbigram(~ismember(cbigram,['a':'z' '-' ''])) = '';
        
        try themap(cbigram);
        catch
            themap(cbigram) = count;
            wordsbi{count} = cbigram;
            count = count + 1;
        end
        
        allSNumBi{i} = [allSNumBi{i} themap(cbigram)];
    end
    
end


save('../data/mrl/bigram_mrl_bitok3.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels', 'themap');
