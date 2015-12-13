allSStr = allSStrSUB;
N = length(allSStr);
themap = containers.Map;

count = 1;
allSNumBi = {};
wordsbi = {};
for i = 1:N
    if mod(i,1000) == 0
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

save('../data/subj/unigram_subj.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels', 'themap');

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


save('../data/subj/bigram_subj.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels', 'themap');


