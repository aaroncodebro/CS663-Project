clc; clear;
im = imread('bench.png');
scaled_im = imresize(im,1.5);
figure; imshow(im);
figure; imshow(scaled_im);
rows = size(im, 1); cols = size(im, 2);
scaled_im = double(scaled_im);
mask = zeros(size(scaled_im,1),size(scaled_im,2));
ForwardCarve = SeamCarveDP([rows, cols], scaled_im, mask, 'FE');
size(im)
size(scaled_im)
size(ForwardCarve)
% BackwardCarve = SeamCarveDP([rows, cols], scaled_im, mask, 'BE');
figure, imshow(ForwardCarve/255);
% figure, imshow(BackwardCarve/255);

