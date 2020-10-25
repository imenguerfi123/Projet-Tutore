x = rgb2gray(imread('image2.jpg')); %// Read in your image from StackOverflow
x = im2double(x(10:end-10,10:end-10)); %// Crop out a 10 pixel border and convert to [0,1]
thresh_level = graythresh(x); %// Threshold the image
c = x > thresh_level;

%// NEW Code
%//----------
%//Find minimum spanning bounding box %Trouver une zone de délimitation
%minimale
[rows,cols] = find(c);
top_left_x = min(cols(:));
top_left_y = min(rows(:));
bottom_right_x = max(cols(:));
bottom_right_y = max(rows(:));

%//Determine width of bounding box %Déterminer la largeur de la boîte de
%délimitation
width = bottom_right_x - top_left_x + 1;
height = bottom_right_y - top_left_y + 1;

%// Draw rectangle onto image
imshow(x);
h = imrect(gca, [top_left_x top_left_y width height]);
%// End NEW Code
%// -----------

%// From your code... don't know what this is doing actually...
addNewPositionCallback(h,@(p) title(mat2str(p,3)));    
fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));    
setPositionConstraintFcn(h,fcn); 