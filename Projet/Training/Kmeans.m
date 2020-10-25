% Lecture et affichage de l'image
clear all
close all
clc
I=imread('image1.png');
BW=rgb2gray(I);
I2=medfilt2(BW,[5,5]);
figure,subplot(2,2,1);imshow(I);title('image originale')
subplot(2,2,2),imshow(I2),title('Filtre médian');
% subplot(1,2,1);imshow(niveau);
%Initialisation 
m=2; %degré de flou
nc=2  %Nombre de classes
[r,c]=size(I2);
% matrice de partition qui comporte le degré de partition de chaque pixel
d=zeros(r*c,nc);
v=zeros(1,r*c);
x=zeros(1,r*c);
for t=1:c %Remplissage de r
    x(r.*(t-1)+1:r.*t)= I2(:,t);
end;
randn('seed',0);
u=0.1*randn(r*c,nc);
u=u-mean2(u);
N=norm(u);
 
% Calcul des centres de classes
nil=0;
while N>0.0001
    for i=1:nc
        v(i)=x*(u(:,i).^m)./sum(u(:,i).^m);
    end;
 
%Mise à jour de la matrice de partition U 
 %Calcul des distances euclidiennes
for i=1:nc
   d(:,i)=abs(x'-v(i));
end;
%calcul de la matrice de partition
s=u;
u=zeros(r*c,nc);
for i=1:r*c
   if d(i,1)<d(i,2);
       u(i,1)=1;
   else
       u(i,2)=1;
   end;
end;
N=norm(s-u);
nil=0;
nil=nil+1;
end
nil;
%Construction de la matrice de l'image segmentée
b4=zeros(r,c);
 
for i=1:r
   for j=1:c
       for k=1:nc
           if u((j-1)*r+i,k)==1
               b4(i,j)=k;
           end;
       end;
    end;
end;
b4=2-b4;
subplot(2,2,3);
imshow(b4,[]);
title('Segmentation avec k-means');
Lrgb = label2rgb(b4);
subplot(2,2,4), imshow(Lrgb), title('Régions détectées par la LPE');