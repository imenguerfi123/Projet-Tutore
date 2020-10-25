clear all
close all
clc
I=imread('image2.jpg');
BW=rgb2gray(I);
I3=medfilt2(BW,[7,7]);
figure,subplot(2,2,1),imshow(I3),title('Filtre médian');
S=50;
[l c]=size(I3) 
for i=1:l 
    for j=1:c 
        if I3(i,j)<S
            I1(i,j)=0; 
        else  
            I1(i,j)=1; 
        end 
    end 
end 
subplot(2,2,2),imshow(I1);title('Seuillage');
Lrgb = label2rgb(I1);
subplot(2,2,3), imshow(Lrgb), title('Régions détectées par la LPE');
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(Lrgb), hy, 'replicate');
Ix = imfilter(double(Lrgb), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
subplot(2,2,4), imshow(gradmag,[]), title('filtre sobel');

J=double(BW)/255.0;
h=-ones(3,3); 
h(2,2)=8;
F=filter2(h,J); 
I2=medfilt2(BW,[7,7]);
figure,subplot(2,3,1),imshow(I2),title('Filtre médian');
Lrgb = label2rgb(I2);
subplot(2,3,2), imshow(Lrgb), title('Régions détectées par la LPE');
H1 = fspecial('unsharp');
sharpened = imfilter(Lrgb,H1,'replicate');
subplot(2,3,3);imshow(sharpened); title('Sharpened Image');
subplot(2,3,4);imshow(F);title('image filtrée');
subplot(2,3,5),imcontour(F,5),title('un tracé de contour');
hy1 = fspecial('sobel');
hx1 = hy1';
Iy1 = imfilter(double(F), hy1, 'replicate');
Ix1 = imfilter(double(F), hx1, 'replicate');
gradmag = sqrt(Ix1.^2 + Iy1.^2);
subplot(2,3,6), imshow(gradmag,[]), title('filtre sobel');

