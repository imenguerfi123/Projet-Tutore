clear all
close all
clc
[fname path]=uigetfile('*All Files','select an image');
fname=strcat(path,fname);
Img=imread(fname);
% Img=imread('image2.jpg'); 
BW=rgb2gray(Img);
J1=adapthisteq(BW);%améliore le contraste de l'image en niveaux de gris I 
I4=medfilt2(J1,[3,3]);
figure,subplot(1,3,1);imshow(Img);title('image originale')
subplot(1,3,2);imshow(J1);title('Égalisation dhistogramme adaptatif a contraste limité');
subplot(1,3,3),imshow(I4),title('Filtre médian');
% Lrgb = label2rgb(I4);
% subplot(2,3,4),imshow(Lrgb), title('Régions détectées par la LPE');
Iter_outer = 100;
Iter_inner = 10;
sigma = 4;  % scale parameter %Paramètre d'échelle
timestep = .1;
mu = 0.1/timestep;
A=255;
nu = 0.001*A^2;  % weight of length term %Poids du terme de longueur
c0 = 1;
epsilon = 1;
Img1 = double(I4(:,:,1));
Img1=normalize01(Img1)*A; % rescale the image intensity to the interval [0,A]%Redéfinir l'intensité de l'image à l'intervalle [0, A]
Mask=(Img1>5);
[nrow,ncol] = size(Img1)
numframe=0;
figure;
imagesc(Img1,[0 255]);colormap(gray);hold on; axis off;axis equal;
%%% initialization of bias field and level set function
b=ones(size(Img1));
initialLSF(:,:,1) = randn(size(Img1));  % randomly initialize the level set functions
initialLSF(:,:,2) = randn(size(Img1));  % Initialiser aléatoirement les fonctions de jeu de niveau
initialLSF(:,:,1)= Mask;  % remove the background outside the mask %Retirer l'arrière-plan à l'extérieur du masque
u = sign(initialLSF);
[c,h] = contour(u(:,:,1),[0 0],'r')
[c,h] = contour(u(:,:,2),[0 0],'b')
hold off
Ksigma=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
% disk_radius = 7; 
% Ksigma=fspecial('disk',disk_radius); % an alternative kernel as a truncated uniform function
KONE=conv2(ones(size(Img1)),Ksigma,'same');
pause(0.1)
totaltime =0
for n = 1:Iter_outer
    t0=cputime;
    [u, b, C]=  lse_bfe_3Phase(u,Img1,b,Ksigma,KONE, nu,timestep,mu,epsilon,Iter_inner);
    t1=cputime;
    totaltime = totaltime + t1-t0;
    if(mod(n,3) == 0)
        pause(0.01);
        imagesc(Img1,[0 255]);colormap(gray);hold on; axis off;axis equal;
        [c,h] = contour(u(:,:,1),[0 0],'r');
        [c,h] = contour(u(:,:,2),[0 0],'b');
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);
        hold off;   
    end
end
I=im2bw(Img);
figure,imshow(I),title('image originale')
figure,imshow(u(:,:,1));title('ventricules et LCR');
figure,imshow(u(:,:,2));title('substance blanche ');
Il=u(:,:,2);
Il=im2bw(Il);
IL2=~Il;
figure,imshow(IL2);title('substance blanche');
label= bwlabel(IL2,4); % etiquetation des regions avec bwlabel
couleurs_labels= label2rgb (label);% couleurs aleatoires pour les labels
figure,imagesc(couleurs_labels); title('Couleurs aleatoires  pour les labels -les etiquetes');
k=u(:,:,1);
k=im2bw(k);
kk=~k;
figure,imshow(kk);title('ventricules et LCR');
label1= bwlabel(kk,4);
couleurs_labels= label2rgb (label1);% couleurs aleatoires pour les labels
figure,imagesc(couleurs_labels); title('Couleurs aleatoires  pour les labels -les etiquetes');
ds=I-IL2;
C=rgb2gray(Img);
C(C<180)=0;
D=im2bw(C);%binary Image
figure,imshow(D);title('Binary Image');
I5=medfilt2(D,[5,5]);
D1=~I5;
D2=ds.*D1;
figure,imshow(D2);title('substance blanche')
figure,imshow(I5);
L11=bwlabel(I5);
T=[];
STATS2 = regionprops(L11, 'FilledImage','FilledArea');
Label=bwlabel(double(I5));%% region :image binaire
E11=regionprops(Label,'Area');
num4=numel(E11)
Vecteur=zeros(num4,1); %vecteur ds lequel je stocke les valeurs
for i=1:num4
  surface=E11(i).Area
Vecteur(i,1)=surface
 end
[B,Indx]=sort(Vecteur,'descend'); %%trier les distance un tri descendant
[pasbesoin,idx] = sort([E11.Area],'descend')
RE= Label==idx(1); %change juste 2 par 1 et ça marche 
% figure,imshow(RE)
%     REE=RE.*I5;        
% figure,imshow(REE)
idx(10:end)=[]
LL=length(idx)
for i=1:length(idx)
    REi= Label==idx(i);
    mytitle=strcat('Object Number:',num2str(i));
    figure,imshow(REi);title(mytitle);
    E1i=regionprops(REi,'Area')
    %100pixel=26.46mm
    surf=E1i.Area*26.46/100
    E2i=regionprops(REi,'perimeter')
    per=E2i.Perimeter*26.46/100
    E3i=regionprops(REi,'Eccentricity')
    E4i=regionprops(REi,'Solidity')
    glcmi=graycomatrix(REi)
    stats1i = graycoprops(glcmi,'contrast') 
    stats2i = graycoprops(glcmi,'Homogeneity') 
    stats3i = graycoprops(glcmi,'Energy') 
   
end



