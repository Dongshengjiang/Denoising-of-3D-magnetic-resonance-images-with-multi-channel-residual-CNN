# Denoising-of-3D-magnetic-resonance-images-with-multi-channel-residual-CNN
this is the code of paper: Denoising of 3D magnetic resonance images with multi-channel residual learning of convolutional neural network link：
  title={Denoising of 3D magnetic resonance images with multi-channel residual learning of convolutional neural network},
  author={Dongsheng Jiang and Weiqiang Dou and Luc P. J. Vosters and Xiayu Xu and Yue Sun and Tao Tan},
  journal={Japanese Journal of Radiology},
  year={2018},
  volume={36},
  pages={566-574}
https://arxiv.org/abs/1712.08726
It only contains all the code used in my data preprocessing，training and test stages. The model will upload in the future.
As there is not Matlab environment avliable for me now, I can't validate the this code. 
Hope it could be helpful for you.

% ------ Contents -----------------------------------------------------
data
----utilities (如果读取.nii数据，记得加入其中的NIfTI_20140122到matlab path)
----GenerateData_T1_RicianNoise5Channel.m (run this to generate training patches!这是第一步，生成训练数据)

RicianPaper_Train_64_Res_3Channel_10layers.m  (run this to train the model，在此之前要先安装matconvnet库)

RicainTestAll5Channel.m  (test each model，测试脚本，用于测试模型效果)

DnCNN_init_model_64_25_Res_Bnorm_Adam.m  (initializate the model)
DnCNN_train.m (the main body of training code)
vl_nnloss.m   (loss function)
README.txt
%----------------------------------------------------------------------

% If you find any bug, please contact dongshengjiang@aliyun.com
% ----------------------------------------------------------------------
