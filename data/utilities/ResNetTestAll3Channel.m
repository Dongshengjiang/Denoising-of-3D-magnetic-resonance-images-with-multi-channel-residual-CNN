function [outputAll]=ResNetTestAll3Channel(modelName,epoch,t1InputTest,rangeSlice,Channel)

border1=(Channel-1)/2;
useGPU      = 1;
load(fullfile('data',modelName,[modelName,'-epoch-',num2str(epoch),'.mat']));
net = vl_simplenn_tidy(net);
net.layers = net.layers(1:end-1);
%%% move to gpu
if useGPU
    net = vl_simplenn_move(net, 'gpu') ;
end

outputAll={};

for j=1:length(t1InputTest)
    if nargin<4
        rangeSlice=[1,size(t1InputTest{j},3)]
    end
    count=1;
    for i = rangeSlice(1):rangeSlice(2)
        input =t1InputTest{j}(:,:,i-border1:i+border1);        
        if useGPU
            input = gpuArray(input);
        end
        res    = vl_simplenn(net,input,[],[],'conserveMemory',true,'mode','test');
        output = input(:,:,border1+1)-res(end).x;
        if useGPU
            output = gather(output);
        end
        outputAll{j}(:,:,count)=output;
        count=count+1;
    end
end