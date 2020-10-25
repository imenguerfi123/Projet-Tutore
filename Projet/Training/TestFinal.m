clear all
close all
clc
I=imread('37.png');
BW=rgb2gray(I);
%Égalisation dhistogramme adaptatif a contraste limité,recadrage de la
%dynamique,médian,Régions détectées par la LPE,sobel
J=adapthisteq(BW);%améliore le contraste de l'image en niveaux de gris I 
s=imadjust(J)%recadrage de la dynamique selon une correction gamma,
I2=medfilt2(s,[5,5]);
figure,subplot(2,3,1);imshow(I);title('image originale')
subplot(2,3,2);imshow(J);title('Égalisation dhistogramme adaptatif a contraste limité');
subplot(2,3,3);imshow(s);title('recadrage de la dynamique');
subplot(2,3,4),imshow(I2),title('Filtre médian');
Lrgb = label2rgb(I2);
subplot(2,3,5), imshow(Lrgb), title('Régions détectées par la LPE');
hy2 = fspecial('sobel');
hx2 = hy2';
Iy2 = imfilter(double(Lrgb), hy2,'replicate');
Ix2 = imfilter(double(Lrgb), hx2,'replicate');
gradmag2 = sqrt(Ix2.^2 + Iy2.^2);
subplot(2,3,6), imshow(gradmag2,[]), title('Filtre sobel');
%égalisation d'histogramme,Filtre médian,Régions détectées par la
%LPE,prewitt
J1=adapthisteq(BW);%améliore le contraste de l'image en niveaux de gris I 
I4=medfilt2(J1,[3,3]);
figure,subplot(2,3,1);imshow(I);title('image originale')
subplot(2,3,2);imshow(J1);title('Égalisation dhistogramme adaptatif a contraste limité');
subplot(2,3,3),imshow(I4),title('Filtre médian');
Lrgb = label2rgb(I4);
subplot(2,3,4),imshow(Lrgb), title('Régions détectées par la LPE');
%segmentation detection de contour
hy4= fspecial('prewitt');
hx4 = hy4';
Iy4 = imfilter(double(Lrgb), hy4, 'replicate');
Ix4 = imfilter(double(Lrgb), hx4, 'replicate');
gradmag4 = sqrt(Ix4.^2 + Iy4.^2);
subplot(2,3,5), imshow(gradmag4,[]),title('Filtre prewitt');
%Égalisation dhistogramme adaptatif a contraste limité,median,unsharp,prewitt
figure,subplot(2,3,1);imshow(I);title('image originale')
J=adapthisteq(BW)%améliore le contraste de l'image en niveaux de gris I 
subplot(2,3,2),imshow(J),title('Égalisation dhistogramme adaptatif a contraste limité');
I6=medfilt2(J,[5,5]);
subplot(2,3,3),imshow(I6),title('filtre median 5*5');
H1 = fspecial('unsharp');
sharpened = imfilter(I6,H1,'replicate');
subplot(2,3,4);imshow(sharpened); title('Sharpened Image');
Lrgb1 = label2rgb(sharpened);
subplot(2,3,5), imshow(Lrgb1),title('Régions détectées par la LPE');
hy4= fspecial('prewitt');
hx4 = hy4';
Iy4 = imfilter(double(Lrgb1), hy4, 'replicate');
Ix4 = imfilter(double(Lrgb1), hx4, 'replicate');
gradmag4 = sqrt(Ix4.^2 + Iy4.^2);
subplot(2,3,6), imshow(gradmag4,[]),title('Filtre prewitt');
%filtre median 3*3,filtre wiener,Régions détectées par la LPE,sobel
I6=medfilt2(BW,[7,7]);
K3 = wiener2(I6,[5 5]);
figure,subplot(2,3,1);imshow(I);title('image originale')
subplot(2,3,2),imshow(I6),title('filtre median 3*3');
subplot(2,3,3);imshow(K3);title('filtre wiener');
Lrgb1 = label2rgb(K3);
subplot(2,3,4), imshow(Lrgb1), title('Régions détectées par la LPE');
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(Lrgb1), hy, 'replicate');
Ix = imfilter(double(Lrgb1), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
subplot(2,3,5), imshow(gradmag,[]), title('filtre sobel');
%wiener,médian,unsharp,sobel
K5= wiener2(BW,[5 5]);
I5=medfilt2(K5,[5,5]);
figure,subplot(2,3,1);imshow(I);title('image originale');
subplot(2,3,2),imshow(K5),title('image filtré par wiener');
subplot(2,3,3),imshow(I5),title('filtre median 5*5');
H1 = fspecial('unsharp');
sharpened = imfilter(I5,H1,'replicate');
subplot(2,3,4);imshow(sharpened); title('Sharpened Image');
subplot(2,3,5),imcontour(sharpened,5),title('un tracé de contour');
hy3 = fspecial('sobel');
hx3 = hy3';
Iy3 = imfilter(double(sharpened), hy3, 'replicate');
Ix3 = imfilter(double(sharpened), hx3, 'replicate');
gradmag = sqrt(Ix3.^2 + Iy3.^2);
subplot(2,3,6), imshow(gradmag,[]), title('Module du gradient');
%Égalisation dhistogramme adaptatif acontraste limité,Régions détectées par
%la LPE,sobel
J3=adapthisteq(BW);%améliore le contraste de l'image en niveaux de gris I 
figure,subplot(2,2,1);imshow(I);title('image originale')
subplot(2,2,2),imshow(J3),title('Égalisation dhistogramme adaptatif acontraste limité');
Lrgb1 = label2rgb(J);
subplot(2,2,3), imshow(Lrgb1), title('Régions détectées par la LPE');
hy1 = fspecial('sobel');
hx1 = hy1';
Iy1 = imfilter(double(Lrgb1), hy1, 'replicate');
Ix1 = imfilter(double(Lrgb1), hx1, 'replicate');
gradmag1 = sqrt(Ix1.^2 + Iy1.^2);
subplot(2,2,4), imshow(gradmag1,[]), title('Filtre sobel');
%Égalisation dhistogramme adaptatif a contraste limité,median,Régions
%détectées par la LPE,laplacian du gaussian
J4=adapthisteq(BW)%améliore le contraste de l'image en niveaux de gris I 
I2=medfilt2(J4,[5,5])
figure,subplot(2,3,1);imshow(I);title('image originale')
subplot(2,3,2),imshow(J),title('Égalisation dhistogramme adaptatif a contraste limité')
subplot(2,3,3),imshow(I2),title('filtre median 5*5');
Lrgb = label2rgb(I2);
subplot(2,3,4), imshow(Lrgb), title('Régions détectées par la LPE');
H2= fspecial('log',[5,5],0.3);
M2 = imfilter(Lrgb,H2,'replicate');
subplot(2,3,5),imshow(M2),title('filtre laplacian du gaussian');


