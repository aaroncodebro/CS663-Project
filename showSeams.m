im = imread('bench.png');
im = double(im);
mask = zeros(size(im,1),size(im,2));
output_size = [size(im,1)-100,size(im,2)-20];
reduced_img = showSeamsTP(output_size,im, mask, 'FE');
figure('Name','Reduced Image'); imshow(reduced_img/255);


function reduced_img = showSeamsTP(output_size,img, Pmask, Etype)
    rows = size(img, 1)      ; cols = size(img, 2);
    rowsReq = output_size(1) ; colsReq = output_size(2);
    rowDiff = rows - rowsReq ; colDiff = cols - colsReq;
    diff = rowDiff + colDiff;
    figure('Name','Seams'); imshow(img/255); 
    hold on;
    for i=1:diff
        energy = L1energy(img);
        if(colDiff>0)
            if(Etype=='FE')
                [img, seamEnergy, min_seam_loc, Pmask] = removeVerticalFE(energy, img, Pmask);
            else
                [img, seamEnergy, min_seam_loc, Pmask] = removeVerticalBE(energy, img, Pmask);
            end  
            colDiff = colDiff-1;
            plot(min_seam_loc(:,2),min_seam_loc(:,1),'r')
        elseif(rowDiff>0)
            if(Etype=='FE')
                [img, seamEnergy, min_seam_loc, Pmask] = removeHorizontalFE(energy, img, Pmask);
            else
                [img, seamEnergy, min_seam_loc, Pmask] = removeHorizontalBE(energy, img, Pmask);
            end
            rowDiff = rowDiff-1;
            plot(min_seam_loc(:,1),min_seam_loc(:,2),'r')
        end
    end
    reduced_img = img;
end

