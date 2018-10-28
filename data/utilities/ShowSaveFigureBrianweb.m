function ShowSaveFigureBrianweb(rangeSlice,labelAll,t1InputTest,outputAll,outputAllMixted,outputAllMixted135,fima0,fima1,fima2,fima3)
close all
sliceNum=10;

for j=1:length(t1InputTest)
    figure,title(strcat('Volume=',num2str(j)))
    mv=255;
    map=zeros(mv,3);
    map(:,1)=(0:mv-1)/(mv-1);
    map(:,2)=map(:,1);
    map(:,3)=map(:,1);
    colormap(map);
    subplot(331),image(labelAll(:,:,sliceNum)),xlabel('Original');
    subplot(332),image(t1InputTest{j}(:,:,sliceNum+rangeSlice(1)-1)),xlabel('Noisy')
    subplot(333),image(outputAll{j}(:,:,sliceNum)),xlabel('ResNet')
    subplot(334),image(outputAllMixted{j}(:,:,sliceNum)),xlabel('ResNetMixted')
    subplot(335),image(outputAllMixted135{j}(:,:,sliceNum)),xlabel('ResNetMixted135')
    subplot(336),image(fima0{j}(:,:,sliceNum)),xlabel('Coupe')
    subplot(337),image(fima1{j}(:,:,sliceNum)),xlabel('WSM')
    subplot(338),image(fima2{j}(:,:,sliceNum)),xlabel('ODCT3D')
    subplot(339),image(fima3{j}(:,:,sliceNum)),xlabel('PRI-NLM3D')
    
%         outputAll{j}(:,:,sliceNum),outputAllMixted{j}(:,:,sliceNum),outputAllMixted135{j}(:,:,sliceNum),...
%         fima0{j}(:,:,sliceNum),fima1{j}(:,:,sliceNum),...
%         fima2{j}(:,:,sliceNum),fima3{j}(:,:,sliceNum)),[]);
% xlabel(['Volume=',num2str(j),';----------Adding noise','Original image ------------',...
%     '--------------ResNet Denosing image','---Resnet5ChannelMixted','---Resnet5ChannelMixted135',...
%     '---------Block-wise NLM3D Coupe 2008',...
%     '--------Method 2: Wavelet coefficient Mixing','--------Method 3: 3D ODCT filtering',...
%     '--------Method 4: PRI-NLM3D filtering'])
end