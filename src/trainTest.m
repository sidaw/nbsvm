% if ~exist('allSNumBi', 'var') || length(allSNumBi) ~= 10662
%     warn('data should be provided already')
%     load('../data/rt10662/cv_obj');
%     load('../data/rt10662/bigram_largevocabrt.mat');
% end
params.dictsize = length(wordsbi);
params.numcases = length(labels);

fprintf('Train Test using dataset l=%d, dictSize=%d, CVNUM=%d\n', ...
    length(allSNumBi), length(wordsbi), params.CVNUM)

% initial = 1.1;
randn('state', 0);
rand('state', 0);

allcounts = [];
allfps = []; allfns = [];

assert(0==sum(train_ind == test_ind))

model = trainfuncp(allSNumBi(train_ind), labels(train_ind), params);
%     
[acc pred softpred] = testfuncp(model, ...
    allSNumBi(test_ind), labels(test_ind), params);
%     naiveBayesSVM;
%     acc = rate;
nblbltst = labels(test_ind);
fp = sum(nblbltst == 0 & pred == 1);
fn = sum(nblbltst == 1 & pred == 0);
allfps = [allfps fp];
allfns = [allfns fn];

allcounts = acc;
acc
