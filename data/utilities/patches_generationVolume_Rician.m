function [inputs, labels] = patches_generationVolume_Rician(size_input,size_label,stride,level,t1Training,batchSize)

inputs  = zeros(size_input, size_input, 1, 1,'single');
labels  = zeros(size_label, size_label, 1, 1,'single');
count   = 0;

for i = 1 :length(t1Training)    
    volumelabel=single(t1Training{i});
    for ii=1:size(volumelabel,3)        
        im_label=volumelabel(:,:,ii);
        for j=1:8            
            im_label2 = data_augmentation(im_label, j);
            [hei,wid] = size(im_label2);
            for x = 1 : stride : (hei-size_input+1)
                for y = 1 :stride : (wid-size_input+1)                    
                    subim_label = im_label2(x : x+size_input-1, y : y+size_input-1);
                    subim_input = SimulatedRicianNoise(subim_label,level); 
                    if numel(find(subim_label<5))<800
                        count       = count+1;
                        inputs(:, :, 1, count)   = subim_input;
                        labels(:, :, 1, count) = subim_label;
                    end
                end
            end
        end
    end
end

inputs = inputs(:,:,:,1:(size(inputs,4)-mod(size(inputs,4),batchSize)));
labels = labels(:,:,:,1:(size(labels ,4)-mod(size(labels ,4),batchSize)));

%最后的label image其实是纯噪声的图像，不是去噪的图像，所以深度学习的目标变了
labels = inputs-labels; %%% residual image patches; pay attention to this!!!

order  = randperm(size(inputs,4));
inputs = inputs(:, :, 1, order);
labels = labels(:, :, 1, order);
% set    = [uint16(ones(1,size(inputs,4)*0.9)),uint16(3*ones(1,size(inputs,4)*0.1))];

disp('-------Original Datasize-------')
disp(size(inputs,4));
%
% subNum = min(size(inputs,4),max_numPatches);
% inputs = inputs(:,:,:,1:subNum);
% labels = labels(:,:,:,1:subNum);
% set    = set(1:subNum);
%
% disp('-------Now Datasize-------')
% disp(size(inputs,4));















