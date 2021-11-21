clc; clear;
img = imread('gp.jpg');
img = double(img);
rows = size(img, 1); cols = size(img, 2);
figure, imshow(img/255);

rem = images.roi.AssistedFreehand('Closed',true,'Color','r');
maintain = images.roi.AssistedFreehand('Closed',true,'Color','b');
draw(rem);draw(maintain);

mask_remove = createMask(rem);
mask_maintain = createMask(maintain);

% if they overlap, then maintain overlapped version
mask_remove = (mask_remove - mask_maintain)>0;
mask = mask_maintain-mask_remove;
% How much to remove
rowDiff = 0       ; colDiff = 10;

ForwardCarve = SeamCarveDP([rows-rowDiff, cols-colDiff], img, mask, 'FE');
% BackwardCarve = SeamCarveDP([rows-rowDiff, cols-colDiff], img, mask, 'BE');
figure, imshow(ForwardCarve/255);
% figure, imshow(BackwardCarve/255);