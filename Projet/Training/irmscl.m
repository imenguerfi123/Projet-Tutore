clear all
close all
clc
I=imread('image1.png');
BW=rgb2gray(I);
[L,num]=bwlabel(BW,4)
figure,subplot(3,4,1),imshow(I),title('Image')
subplot(3,4,2),imhist(BW,128),title('histogramme');
subplot(3,4,3),imshow(BW),title('image au niveau de gris')
subplot(3,4,4),histeq(BW),title('image dont lhistogramme est égalisé');
J=adapthisteq(BW)%améliore le contraste de l'image en niveaux de gris I 
subplot(3,4,5),imshow(J),title('Égalisation dhistogramme adaptatif a contraste limité');
subplot(3,4,6),im2bw(I,0.5),title('image binarisée');
bw=edge(BW) ;% détecter les contours
subplot(3,4,7),imshow(~bw,2),title('image binaire inversée des contours');
%trace un tracé de contour de l'image en niveaux de gris I
subplot(3,4,8),imcontour(BW,5),title('un tracé de contour');
C= makecform('srgb2lab');%la conversion de l'espace colorimétrique spécifiée par type. 
lab=applycform(I,C);%conversion les valeurs de couleur en A en l'espace de couleur spécifié c 
subplot(3,4,9),imshow(lab),title('conversion de couleurs');
ultimateErosion = bwulterode(bw);
subplot(3,4,10),imshow(ultimateErosion),title('Euclidienne transformée de distance du complément');
c = [222 272 300 270 221 194];
r=[21 21 75 121 121 75]
K = roipoly(I,c,r);
%Utilisez roipoly pour spécifier une région polygonale d'intérêt (ROI) dans
%une image. Roipoly renvoie une image binaire que vous pouvez utiliser comme masque pour le filtrage masqué.
subplot(3,4,11), imshow(K),title('une région d’intérêt')
bw = im2bw(I, graythresh(I));%convertir l'image en niveaux de gris I en une image binaire
[B,L] = bwboundaries(bw,'noholes');%trace les frontières extérieures des objets,et les limites des trous à l'intérieur de ces objets
subplot(3,4,12),imshow(label2rgb(L, @jet, [.5 .5 .5])),title('sélectionne les couleurs de toute la plage')
hold on
for k = 1:length(B)
    boundary = B{k};%renvoie les points limites entre les segments de l'objet de distribution par morceaux
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end









