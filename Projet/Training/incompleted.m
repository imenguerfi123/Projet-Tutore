clc;
close all;
clear all;
[fname path]=uigetfile('*.jpg','select an image');
fname=strcat(path,fname);
im=imread(fname);
imshow(im);title('color image');
for(i=1:3)
im2(:,:,i)=imnoise(im(:,:,i),'salt & pepper',.05);
end
figure
imshow(im2);
title('noisy image');
%%median filter
for(i=1:3)
im3(:,:,i)=medfilt2(im2(:,:,i),[3,3]);
end
figure
imshow(im3);
title('median filtered image');
%kernel based filtering
h=fspecial('gaussian',[5 5],.5);
for(i=1:3)
im4(:,:,i)=imfilter(im2(:,:,i),h);
end
figure
imshow(im4);
title('gaussian image');