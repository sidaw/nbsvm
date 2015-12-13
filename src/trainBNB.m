function model = trainBNB(allSNumBi, labels, params)


%%
nbsent = allSNumBi;
nblbl = labels;
cwpos = 1*ones(params.dictsize, 1);
cwneg = 1*ones(params.dictsize, 1);

numpos = sum(nblbl);
numneg = length(nblbl) - numpos;
total = numpos + numneg;
model.ppos = numpos/total; model.pneg = numneg/total;



for i = 1:length(nbsent)
    nbsentraw = nbsent{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    updates = unique(nbsentraw);
    counts = power(histc(nbsentraw, updates), params.trainp);
    if nblbl(i) == 1
        cwpos(updates) = cwpos(updates) + counts';
    else
        cwneg(updates) = cwneg(updates) + counts';
    end
end


pwpos = cwpos / (numpos+2);
pwneg = cwneg / (numneg+2);

model.lpwpos = log(pwpos);
model.lpwneg = log(pwneg);
model.mlpwpos = log(1-pwpos);
model.mlpwneg = log(1-pwneg);


