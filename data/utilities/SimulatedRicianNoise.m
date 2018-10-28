function im_r=SimulatedRicianNoise(im,level) 
%s represent the rician noise level;if we normalize the data into
%[0,255],we can use s as the noise percentage
% im_g = im + s * randn(size(im)); % *Add* Gaussian noise
s=size(im);
im_r=sqrt((im+level*randn(s)).^2+(level*randn(s)).^2);
% im_r = ricernd(im, level); 
% function r = ricernd(v, s)
% % v is the image, s is the ratio
% dim=size(v);
% x = s .* randn(dim) + v;
% y = s .* randn(dim);
% r = sqrt(x.^2 + y.^2);