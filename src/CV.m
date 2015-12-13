params.dictsize = length(wordsbi);
params.numcases = length(labels);

fprintf('CV using dataset l=%d, dictSize=%d, CVNUM=%d\n', ...
    length(allSNumBi), length(wordsbi), params.CVNUM)

% initial = 1.1;
randn('state', 0);
rand('state', 0);

allcounts = [];
allfps = []; allfns = [];
for i=[1:params.CVNUM]
    train_ind = cv_obj.training(i);
    test_ind = cv_obj.test(i);
    assert(0==sum(train_ind == test_ind))
    
    model = trainfuncp(allSNumBi(train_ind), labels(train_ind), params);
%     
    [acc pred softpred] = testfuncp(model, ...
        allSNumBi(test_ind), labels(test_ind), params);

    nblbltst = labels(test_ind);
    fp = sum(nblbltst == 0 & pred == 1);
    fn = sum(nblbltst == 1 & pred == 0);
    allfps = [allfps fp];
    allfns = [allfns fn];
    allcounts = [allcounts acc];
end
allcounts
mean(allcounts)
