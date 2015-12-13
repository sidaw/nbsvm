function printTable(allresults)
    datasets = {'AthR'  'XGraph'   'BbCrypt'    'CR'    'IMDB'    'MPQA'    'RT-2k'    'RTs'       'subj'};
    methods = {'MNB' 'SVM' 'NBSVM'};
    ngrams = {'Uni', 'Bi'};
    fprintf('%s\t', datasets{:});
    fprintf('\n');
    for i=1:6
        result = zeros(1, length(datasets));
        gram = ngrams{mod(i,2)+1};
        method = methods{ceil(i/2)};
        for k = 1:length(datasets)
            cr = allresults([datasets{k} '-' method '-' gram]);
            result(k)  = cr;
        end
        fprintf('%.2f\t', result);
        fprintf('\n');
    end
end
