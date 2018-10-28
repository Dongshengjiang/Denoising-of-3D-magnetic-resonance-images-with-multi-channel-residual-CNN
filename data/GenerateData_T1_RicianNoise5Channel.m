
%% Generate the training data. 3channel
clear;close all;
addpath('utilities');
addpath('T1_HH_IXI')
dirT1=dir('T1_HH_IXI\*.nii');
modelName = 'ImRicianPaper5Channel_level15';
if ~exist(modelName,'file')
    mkdir(modelName);
end
level=15;
level=level*255/100;

% level=[1,3,5,7,9,11,13,15];
Channel=5;

%% randomly saperate into Trainingset(2/3) and Testset(1/3)
% RandomNum=randperm(numel(dirT1));
% TrainNum=ceil(numel(dirT1)*2/3);
% TestNum=numel(dirT1)-TrainNum;
% save (fullfile(modelName,'group.mat'), 'RandomNum','TrainNum','TestNum')
modelName0 = 'ImRicianPaper5Channel_level1';
load(fullfile(modelName0,'group.mat'))
%% load the data and generate the patches

for i=1:TrainNum
    t1Training{i}=load_nii(dirT1(RandomNum(i)).name);
    t1Training{i}=single((mat2gray(t1Training{i}.img)).*255);
    RandomNum(i)
end

for i=1:TestNum
    t1Test{i}=load_nii(dirT1(RandomNum(i+TrainNum)).name);
    t1Test{i}=single((mat2gray(t1Test{i}.img)).*255);
    RandomNum(i+TrainNum)
end

%generate patches
batchSize      = 64;        %%% batch size
max_numPatches = batchSize*3000;         
size_input    = 60;          %%% training
size_label    = 60;          %%% testing
stride  = 25;          %%% training
[inputs,    labels]  =   patches_generationVolume_Rician3Channel(size_input,size_label,stride,level,t1Training,batchSize,Channel);
[inputsTest, labelsTest]  = patches_generationVolume_Rician3Channel(size_input,size_label,stride,level,t1Test,batchSize,Channel);
set= [ones(1,size(inputs,4)),2*ones(1,size(inputsTest,4)) ];
inputs=cat(4,inputs,inputsTest);
labels=cat(4,labels,labelsTest);
%%% save data
save(fullfile(modelName,'imdb.mat'), 'inputs','labels','set','-v7.3')
% figure,vl_imarraysc(reshape(inputs,size(inputs,1),size(inputs,2),size(inputs,4))),colormap(gray)
% figure,vl_imarraysc(reshape(inputsTest,size(inputsTest,1),size(inputsTest,2),size(inputsTest,4))),colormap(gray)
% figure,vl_imarraysc(reshape(labelsTest,size(labelsTest,1),size(labelsTest,2),size(labelsTest,4))),colormap(gray)