params.dictsize = length(wordsbi);
params.numcases = length(labels);

cdataset = dataset;
c = 1;
if ~exist('pdataset', 'var') || ~strcmp(cdataset, pdataset)
    currentres = zeros(2,3); 
    pdataset = cdataset;
end

if ~isfield(params, 'doCV')
 params.doCV = 1;
end

trainfuncp = @(allSNumBi, labels, params) trainMNB(allSNumBi, labels, params);
testfuncp = @(model, allSNumBi, labels, params) testMNB(model, allSNumBi, labels, params);

if params.doCV
    CV;
else
    trainTest;
end

writeResults(allcounts, params, [dataset '-SVM-' gram]);
allresults([dataset, '-MNB-', gram]) = mean(allcounts);
% trainfuncp = @(allSNumBi, labels, params) trainBNB(allSNumBi, labels, params);
% testfuncp = @(model, allSNumBi, labels, params) testBNB(model, allSNumBi, labels, params);
% 
% if params.doCV
%     CV;
% else
%     trainTest;
% end
% 
% writeResults(allcounts, params, [dataset '-BNB-' gram]);
% allresults([dataset, '-BNB-', gram]) = mean(allcounts);
trainfuncp = @(allSNumBi, labels, params) trainbisvm(allSNumBi, labels, params);
testfuncp = @(model, allSNumBi, labels, params) testbisvm(model, allSNumBi, labels, params);

if params.doCV
    CV;
else
    trainTest;
end

writeResults(allcounts, params, [dataset '-SVM-' gram]);
allresults([dataset, '-SVM-', gram]) = mean(allcounts);


trainfuncp = @(allSNumBi, labels, params) trainMNBSVM(allSNumBi, labels, params);
testfuncp = @(model, allSNumBi, labels, params) testMNBSVM(model, allSNumBi, labels, params);
if params.doCV
    CV;
else
    trainTest;
end

writeResults(allcounts, params, [dataset '-NBSVM-' gram]);
allresults([dataset, '-NBSVM-', gram]) = mean(allcounts);
