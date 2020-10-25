clear all
close all
clc
I=imread('image1.png');
BW=rgb2gray(I);
[L,num]=bwlabel(BW,4)
figure,subplot(3,4,1),imshow(I),title('Image')
subplot(3,4,2),imhist(BW,128),title('histogramme');
subplot(3,4,3),imshow(BW),title('image au niveau de gris')
subplot(3,4,4),histeq(BW),title('image dont lhistogramme est �galis�');
J=adapthisteq(BW)%am�liore le contraste de l'image en niveaux de gris I 
subplot(3,4,5),imshow(J),title('�galisation dhistogramme adaptatif a contraste limit�');
subplot(3,4,6),im2bw(I,0.5),title('image binaris�e');
bw=edge(BW) ;% d�tecter les contours
subplot(3,4,7),imshow(~bw,2),title('image binaire invers�e des contours');
%trace un trac� de contour de l'image en niveaux de gris I
subplot(3,4,8),imcontour(BW,5),title('un trac� de contour');
C= makecform('srgb2lab');%la conversion de l'espace colorim�trique sp�cifi�e par type. 
lab=applycform(I,C);%conversion les valeurs de couleur en A en l'espace de couleur sp�cifi� c 
subplot(3,4,9),imshow(lab),title('conversion de couleurs');
ultimateErosion = bwulterode(bw);
subplot(3,4,10),imshow(ultimateErosion),title('Euclidienne transform�e de distance du compl�ment');
c = [222 272 300 270 221 194];
r=[21 21 75 121 121 75]
K = roipoly(I,c,r);
%Utilisez roipoly pour sp�cifier une r�gion polygonale d'int�r�t (ROI) dans
%une image. Roipoly renvoie une image binaire que vous pouvez utiliser comme masque pour le filtrage masqu�.
subplot(3,4,11), imshow(K),title('une r�gion d�int�r�t')
bw = im2bw(I, graythresh(I));%convertir l'image en niveaux de gris I en une image binaire
[B,L] = bwboundaries(bw,'noholes');%trace les fronti�res ext�rieures des objets,et les limites des trous � l'int�rieur de ces objets
subplot(3,4,12),imshow(label2rgb(L, @jet, [.5 .5 .5])),title('s�lectionne les couleurs de toute la plage')
hold on
for k = 1:length(B)
    boundary = B{k};%renvoie les points limites entre les segments de l'objet de distribution par morceaux
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end









