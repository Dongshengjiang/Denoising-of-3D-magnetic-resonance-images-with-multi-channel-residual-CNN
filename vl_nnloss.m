function Y = vl_nnloss(X,c,dzdy,varargin)
% c=c(:,:,3,:);
% --------------------------------------------------------------------
% pixel-level L2 loss
% --------------------------------------------------------------------
% [size(X) size(c)]
if nargin <= 2 || isempty(dzdy)
    t = ((X-c).^2)/2;
    Y = sum(t(:))/size(X,4); % reconstruction error per sample;
else
    Y = bsxfun(@minus,X,c).*dzdy;
end

