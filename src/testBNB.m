function [acc pred softpred]  = testBNB(model, allSNumBi, labels, params)

nbsenttst = allSNumBi;
nblbltst = labels;

pred = zeros(size(labels));

for i = 1:length(nbsenttst)
    %words(nbsenttst{i})
    nbsentraw = nbsenttst{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    ind = zeros(params.dictsize, 1);
%     updates = unique(nbsentraw);
%     counts = power(histc(nbsentraw, updates)', params.testp);
    
    ind(nbsentraw) = 1;
    ind = logical(ind);
    neglog = sum(model.lpwneg(ind)) + sum(model.mlpwneg(~ind));
    poslog = sum(model.lpwpos(ind)) + sum(model.mlpwpos(~ind));
    if neglog + model.pneg  > poslog + model.ppos 
        pred(i) = 0;
    else
        pred(i) = 1;
    end
    softpred(i) = poslog - neglog;
end

acc = sum(pred == labels) / length(labels);
acc = acc*100
