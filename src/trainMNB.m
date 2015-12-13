function model = trainMNB(X, labels, params)
cwpos = zeros(params.dictsize, 1);
cwneg = zeros(params.dictsize, 1);

if ~exist('params', 'var') || ~isfield(params, 'a')
    params.a = 1;
end

if ~exist('params', 'var') || ~isfield(params, 'trainp')
    params.trainp = 0;
end

ppos = sum(labels)/length(labels); pneg = 1 - ppos;
intrain = false(params.dictsize, 1);

for i = 1:length(X)
    x = X{i};
    x=x(x>0);
    updates = unique(x);
    counts = power(histc(x, updates)', params.trainp);
    intrain(updates) = true;
    if labels(i) == 1
        cwpos(updates) = cwpos(updates) + counts ;
    else
        cwneg(updates) = cwneg(updates) + counts;
    end
end

model.cwpos = cwpos; model.cwneg = cwneg;

model.pwpos = zeros(params.dictsize, 1);
model.pwneg = zeros(params.dictsize, 1);
model.pwpos(intrain) = log(params.a+cwpos(intrain)) - log(sum(params.a+cwpos(intrain)));
model.pwneg(intrain) = log(params.a+cwneg(intrain)) - log(sum(params.a+cwneg(intrain)));

model.ppos = ppos;
model.pneg = pneg;
