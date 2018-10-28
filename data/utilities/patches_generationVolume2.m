function [inputs, labels,set] = patches_generationVolume2(sigma,size_input,size_label,stride,folder,mode,max_numPatches,batchSize)

inputs  = zeros(size_input, size_input, 1, 1,'single');
labels  = zeros(size_label, size_label, 1, 1,'single');
count   = 0;

ext               =  {'*.jpg','*.png','*.bmp'};
filepaths           =  [];

for i = 1 : length(ext)
    filepaths = cat(1,filepaths, dir(fullfile(folder, ext{i})));
end

for i = 1 : 1%length(filepaths)
    image = imread(fullfile(folder,filepaths(i).name)); % uint8
    %[~, name, exte] = fileparts(filepaths(i).name);
    if size(image,3) == 3
        image = rgb2gray(image); % uint8
    end
    
    for j = 1:1
        % augment data 给图像各种旋转，转置之类的变化，产生更多种异类图像，增加算法的稳定性
        image_aug = data_augmentation(image, j);
        im_label  = im2single(image_aug); % single
        [hei,wid] = size(im_label);
        im_input  = im_label; % single
        
        for x = 1 : stride : (hei-size_input+1)
            for y = 1 :stride : (wid-size_input+1)
                subim_input = im_input(x : x+size_input-1, y : y+size_input-1);
                subim_label = im_label(x : x+size_input-1, y : y+size_input-1);
                count       = count+1;
                inputs(:, :, 1, count)   = subim_input+ single(sigma/255*randn(size(subim_input)));
                labels(:, :, 1, count) = subim_label;
                
            end
        end
    end
end


%最后的label image其实是纯噪声的图像，不是去噪的图像，所以深度学习的目标变了
labels = inputs-labels; %%% residual image patches; pay attention to this!!!


% order  = randperm(size(inputs,4));
% inputs = inputs(:, :, 1, order);
% labels = labels(:, :, 1, order);

set    = uint8(ones(1,size(inputs,4)));
if mode == 1
    set = uint8(2*ones(1,size(inputs,4)));
end

% set    = [uint16(ones(1,size(inputs,4)*0.9)),uint16(3*ones(1,size(inputs,4)*0.1))];

% disp('-------Original Datasize-------')
% disp(size(inputs,4));
%
% subNum = min(size(inputs,4),max_numPatches);
% inputs = inputs(:,:,:,1:subNum);
% labels = labels(:,:,:,1:subNum);
% set    = set(1:subNum);
%
% disp('-------Now Datasize-------')
% disp(size(inputs,4));















