function [acc pred softpred] = testMNB(model, X, labels, params)
pwpos = model.pwpos;
pwneg = model.pwneg;

pred = zeros(1, length(X));
softpred = zeros(size(pred));
for i = 1:length(X)
    x = X{i};
    x=x(x>0);
    
    updates = unique(x);
    counts = power(histc(x, updates), params.testp)';    
    
    poslog = sum(pwpos(updates).*counts) + log(model.ppos);
    neglog = sum(pwneg(updates).*counts)+ log(model.pneg);
    
    softpred = poslog - neglog;
    
    pred(i) = softpred > 0;
end
c = sum(labels == pred);
l = length(pred);
acc = 100*c/l;




