function model = trainMNBSVM(X, labels, params)

if ~exist('params', 'var') || ~isfield(params, 'a')
    params.a = 1;
end
if ~exist('params', 'var') || ~isfield(params, 'trainp')
    params.trainp = 0;
end
if ~isfield(params, 'beta')
    params.beta = 0.25;
end

addpath('~/matlib/liblinear-1.8/matlab/');

cwpos = zeros(params.dictsize, 1);
cwneg = zeros(params.dictsize, 1);

ppos = sum(labels)/length(labels); pneg = 1 - ppos;
intrain = false(params.dictsize, 1);

for i = 1:length(X)
    x = X{i};
    x=x(x>0);
    updates = unique(x);
    counts = power(histc(x, updates)', params.trainp);
    intrain(updates) = true;
    if labels(i) == 1
        cwpos(updates) = cwpos(updates) + counts;
    else
        cwneg(updates) = cwneg(updates) + counts;
    end
end

pwpos = zeros(params.dictsize, 1);
pwneg = zeros(params.dictsize, 1);
pwpos(intrain) = log(params.a+cwpos(intrain)) - log(sum(params.a+cwpos(intrain)));
pwneg(intrain) = log(params.a+cwneg(intrain)) - log(sum(params.a+cwneg(intrain)));

rawvecs = pwpos - pwneg;
vecstrain = sparse(params.dictsize, length(X));

for i = 1:length(X)
    x = X{i};
    if isempty(x); continue; end
    x=x(x>0);
    updates = unique(x);
    counts = power(histc(x, updates)', params.testp);
    vecstrain(updates,i) = rawvecs(updates);
end


model = train(double(labels'), vecstrain(:,:), ['-s 1 -c ' num2str(params.C)], 'col');
w = model.w;
wbar = mean(abs(w(:)));
model.w = (1-params.beta)*wbar + params.beta * w;
model.rawvecs = rawvecs;

