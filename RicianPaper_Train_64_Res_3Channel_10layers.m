
%%% Note: run the 'GenerateData_model_64_25_Res_Bnorm_Adam.m' to generate
%%% training data first.

clear;close all;
clc
%%%-------------------------------------------------------------------------
%%% configuration
%%%-------------------------------------------------------------------------
opts.modelName        = 'ImRicianPaper5Channel_level15'; %%% model name
opts.learningRate     = [logspace(-3,-3,20) logspace(-4,-4,20)];%%% you can change the learning rate
opts.batchSize        = 64; %%% default
opts.gpus             = [1]; %%% this code can only support one GPU!

%%% solver
opts.solver           = 'Adam';

opts.gradientClipping = true; %%% Set 'true' to prevent exploding gradients in the beginning.
opts.expDir      = fullfile('data', opts.modelName);
opts.imdbPath    = fullfile(opts.expDir, 'imdb.mat');
diary(fullfile(opts.expDir,'log.txt'));
diary on;

%%%-------------------------------------------------------------------------
%%%   Initialize model and load data
%%%-------------------------------------------------------------------------
%%%  model
net  = DnCNN_init_model_64_25_Res_Bnorm_Adam_5Channel(10);
%%%  load data
imdb = load(opts.imdbPath) ;
% imdb = load(fullfile('data','ImRicianPaper5ChannelMixted_1_3_5', 'imdb.mat')) ;
%%%-------------------------------------------------------------------------
%%%   Train 
%%%-------------------------------------------------------------------------
[net, info] = DnCNN_train(net, imdb, ...
    'expDir', opts.expDir, ...
    'learningRate',opts.learningRate, ...
    'solver',opts.solver, ...
    'gradientClipping',opts.gradientClipping, ...
    'batchSize', opts.batchSize, ...
    'modelname', opts.modelName, ...
    'gpus',opts.gpus) ;

diary off;
[tr,te]=plotepoch(fullfile(opts.expDir,'log.txt'),length([opts.learningRate]));



