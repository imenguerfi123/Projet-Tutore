clear all
close all
clc
I=imread('image2.jpg');
BW=rgb2gray(I);
%égalisation d'histogramme et prewitt
J=adapthisteq(BW)%améliore le contraste de l'image en niveaux de gris I 
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2),imshow(J),title('Égalisation dhistogramme adaptatif a contraste limité');
%segmentation detection de conour
i=double(J) ;
%calculer la dérivée selon x de l'intensité en utilisant le filtre de prewitt
Dx=[-1 0 1;-1 0 1;-1 0 1];
Gx=conv2(i,Dx);
%calculer la dérivée selon y de l'intensité en utilisant le filtre de prewitt
Dy=[1 1 1;0 0 0;-1 -1 -1];
Gy=conv2(i,Dy);
%calculer le module du gradient 
G=sqrt((Gx.*Gx)+(Gy.*Gy));
G=uint8(G);
%afficher l'image de module
subplot(1,3,3),imshow(G),title('prewitt')
%wiener et prewitt 
K = wiener2(BW,[7 7]);
figure,subplot(1,6,1);imshow(I);title('image originale')
subplot(1,6,2), imshow(K),title('image filtré par wiener')
BW=double(BW)/255.0;
seuil=0.5;
K=fspecial('prewitt');
v=-K';
Gh=filter2(K,BW);
Gv=filter2(v,BW);
G1=sqrt((Gh.*Gh)+(Gv.*Gv));
Gs=(G1>seuil);
subplot(1,6,3),imshow(Gh),title('Gh')
subplot(1,6,4),imshow(Gv),title('Gv')
subplot(1,6,5),imshow(G1),title('G1')
subplot(1,6,6),imshow(Gs),title('Gs')
%median et prewitt
I2=medfilt2(BW,[7,7]);
figure,subplot(1,6,1);imshow(I);title('image originale')
subplot(1,6,2),imshow(I2),title('filtre median 5*5');
I2=fspecial('prewitt');
v=-I2';
Gh1=filter2(I2,BW);
Gv1=filter2(v,BW);
G2=sqrt((Gh1.*Gh1)+(Gv1.*Gv1));
Gs1=(G2>seuil);
subplot(1,6,3),imshow(Gh1),title('Gh')
subplot(1,6,4),imshow(Gv1),title('Gv')
subplot(1,6,5),imshow(G2),title('G1')
subplot(1,6,6),imshow(Gs1),title('Gs')
%median et laplacien
I3=medfilt2(BW,[3,3]);
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2),imshow(I3),title('filtre median 3*3');
 %afficher l'image segmenté par filtre laplacien
L=edge(I3,'log');
subplot(1,3,3),imshow(L),title('laplacien');
%mhistograme egalisé et laplacien
J1=adapthisteq(BW)%améliore le contraste de l'image en niveaux de gris I 
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2),imshow(J1),title('Égalisation dhistogramme adaptatif a contraste limité');
%afficher l'image segmenté par filtre laplacien
L1=edge(J1,'log');
subplot(1,3,3),imshow(L1),title('laplacien');
%median et tracé de contour
I2=medfilt2(BW,[3,3]);
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2),imshow(I2),title('filtre median 3*3');
subplot(1,3,3),imcontour(I2,5),title('un tracé de contour');
%median et filtre unsharp
I3=medfilt2(BW,[3,3]);
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2),imshow(I3),title('filtre median 3*3');
%filtre unsharp
h= fspecial('unsharp');
M = imfilter(I3,h,'replicate');
subplot(1,3,3),imshow(M),title('filtre unsharp');

% filtre wiener et unsharp 
K = wiener2(BW,[5 5]);
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2), imshow(K),title('image filtré par wiener');
H1 = fspecial('unsharp');
sharpened = imfilter(K,H1,'replicate');
subplot(1,3,3);imshow(sharpened); title('Sharpened Image');
% filtre wiener et filtre canny 
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2), imshow(K),title('image filtré par wiener');
CF=edge(K,'canny');
subplot(1,3,3),imshow(CF),title('Canny');
%filtre wiener et laplacian 
figure,subplot(1,3,1);imshow(I);title('image originale')
subplot(1,3,2), imshow(K),title('image filtré par wiener');
H2= fspecial('log',[5,5],0.3);
M2 = imfilter(K,H2,'replicate');
subplot(1,3,3),imshow(M2),title('filtre laplacian du gaussian');







