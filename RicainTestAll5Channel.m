
%%% test the model performance
%加噪声之前需要将数据预处理至[0,255],，然后加入噪声，进行学习，再测试。
% 这样子做就跟对比的方法处于一直的预处理情况。方便对比。
% ---------------改程序用来得到最终的对比结果------------------

%% 加载数据和参数
clear; clc;
close all
addpath(fullfile('data','utilities'));
addpath('data/T1_HH_IXI')
dirT1=dir('data/T1_HH_IXI\*.nii');
modelName0 = 'ImRicianPaper5Channel_level1';
load(fullfile('data',modelName0,'group.mat'))

cutEdge=5;
for i=1:TestNum
    t1Test{i}=load_nii(dirT1(RandomNum(i+TrainNum)).name);
    [m,n,o]=size(t1Test{i}.img);    
    t1Test{i}=single((mat2gray(t1Test{i}.img(cutEdge:m-cutEdge,cutEdge:n-cutEdge,cutEdge:o-cutEdge))).*255);    
    RandomNum(i+TrainNum)
end

level0=5;
level=level0*255/100;  
t1InputTest=t1Test;
for i=1:numel(t1Test)
    for j=1:size(t1Test{i},3)
        t1InputTest{i}=SimulatedRicianNoise(t1Test{i},level);
    end
end

%% 深度学习的测试
modelName        ='ImRicianPaper5Channel_level5';
epoch       =40;
rangeSlice=[25,35];
Channel=5;
outputAll=ResNetTestAll3Channel(modelName,epoch,t1InputTest,rangeSlice,Channel);


modelName        = 'ImRicianPaper5ChannelMixted_1_3_5_10layers';
epoch       =30;
Channel=5;
outputAllMixted=ResNetTestAll3Channel(modelName,epoch,t1InputTest,rangeSlice,Channel);
% 
% modelName        = 'ImRicianPaper5ChannelMixted_1_3_5_8layers';
% epoch       =30;
% Channel=5;
% outputAllMixted_8layers=ResNetTestAll3Channel(modelName,epoch,t1InputTest,rangeSlice,Channel);
% 
% modelName        = 'ImRicianPaper5ChannelMixted_1_3_5_12layers';
% epoch       =30;
% Channel=5;
% outputAllMixted_12layers=ResNetTestAll3Channel(modelName,epoch,t1InputTest,rangeSlice,Channel);


modelName        = 'ImRicianPaper5ChannelMixted_1_3_5';
epoch       =30;
Channel=5;
outputAllMixted135=ResNetTestAll3Channel(modelName,epoch,t1InputTest,rangeSlice,Channel);

modelName        = 'ImRicianPaper5ChannelMixted_1_3_5NoRes'; 
epoch       =30;
Channel=5;
outputAllNoRes=NoResNetTestAll3ChannelNoRes(modelName,epoch,t1InputTest,rangeSlice,Channel);

%% 比较不同的方法的结果

for j=1:length(t1InputTest)
    j
    [fima0{j},fima1{j},fima2{j},fima3{j},t1InputTest2{j}]=FourMethodsCompare(t1InputTest{j},level,rangeSlice);
end

%% 结果输出 PSNR and SSIM

for j=1:length(t1InputTest)
    labelAll{j}=t1Test{j}(:,:,rangeSlice(1):rangeSlice(2));
    [PSNRSSIMres(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(outputAll{j}),1,1);
    [PSNRSSIMresMixted(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(outputAllMixted{j}),1,1);
%     [PSNRSSIMresMixted_8layers(j,1:2)] = Cal_PSNRSSIM3d((labelAll),(outputAllMixted_8layers{j}),1,1);
%     [PSNRSSIMresMixted_12layers(j,1:2)] = Cal_PSNRSSIM3d((labelAll),(outputAllMixted_12layers{j}),1,1);
    [PSNRSSIMresMixted135(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(outputAllMixted135{j}),1,1);
    [PSNRSSIMresMixtedNoRes(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(outputAllNoRes{j}),1,1);
    [PSNRSSIMfima0(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(fima0{j}),1,1);
    [PSNRSSIMfima1(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(fima1{j}),1,1);
    [PSNRSSIMfima2(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(fima2{j}),1,1);
    [PSNRSSIMfima3(j,1:2)] = Cal_PSNRSSIM3d((labelAll{j}),(fima3{j}),1,1);
end

disp(['ImRicianPaper5Channel_level1: ',num2str(mean(PSNRSSIMres,1))]);
% disp(['Resnet5ChannelMixted135_8layers: ',num2str(mean(PSNRSSIMresMixted_8layers,1))]);
% disp(['Resnet5ChannelMixted135_12layers: ',num2str(mean(PSNRSSIMresMixted_12layers,1))]);
disp(['Resnet5ChannelMixted135_10layers: ',num2str(mean(PSNRSSIMresMixted,1))]);
disp(['Resnet5ChannelMixted135: ',num2str(mean(PSNRSSIMresMixted135,1))]);
disp(['Resnet5ChannelMixtedNoRes: ',num2str(mean(PSNRSSIMresMixtedNoRes,1))]);
disp(['Block-wise NLM3D: ',num2str(mean(PSNRSSIMfima0,1))]);
disp(['Wavelet coefficient Mixing: ',num2str(mean(PSNRSSIMfima1,1))]);
disp(['3D ODCT filtering: ',num2str(mean(PSNRSSIMfima2,1))]);
disp(['PRI-NLM3D filtering: ',num2str(mean(PSNRSSIMfima3,1))]);

save (['RicianResultsFinal/','ForShowLevel_',num2str(level0),'.mat'],'PSNRSSIMres','PSNRSSIMresMixted',...
   'PSNRSSIMresMixted135','PSNRSSIMresMixtedNoRes', 'PSNRSSIMfima0', 'PSNRSSIMfima1', 'PSNRSSIMfima2', 'PSNRSSIMfima3')
save (['RicianResultsFinal/','ForShowData_Level_',num2str(level0),'.mat'],'t1InputTest2','labelAll','outputAll',...
   'outputAllMixted','outputAllMixted135', 'outputAllNoRes', 'fima0', 'fima1', 'fima2','fima3')

% show serveral figure to see the performence
ShowSaveFigure(rangeSlice,t1Test,t1InputTest,outputAll,outputAllMixted,outputAllMixted135,fima0,fima1,fima2,fima3)










