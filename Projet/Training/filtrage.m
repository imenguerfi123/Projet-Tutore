%prétraitement 
clear all
close all
clc
I=imread('image2.jpg');
BW=rgb2gray(I);
y=double(BW)/255.0;%la valeur de double précision pour BW
h=1/9*ones(3,3);% noyau de filtre moyenneur 3*3 
F=filter2(h,y); 
figure(2 );subplot(1,4,1);imshow(I);title('image originale');
subplot(1,4,2);imshow(F);title('moyenneur 3*3 ');
for(i=1:3)
    I2(:,:,i)=medfilt2(I(:,:,i),[3,3]);
end
subplot(1,4,3),imshow(I2),title('filtre median 3*3');
K = wiener2(BW,[5 5]);
subplot(1,4,4), imshow(K),title('image filtré par wiener');

%segmentation detection de conour
i=double(BW) ;
%calculer la dérivée selon x de l'intensité en utilisant le filtre de prewitt
Dx=[-1 0 1;-1 0 1;-1 0 1];
Gx=conv2(i,Dx);
%calculer la dérivée selon y de l'intensité en utilisant le filtre de prewitt
Dy=[1 1 1;0 0 0;-1 -1 -1];
Gy=conv2(i,Dy);
%calculer le module du gradient 
G=sqrt((Gx.*Gx)+(Gy.*Gy));
G=uint8(G);
figure,subplot(1,4,1), imshow(BW),title('image originale');
%afficher l'image de module
subplot(1,4,2),imshow(G),title('prewitt')
%calculer la dérivée selon x de l'intensité en utilisant le filtre de Sobel
Dx1=[-1 0 1;-2 0 2;-1 0 1];
Gx1=conv2(BW,Dx1);
%calculer la dérivée selon y de l'intensité en utilisant le filtre de Sobel
Dy1=[1 2 1;0 0 0;-1 -2 -1]
Gy1=conv2(BW,Dy1);
%calculer le module du gradient 
G1=sqrt((Gx1.*Gx1)+(Gy1.*Gy1));
%afficher l'image de module
subplot(1,4,3),imshow(G1),title('sobel')
Dx2=[1 0;0 -1];
Gx2=conv2(BW,Dx2);
%calculer la dérivée selon y de l'intensité en utilisant le filtre de Roberts
Dy2=[0 1;-1 0]
Gy2=conv2(BW,Dy2);
%calculer le module du gradient 
G2=sqrt((Gx2.*Gx2)+(Gy2.*Gy2));
%afficher l'image de module
subplot(1,4,4),imshow(G2),title('Roberts')

%afficher l'image segmenté selon filtre canny
CF=edge(BW,'canny');
figure(2),subplot(1,3,1),imshow(CF),title('Canny');
%segmentation par seuillage
S=12;
[l c]=size(I); 
for i=1:l 
    for j=1:c 
        if I(i,j)<S 
            I1(i,j)=0; 
        else  
            I1(i,j)=1; 
        end 
    end 
end 
 subplot(1,3,2),imshow(I1);
 %afficher l'image segmenté par filtre laplacien
L=edge(BW,'log');
subplot(1,3,3),imshow(L),title('laplacien');



%Motion Blurred Image
H = fspecial('motion',20,45);
MotionBlur = imfilter(I,H,'replicate');
figure,subplot(1,4,1);
imshow(MotionBlur);title('Motion Blurred Image');

%Blurred Image
H = fspecial('disk',10);
blurred = imfilter(I,H,'replicate');
subplot(1,4,2);
imshow(blurred); title('Blurred Image');

%Sharpened Imag

H = fspecial('unsharp');
sharpened = imfilter(I,H,'replicate');
subplot(1,4,3); 
imshow(sharpened); title('Sharpened Image');

%filtre log
h= fspecial('log',[5,5],0.3);
M = imfilter(I,h,'replicate');
subplot(1,4,4),imshow(M),title('filtre laplacian du gaussian');


