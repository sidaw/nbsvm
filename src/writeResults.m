function str = writeResults(allcounts, params, custom)
if ~exist('custom','var')
    custom = 'NA';
end

paramsstr = sprintf('length:%d__CVNUM:%d__a:%d__dictsize:%d',...
    params.numcases, params.CVNUM, params.a, params.dictsize);
str = sprintf('%s\t%s\t%s\t%f\t%f', datestr(now), custom, paramsstr, std(allcounts, 1), mean(allcounts));


fsumm = fopen('resultslog.txt','a+');
            
fprintf(fsumm, '%s\n', str);
fclose(fsumm);


alliter = sprintf('%f ', allcounts);

fd = fopen('details.txt','a+');
fprintf(fd, '%s %s \n', str, alliter);
fclose(fd);
