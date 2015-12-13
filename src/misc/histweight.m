meanw = mean(allweights);

w = 1 + 0.3 * mean(allweights) ./ mean(allweights(:));

[~, mostdiscounted] = sort(meanw, 'ascend');
[~, mostexg] = sort(meanw, 'descend');


totalcount = cwpos + cwneg;
filter = totalcount > 30;


topn = 20;
[~, mostnegcount] = sort(rawvecs', 'ascend');

[~, mostnegadj] =sort(w .* rawvecs', 'ascend');

% params.wordsbi(mostnegcount(1:topn))
% 
% params.wordsbi(mostnegadj(1:topn))

[~, mostposcount] = sort(rawvecs', 'descend');

[~, mostposadj] =sort(w .* rawvecs', 'descend');

% params.wordsbi(mostposcount(1:topn))
% 
% params.wordsbi(mostposadj(1:topn))

theorder = mostexg;
filter2 = filter(theorder);
theorder(filter2 == 0) = [];
params.wordsbi(theorder(1:topn))

for i = theorder(1:10)
    meanw = mean(allweights(:,i));
    stdw = std(allweights(:,i));
    everyting0 = sum(allweights(:,i) == 0)./ length(allweights(:,i));
    lessthan0 = sum(allweights(:,i) < 0)./ length(allweights(:,i));

    ss = sprintf('mean:%f-std:%fall0:%f',  meanw, stdw, everyting0);
    sb = sprintf('%s-cwpos:%f-cwneg:%f-rawvec:%f-lessthan0:%f', params.wordsbi{i}, cwpos(i), cwneg(i), rawvecs(i), lessthan0);
   
    name = [sb ss];
    
    hist(allweights(:,i),50)
    title(sb)
    xlabel(ss)
    print(gcf, '-dpng', ['wordanalysis/' name '_hist20.png'])
    %save(['wordanalysis/' name '_hist20.fig'])
end
%%
% 53 'the'    'film'    'provides'    'some
params.wordsbi(allSNumBi{5});
% 19 'offers'    'that'    'rare'    'combination'
for i = 101:200
    if length(allSNumBi{i}) > 30
        continue;
    end
    sentselect = allSNumBi{i};
    params.wordsbi(sentselect);
    imagesc(cov(allweights(:,sentselect)));
    set(gca,'YTick',1:1:length(sentselect))
    set(gca,'YTickLabel',params.wordsbi(sentselect))
    sent5weights = allweights(:, sentselect);
    pause
end

%%

% %%
%  
% meanw = mean(allweights); stdw = std(allweights);
% everyting0 = sum(allweights(:) == 0)./ length(allweights(:));
% meanis0 = sum(meanw == 0)./ length(meanw);
% mlessthan0 = sum(meanw < 0) ./ length(meanw);
% msubsiglessthan0 = sum(meanw - 0.5*stdw > 0) ./ length(stdw);
% 
% fprintf('mean=0 %f meanw<0 %f meanw-stdw<0 %f \n', mlessthan0, msubsiglessthan0)
% 
% uw = meanw ./ mean(meanw);
% sigw = stdw ./ mean(meanw);
% sig0 = 2;
% u0 = 2;
% posteriormode = (sigw.^2 .* u0 + sig0.^2 .* uw) ./ (sigw.^2 + sig0.^2);
% % posteriormode = (sigw .* u0 + sig0 .* uw) ./ (sigw + sig0);
% 
% % if ~isfield(params, 'tryfunc')
% %     
% %     %model.w = 1 + 0.1 * mean(allweights) ./ mean(allweights(:));
% % else
% %     eval(params.tryfunc);
% % end
% model.w = posteriormode;
% 
% modelf = train(double(nblbl'), vecstrain, '-s 1 -c 10', 'col');

% model.w = median(allweights);
% model.w = max(0, 1 - 0.1 * sum(allweights < 0) / params.samplenum);
% r = (sum(allweights >= 0)) / (params.samplenum);
% agree = sign(meanw - beta*stdw.*sign(meanw)) == sign(meanw);
% model.w =  1 + 0.1 .* agree .* ((meanw - beta*stdw.*sign(meanw)) ./ mean(meanw));
% model.w = 1 + 0.2 .* r .* ((meanw - 0.3*stdw.*sign(meanw)) ./ mean(meanw));
% model.w = r .* model.w;
% model.w = 1+sum(allweights>0)./ params.samplenum; %10*mean(allweights(:)) + max(0,mean(allweights));

% [p, a, sp] = predict(double(nblbl(select)'), vecstrain(:,select)', model);
% [p, a, sp] = predict(double(nblbl(~select)'), vecstrain(:,~select)', model);
% 
% model = train(double(nblbl(select)'), vecstrain(:,select), '-s 1 -c 1 -q', 'col');
% 
hold on;
meanw = mean(allweights); stdw = std(allweights);

[~, bestind] = sort(meanw-stdw, 'descend');
sstdw = stdw(bestind);
smeanw = meanw(bestind);
srawvecs = rawvecs(bestind);

n = length(srawvecs);
% plot(srawvecs(1:n), 'g')


plot(smeanw(1:n) - sstdw(1:n), 'r')

% plot(sstdw(1:n), 'r')
% plot(0*sstdw(1:n), 'g')
plot(smeanw(1:n), 'b')
% plot(sstdw(1:n), 'r')
hold off;


% negmwords = find(meanw < 0);
% negmeans = meanw(negmwords);
% total = cwpos(negmwords) + cwneg(negmwords);
% post = cwpos(negmwords);
% [occ, occind] = sort(negmeans, 'ascend');
% snegmwords = negmwords(occind);
% stotal = total(occind);
% snegmeans = negmeans(occind);
% scwpos = post(occind);
% save('negmeansneg', 'snegmwords', 'stotal', 'scwpos', 'snegmeans');
% 
