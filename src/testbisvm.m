function [acc pred softpred] = testbisvm(model, X, labels, params)
vecstest = sparse(params.dictsize, length(X));
pred = zeros(1, length(X));
for i = 1:length(X)
    nbsentraw = X{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    updates = unique(nbsentraw);
    vecstest(updates,i) = 1;
end

[pred, acc, softpred] = predict(double(labels'), vecstest', model);
%[predicted_labelf, accuracyf, decision_valuesf] = svmpredict(double(labels'), vecstest', modelf, '-t 2');
pred = pred';
softpred = softpred';

