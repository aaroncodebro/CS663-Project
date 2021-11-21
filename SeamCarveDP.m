%reduces an image using backward energy
function reduced_img = SeamCarveDP(output_size, img, Pmask, Etype)
    rows = size(img, 1)      ; cols = size(img, 2);
    rowsReq = output_size(1) ; colsReq = output_size(2);
    rowDiff = rows - rowsReq ; colDiff = cols - colsReq;
%     num = max(rowDiff , colDiff);
    diff = rowDiff + colDiff;
    for i=1:diff
        energy = L1energy(img);
        if(colDiff>0)
            if(Etype=='FE')
                [img, seamEnergy, min_seam_loc, Pmask] = removeVerticalFE(energy, img, Pmask);
            else
                [img, seamEnergy, min_seam_loc, Pmask] = removeVerticalBE(energy, img, Pmask);
            colDiff = colDiff-1;
            end        
        elseif(rowDiff>0)
            if(Etype=='FE')
                [img, seamEnergy, min_seam_loc, Pmask] = removeHorizontalFE(energy, img, Pmask);
            else
                [img, seamEnergy, min_seam_loc, Pmask] = removeHorizontalBE(energy, img, Pmask);
            end
            rowDiff = rowDiff-1;
        end
    end
    reduced_img = img;
end