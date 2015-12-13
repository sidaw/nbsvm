function model = trainbisvm(X, labels, params)

if ~isfield(params, 'Cbisvm')
    params.Cbisvm = 0.1;
end

vecstrain = sparse(length(params.dictsize), length(X));
for i = 1:length(X)
    x = X{i};
    x=x(x>0);
    updates = unique(x);
    counts = power(histc(x, updates)', params.trainp);
    if ~isempty(counts)
    vecstrain(updates,i) = counts;
    end
end

model = train(double(labels'), vecstrain', ['-s 1 -c ' num2str(params.Cbisvm)]);
