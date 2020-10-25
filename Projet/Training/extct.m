img = imread('image2.jpg'); %your image
imshow(img);

h = imrect(gca, [75 68 130 112]);
setResizable(h,0)
position = wait(h);
imgc = imcrop(img,position);
figure();
imshow(imgc);