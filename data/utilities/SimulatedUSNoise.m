function AA=SimulatedUSNoise(t0,n) 

%这是方法2的结果
t=imresize(t0,n);
[height,width]=size(t);
T=double(t).*((0.00000000001)^2*randn(height,width));
% T=double(t./4).*(sqrt(10000)*randn(height));
V=double(zeros(height,width));
k0=2*pi*10^7/1500/1500;
M=3;
h=double(zeros(M,M));
N=floor(M/2);
for y=-N:N
    for x=-N:N
        h(x+N+1,y+N+1)=sin(k0*x)*exp((-1*x*x)/(2*2*2)).*exp((-1*y*y)/(2*1.5*1.5));
    end
end
V=xconv2(double(T),h);
Va=hilbert(V');
A=abs(Va);
A=A';
AA=0.5.*A+sqrt(0.9.*A);

% figure,
% subplot(2,2,1);
% imshow(t);
% subplot(2,2,2);
% imshow(T,[]);
% subplot(2,2,3);
% imshow(A,[]);
% subplot(2,2,4);
% imshow(AA,[]);

AA=imresize(AA,1/n);
% figure,imshowpair(t0,AA,'montage')
% figure,imshowpair(t0,AA,'diff')