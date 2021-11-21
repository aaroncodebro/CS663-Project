clc; clear;
img = imread('gp.jpg');
img = double(img);
rows = size(img, 1); cols = size(img, 2);
figure, imshow(img/255);
% [x1, y2, but] = ginput(1)

% Mask stuff
mask = zeros(rows, cols);
% keep = imfreehand; 
% Protectmask = double(createMask(keep));
% mask = mask + Protectmask
remove = imfreehand;
Removemask = double(createMask(remove));
mask = mask - Removemask;

% mask(485:710, 327:412) = -1;

% How much to remove
rowDiff = 0       ; colDiff = 100;

ForwardCarve = SeamCarveDP([rows-rowDiff, cols-colDiff], img, mask, 'FE');
% BackwardCarve = SeamCarveDP([rows-rowDiff, cols-colDiff], img, mask, 'BE');
figure, imshow(ForwardCarve/255);
% figure, imshow(BackwardCarve/255);