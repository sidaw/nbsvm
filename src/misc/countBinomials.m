allSStr = allSStrRT;
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

for i = 1:N
    if mod(i,1000) == 0
        fprintf('N %d %d\n', i, count);
    end
    for j = 0:length(allSStr{i})-1
        if length(allSStr{i}) == 1
            break;
        end
        
        if j == 0
            cbigram = strcat('*start*', '--', allSStr{i}{j+2});
        elseif j==length(allSStr{i})-1
            cbigram = strcat(allSStr{i}{j}, '--', '*end*');
        else
            cbigram = strcat(allSStr{i}{j} ,'--', allSStr{i}{j+2});
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

% for i = 1:N
%     if mod(i,1000) == 0
%         fprintf('N %d %d\n', i, count);
%     end
%     padded = {'s1', 's2', allSStr{i}{1:end}, 'e1', 'e2'};
%     for j = 1:length(padded)-2
%         
%         cbigram = strcat(padded{j} ,'-', padded{j+1}, '-', padded{j+2});
%         
%         try themap(cbigram);
%         catch
%             themap(cbigram) = count;
%             wordsbi{count} = cbigram;
%             count = count + 1;
%         end
%         
%         allSNumBi{i} = [allSNumBi{i} themap(cbigram)];
%     end
%     
% end

% params.CVNUM
% load('../data/cv_obj');
% full_train_ind = cv_obj.training(params.CVNUM);
% full_train_nums = find(full_train_ind);
% test_ind = cv_obj.test(params.CVNUM);
% test_nums = find(test_ind);
% 
% train_ind = full_train_ind;
% cv_ind = test_ind;

% save('../data/customerr/unigram_cr.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels');

save('../data/rt10662/spacedbi_largevocabrt.mat', 'allSNumBi', 'wordsbi', 'allSStr', 'labels');


