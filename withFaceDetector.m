im = imread('nasa.jpg');
faceDetector = vision.CascadeObjectDetector;
figure; imshow(im);
hold on;
rows = size(im, 1); cols = size(im, 2);
bbox = step(faceDetector,im);
mask = zeros(rows, cols);
for i=1:size(bbox,1)
    x = floor(bbox(i,1));
    y = floor(bbox(i,2));
    w = floor(bbox(i,3));
    h = floor(bbox(i,4));
    rectangle('Position',[y,x,y+h,x+w]);
    mask(y:y+h,x:x+w) = mask(y:y+h,x:x+w)|1;
end

%mask(:,:) = 0; %uncomment if don't want to use face detector
rowDiff = 0       ; colDiff = 150;
im = double(im);
ForwardCarve = SeamCarveDP([rows-rowDiff, cols-colDiff], im, mask, 'FE');
% BackwardCarve = SeamCarveDP([rows-rowDiff, cols-colDiff], img, mask, 'BE');
imwrite(ForwardCarve/255,"wfacedetector.jpg")
figure, imshow(ForwardCarve/255);
% figure, imshow(BackwardCarve/255);


