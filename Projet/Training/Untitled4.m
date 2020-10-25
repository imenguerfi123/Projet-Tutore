global mesurer_taches_couleurs % declaration variables
global k
 
disp('Application pour calculer le centre de masse d''une image de test qui est lu avec imread');
% i image multiples niveaux de gris
% j- image binaire (0-1)
i=imread('image2.jpg');imshow(i) % lire l'image dans variable i
j = im2bw(i, 0.5); % le threshold=0.4 pour l'image binaire
valeur_threshold = 100; %valeur threshold
% % j = imfill(j, 'holes');
subplot(3,2,1); imagesc(i); colormap(gray(256)); title('L''image initialle');
subplot(3,2,2); imagesc(j); colormap(gray(256));
title('Imagine binara');
label= bwlabel(j, 8); % etiquetation des regions avec bwlabel
couleurs_labels= label2rgb (label, 'hsv', 'k', 'shuffle');% couleurs aleatoires pour les labels
subplot(3,2,3); imagesc(label); title('L''image avec les regions etiquetees a l''aide de la fonction bwlabel');
subplot(3,2,4); imagesc(couleurs_labels); title('Couleurs aleatoires  pour les labels -les etiquetes');
mesurer_taches_couleurs= regionprops(label, 'all'); %toutes les proprietes des taches d'encre de l'image
nombre_taches= size(mesurer_taches_couleurs, 1);
subplot(3,2,5); imagesc(i); title('Exposition des elements');
hold on % on retient les graphiques
%La fonction bwboundaries retourne un cell-array ou chaque celulle contient
% les coordonnees ligne et colonne pour chaque objet de l'image
frontiere = bwboundaries(j); % j este imagine binara
%functia cell2 mat -conversion la variable de tip cell-array dans une variable de type matrice (array)
%de tip matrice
for contor = 1 : nombre_taches
    tache_couleur_courante = cell2mat(bwboundaries(contor));
    plot(tache_couleur_courante(:,2),tache_couleur_courante(:,1), 'g','LineWidth', 2);
end
hold off;
for k = 1 : nombre_taches % parcourir tous les taches des couleurs
    lister_pixels = mesurer_taches_couleurs(k).PixelIdxList; % lister les pixels a l'aide de PixelIdxList
    hold off;
    % operation mean pour chaque tache de couleur
    moyenne = mean(i(lister_pixels)); % l'intesite moyenne dans l'image i
    surface_tache = mesurer_taches_couleurs(k).Area; % surface
    perimetre_tache = mesurer_taches_couleurs(k).Perimeter; % perimetre
    centre_de_masse = mesurer_taches_couleurs(k).Centroid; % centroide-centre de masse
 
    % affichage des dates avec fprintf
 
    fprintf(1,'#%d %18.1f %11.1f %8.1f %8.1f \n', k, moyenne,surface_tache ,  perimetre_tache,  centre_de_masse ); %affichage avec fprintf
end