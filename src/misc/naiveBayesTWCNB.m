cwpos = zeros(length(wordsbi), 1);
cwneg = zeros(length(wordsbi), 1);


nbind = train_ind;
nbsent = allSNumBi(nbind);
nblbl = labels(nbind);
ppos = sum(nblbl)/length(nblbl); pneg = 1 - ppos;

for i = 1:length(nbsent)
    nbsentraw = nbsent{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    updates = unique(nbsentraw);
    counts = histc(nbsentraw, updates)';
     % counts = ones(size(histc(nbsentraw, updates)));
    if nblbl(i) == 1
        cwpos(updates) = cwpos(updates) + counts;
    else
        cwneg(updates) = cwneg(updates) + counts;
    end
end

rawvecs = log((1+cwpos) ./ (1+cwneg));
vecstrain = sparse(length(wordsbi), length(nbsent));
for i = 1:length(nbsent)
    nbsentraw = nbsent{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    updates = unique(nbsentraw);
    counts = histc(nbsentraw, updates);
    vecstrain(updates,i) = counts;
end
d = vecstrain;
% d(d>0) = log(1+d(d>0));
% d = bsxfun(@times, d, log(size(d,2)./ (1e-10+sum(d>0,2))) );
% d = bsxfun(@rdivide, d, sqrt(sum(d.*d,1)) );
ai = 0.5;
dn = d(:,~nblbl);
thetap = (sum(dn,2)+ai) / (sum(dn(:)) + ai * size(dn,1));
dp = d(:,nblbl);
thetan = (sum(dp,2)+ai) / (sum(dp(:)) + ai * size(dp,1));
wno = log(thetan); wpo = log(thetap);
wn = wno / sum(abs(wno));
wp = wpo / sum(abs(wpo));

nbindtst = test_ind;
nbsenttst = allSNumBi(nbindtst);
nblbltst = labels(nbindtst);
vecstest = sparse(length(wordsbi), length(nbsenttst));

for i = 1:length(nbsenttst)
    nbsentraw = nbsenttst{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    updates = unique(nbsentraw);
    counts = histc(nbsentraw, updates);
    vecstest(updates,i) = counts;
end

predn = wn' * vecstest;
predp = wp' * vecstest;

pscore = predn - predp + log(ppos)/sum(abs(wpo));
nscore = predp - predn + log(pneg)/sum(abs(wno));

pred = pscore > nscore;

c = sum(nblbltst == pred);
l = length(pred);
rate = c/l
% [predicted_labeltr, ratetr, decision_valuestr] = predict(double(nblbl'), vecstrain', model);
% 
% [predicted_label, rate, decision_values] = predict(double(nblbltst'), vecstest', model);
% 
