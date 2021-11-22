%finds optimal seam using Backward Energy
function [newImg, seamEnergy, min_seam_loc, newPmask] = removeHorizontalBE(energy, img, Pmask)
    %perform dynamic programming to compute min horizontal seam
    P = 1000*Pmask;
    M = zeros(size(img,1), size(img,2));
    M(:,1) = energy(:,1);

    rows = size(img,1);
    cols = size(img,2);

    for j=2:cols
        for i=1:rows
            if i == 1
                M(i,j) = P(i,j) + energy(i,j) + min(M(i,j-1), M(i+1,j-1)); 
            elseif i == rows
                M(i,j) = P(i,j) + energy(i,j) + min(M(i-1,j-1), M(i,j-1));    
            else
                M(i,j) = P(i,j) + energy(i,j) + min(M(i-1,j-1), min(M(i,j-1), M(i+1,j-1)));
            end        
        end
    end

    %store the pixel locations for min seam
    min_seam_loc = zeros(cols, 2);

    [v, I] = min(M(:,cols));
    min_at_prev_col = I;
    min_seam_loc(cols,:) = [cols min_at_prev_col];
    
    for j=2:cols
        col = cols - j + 1;
        i = min_at_prev_col;

        if i == 1
            if M(i,col) <= M(i+1,col)
                min_at_prev_col = i;
            else
                min_at_prev_col = i+1;
            end 
        elseif i == rows
            if M(i-1,col) <= M(i,col)
                min_at_prev_col = i-1;
            else
                min_at_prev_col = i;
            end   
        else
            if M(i-1,col) <= M(i,col) && M(i-1,col) <= M(i+1,col)
                min_at_prev_col = i-1;
            elseif M(i,col) <= M(i-1,col) && M(i,col) <= M(i+1,col)
                min_at_prev_col = i;
            else
                min_at_prev_col = i+1;
            end  
        end

        min_seam_loc(col,:) = [col, min_at_prev_col];                    
    end
    
    %create mask for pixels that are part of the seam
    mask = zeros(size(img,1), size(img,2));
    seamEnergy = 0;
    for i=1:size(min_seam_loc,1)
        row = min_seam_loc(i,2);
        col = min_seam_loc(i,1);
        
        mask(row, col) = 1;
        
        seamEnergy = seamEnergy + energy(row, col);
    end
    
    mask = logical(mask);
    mask = ~mask;
    
    %now create the updated img
    newImg = zeros(size(img,1)-1, size(img,2), size(img,3));
    for j=1:size(mask,2)
        newImg(:,j,1) = img(mask(:,j),j,1);
        newImg(:,j,2) = img(mask(:,j),j,2);
        newImg(:,j,3) = img(mask(:,j),j,3);
    end
    
    newPmask = zeros(size(Pmask,1)-1, size(Pmask,2));
    for j=1:size(mask,2)
        newPmask(:,j) = Pmask(mask(:,j),j);
    end
end