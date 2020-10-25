hedge = video.EdgeDetector;
 hcsc = video.ColorSpaceConverter(...
 								'Conversion', 'RGB to intensity');
 hidtypeconv = ...
   video.ImageDataTypeConverter('OutputDataType','single');
 img = step(hcsc, imread('peppers.png'));
 img1 = step(hidtypeconv, img);
 edges = step(hedge, img1);
 imshow(edges);