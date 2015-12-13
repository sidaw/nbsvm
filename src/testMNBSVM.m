function [acc pred softpred] = testMNBSVM(model, X, labels, params)
vecstest = sparse(params.dictsize, length(X));
for i = 1:length(X)
    x = X{i};
    x=x(x>0);
    updates = unique(x);
    
    if isempty(updates); continue; end
    counts = power(histc(x, updates)', params.testp);
    vecstest(updates,i) = counts .* model.rawvecs(updates);
end

[pred, acc, softpred] = predict(double(labels'), vecstest', model);
pred = pred';
softpred = softpred';
