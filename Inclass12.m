%Inclass 12. 
%GB comments
% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 

file='011917-wntDose-esi017-RI_f0016.tif';
reader=bfGetReader(file);
zplane=reader.getSizeZ;
chan=reader.getSizeC;
time=reader.getSizeT;

plane=reader.getIndex(zplane-1,chan-1,29)+1;
img=bfGetPlane(reader,plane); 

rad=10;
sigma=3;
img_sm=imfilter(img,fspecial('gaussian',rad,sigma));
img_bg=imopen(img_sm,strel('disk',30));
img_sub=imsubtract(img_sm,img_bg);
imshow(img_sub,[0,800])

% 2. threshold this image to get a mask that marks the cell nuclei. 

img_bw = img_sub > 50;
imshow(img_bw)

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

img_close = imclose(img_bw, strel('disk', 5)); 
imshow(img_close); 

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

chan2 = 1; 
iplane2 = reader.getIndex (zplane-1, chan2-1, time-1) +1;
img2 = bfGetPlane(reader, iplane2);

cell_properties1 = regionprops(img_bw, img_sub, 'MeanIntensity', 'Maxintensity', 'Area', 'Centroid');
cell_properties2 = regionprops(img_bw, img2, 'MeanIntensity', 'Maxintensity', 'Area', 'Centroid');

intensities1 = [cell_properties1.MeanIntensity];
intensities2 = [cell_properties2.MeanIntensity];

plot(intensities1, intensities2, 'r.', 'MarkerSize', 18); 
