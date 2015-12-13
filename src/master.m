addpath('~/matlib/liblinear-1.8/matlab/');
params.C = 1;
params.samplenum = 1;
params.samplerate = 1;
params.Cbisvm = 0.1;
% this is the exponent used to discount raw counts
% set to 1 to use raw counts f, 
% set to 0 to use indicators \hat{f}
params.testp = 0;
params.trainp = 0;

% params.a is the Laplacian smoothing parameter
params.a = 1;
% beta is the interpolation parameter
params.beta = 0.25;
allresults = containers.Map;

%% RT10662
params.CVNUM = 10;
params.doCV = 1;
% load the 10 fold cross validation split
load('../data/rt10662/cv_obj');

% load bigram data
load('../data/rt10662/bigram_rts.mat');
dataset = 'RTs';
gram = 'Bi';
masterCV;

% load unigram data
load('../data/rt10662/unigram_rts.mat');
dataset = 'RTs';
gram = 'Uni';
masterCV;

%% MPQA
params.CVNUM = 10;
params.doCV = 1;

load('../data/mpqa/cv_obj');

load('../data/mpqa/bigram_mpqa.mat');
dataset = 'MPQA';
gram = 'Bi';
masterCV;

load('../data/mpqa/unigram_mpqa.mat');
dataset = 'MPQA';
gram = 'Uni';
masterCV;


%% CR
params.CVNUM = 10;
params.doCV = 1;

load('../data/customerr/cv_obj');

load('../data/customerr/bigram_cr.mat');
dataset = 'CR';
gram = 'Bi';
masterCV;

load('../data/customerr/unigram_cr.mat');
dataset = 'CR';
gram = 'Uni';
masterCV;


%% subjectivity
params.CVNUM = 10;
params.doCV = 1;

load('../data/subj/bigram_subj.mat');
load('../data/subj/cv_obj', 'cv_obj');

% cv_obj = cvpartition(labels,'kfold',10);
% save('../data/subj/cv_obj', 'cv_obj');
% permutate labels randomly as a sanity check
% labels = labels(randperm(length(labels)));

dataset = 'subj';
gram = 'Bi';
masterCV;

load('../data/subj/unigram_subj.mat');
dataset = 'subj';
gram = 'Uni';
masterCV;

%% RT2k
params.CVNUM = 10;
params.doCV = 1;

load('../data/rt2k/cv_obj');

load('../data/rt2k/bigram_rt2k.mat');
dataset = 'RT-2k';
gram = 'Bi';
masterCV;

load('../data/rt2k/unigram_rt2k.mat');
dataset = 'RT-2k';
gram = 'Uni';
masterCV;

%% long movie reviews

params.CVNUM = 1;
params.doCV = 0;
firsthalf = false(1,50000);
firsthalf(1:25000) = true;
train_ind = firsthalf;
test_ind = ~firsthalf;

% bigram
load('../data/mrl/bigram_mrl_striponlybi.mat');
dataset = 'IMDB';
gram = 'Bi';
masterCV;

% unigram
load('../data/mrl/unigram_mrl2.mat');
dataset = 'IMDB';
gram = 'Uni';
masterCV;



%% 20NG ath vs. religion
params.CVNUM = 2;
params.doCV = 0;
params.Cbisvm = 0.1;

load('../data/20ng/bigram_ng20_atheisms_strip_noheader.mat');
% Spliting training/testing data randomly
% cv_obj = cvpartition(labels,'kfold',2);
% save('../data/20ng/cv_obj_alt.atheism.mat', 'cv_obj')
load('../data/20ng/cv_obj_alt.atheism.mat', 'cv_obj');
train_ind = cv_obj.training(1);
test_ind = cv_obj.test(1);

dataset = 'AthR';
gram = 'Bi';
masterCV;

load('../data/20ng/unigram_ng20_atheisms_strip_noheader.mat');
dataset = 'AthR';
gram = 'Uni';
masterCV;

%% 20NG windows vs. graphics
params.CVNUM = 2;
params.doCV = 0;

load('../data/20ng/bigram_ng20_windows_strip_noheader.mat');
% Spliting training/testing data randomly
% cv_obj = cvpartition(labels,'kfold',2);
% save('../data/20ng/cv_obj_windows.mat', 'cv_obj')
load('../data/20ng/cv_obj_windows.mat', 'cv_obj');

train_ind = cv_obj.training(1);
test_ind = cv_obj.test(1);
dataset = 'XGraph';
gram = 'Bi';
masterCV;

load('../data/20ng/unigram_ng20_windows_strip_noheader.mat');
dataset = 'XGraph';
gram = 'Uni';
masterCV;

%% 20NG base vs. crpyt
params.CVNUM = 2;
params.doCV = 0;

load('../data/20ng/bigram_ng20_baseball_strip_noheader.mat');
% Spliting training/testing data randomly
% cv_obj = cvpartition(labels,'kfold',2);
% save('../data/20ng/cv_obj_baseball.mat', 'cv_obj')
load('../data/20ng/cv_obj_baseball.mat', 'cv_obj');

train_ind = cv_obj.training(1);
test_ind = cv_obj.test(1);

dataset = 'BbCrypt';
gram = 'Bi';
masterCV;

load('../data/20ng/unigram_ng20_baseball_strip_noheader.mat');
dataset = 'BbCrypt';
gram = 'Uni';
masterCV;


save(['allresults_' datestr(now)], 'allresults');
printTable(allresults)
