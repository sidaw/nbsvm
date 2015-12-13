cwpos = 1*ones(length(wordsbi), 1);
cwneg = 1*ones(length(wordsbi), 1);


nbind = train_ind;
nbsent = allSNumBi(nbind);
nblbl = labels(nbind);
ppos = sum(nblbl)/length(nblbl); pneg = 1 - ppos;

for i = 1:length(nbsent)
    nbsentraw = nbsent{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    updates = unique(nbsentraw);
    counts = power(histc(nbsentraw, updates)', trainp);
     % counts = ones(size(histc(nbsentraw, updates)));
    if nblbl(i) == 1
        cwpos(updates) = cwpos(updates) + counts * (0.5/ppos);
    else
        cwneg(updates) = cwneg(updates) + counts * (0.5/pneg);
    end
end
% cwpos = cwpos * sum(cwneg) ./ sum(cwpos);
pwpos = log(cwpos / sum(cwpos));
pwneg = log(cwneg / sum(cwneg));

% cwpos = cwpos ./ norm(cwpos);
% cwneg = cwneg ./ norm(cwneg);

nbindtst = test_ind;
nbsenttst = allSNumBi(nbindtst);
nblbltst = labels(nbindtst);

pred = zeros(1, length(nbsenttst));
% predvote = zeros(1, length(nbsenttst));
% load('../data/sentiLex.mat', 'sentlex', 'sentlexval');
% 
% sentimap = containers.Map(sentlex, sentlexval);
% wordSent = zeros(length(words),1);
% for i = 1:length(words)
%         if sentimap.isKey(words{i}) && sentimap(words{i}) <= 1
%            wordSent(i) = 2*sentimap(words{i}) - 1;
%         end
% end
    
softpred = zeros(size(pred));
bipred = zeros(1, length(nbsenttst));
unipred = zeros(1, length(nbsenttst));
for i = 1:length(nbsenttst)
    nbsentraw = nbsenttst{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    
    updates = unique(nbsentraw);
    counts = power(histc(nbsentraw, updates), testp)';    
    
    sentend = floor(length(nbsentraw)/2);
    sentword = nbsentraw(1:sentend);
    sentbi = nbsentraw(sentend+1:end);
    
    predsent = cwpos([sentword]) ./ cwneg([sentword]);
    totsent = cwpos([sentword]) + cwneg([sentword]);
    predbi = cwpos([sentbi]) ./ cwneg([sentbi]);
    
    weightsent = 1 - flukeprob(cwpos([sentword]),  cwneg([sentword]));
    weightbi = 1 - flukeprob(cwpos([sentbi]),  cwneg([sentbi]));

    predval = sum(log(predsent) ) + ...
        sum(log(predbi)) + log(ppos) - log(pneg) ;
    
    bipred(i) =  prod(predbi) > 1;
    unipred(i) =  prod(predsent) > 1;
    pred(i) = predval > 0;

%     softpredp(i) = poslog;
%     softpredn(i) = neglog;
    vis = 0;

    if vis && pred(i) ~= nblbltst(i)
        if nblbltst(i) ==0
            i;
        end
    for s = 1:length(sentword)
    fprintf('%s\t\t%d\t%d\t%f\t%f\n', wordsbi{sentword(s)},...
    cwpos(sentword(s)) , cwneg(sentword(s)), predsent(s), weightsent(s))
    end
    
    for s = 1:length(sentbi)
    fprintf('%s\t\t%d\t%d\t%f\t%f\n', wordsbi{sentbi(s)},...
    cwpos(sentbi(s)) , cwneg(sentbi(s)), predbi(s), weightbi(s))
    end

    subplot(2,1,1)
    plot(log(cwpos(sentword) ./ cwneg(sentword)) .* weightsent);
    set(gca,'XTickLabel',wordsbi(sentword))
    set(gca,'XTick',1:sentend)
    
    
    subplot(2,1,2)
    plot(log(cwpos(sentbi) ./ cwneg(sentbi)) .* weightbi);
    set(gca,'XTickLabel',wordsbi(sentbi))
    set(gca,'XTick',1:sentend+1)
    end
%     predvote(i) = sum(wordSent(nbsentraw));
end

sum(nblbltst == pred)
% sum(nblbltst == (predvote > 0))

% indvoted = (predvote ~= 0);
% sum(nblbltst(indvoted) == (predvote(indvoted)>0))

% 
test_sents = allSStr(test_ind);
fid = fopen('../output/nbtestexamplesc.txt','w');
for i = 1:length(test_sents)
    nbsentraw = nbsenttst{i};
    nbsentraw=nbsentraw(nbsentraw>0);
    poslog = sum(pwpos(nbsentraw));
    neglog = sum(pwneg(nbsentraw));
    
    fprintf(fid,'%s\n', cell2str(test_sents{i}) );
end
fclose(fid);

c = sum(nblbltst == pred)
l = length(pred)
rate = c/l



