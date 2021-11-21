%backward energy
function [newImg, seamEnergy, min_seam_loc, newPmask] = removeVerticalBE(energy, img, Pmask)
    %perform dynamic programming to compute min vertical seam
    P = 1000*Pmask;
    M = zeros(size(img,1), size(img,2));
    M(1,:) = energy(1,:);

    rows = size(img,1);
    cols = size(img,2);

    for i=2:rows
        for j=1:cols
            if j == 1
                M(i,j) = P(i,j) + energy(i,j) + min(M(i-1,j), M(i-1,j+1)); 
            elseif j == cols
                M(i,j) = P(i,j) + energy(i,j) + min(M(i-1,j-1), M(i-1,j));    
            else
                M(i,j) = P(i,j) + energy(i,j) + min( min(M(i-1,j-1), M(i-1,j)), M(i-1,j+1));
            end        
        end
    end

    %store the pixel locations for min seam
    min_seam_loc = zeros(rows, 2);

    [v, I] = min(M(rows,:));
    min_at_prev_row = I;
    min_seam_loc(rows,:) = [rows min_at_prev_row];
    
    for i=2:rows
        row = rows - i + 1;
        j = min_at_prev_row;

        if j == 1
            if M(row,j) <= M(row,j+1)
                min_at_prev_row = j;
            else
                min_at_prev_row = j+1;
            end 
        elseif j == cols
            if M(row,j-1) <= M(row,j)
                min_at_prev_row = j-1;
            else
                min_at_prev_row = j;
            end   
        else
            if M(row,j-1) <= M(row,j) && M(row,j-1) <= M(row,j+1)
                min_at_prev_row = j-1;
            elseif M(row,j) <= M(row,j-1) && M(row,j) <= M(row,j+1)
                min_at_prev_row = j;
            else
                min_at_prev_row = j+1;
            end  
        end
        
        min_seam_loc(row,:) = [row, min_at_prev_row];                    
    end
  
    %create mask for pixels that are part of the seam
    mask = zeros(size(img,1), size(img,2));
    seamEnergy = 0;
    for i=1:size(min_seam_loc,1)
        row = min_seam_loc(i,1);
        col = min_seam_loc(i,2);
        
        mask(row, col) = 1;
       
        seamEnergy = seamEnergy + energy(row, col);
    end
    
    mask = logical(mask);
    mask = ~mask;
    
    %now create the updated img
    newImg = zeros(size(img,1), size(img,2)-1, size(img,3));
    for i=1:size(mask,1)
        newImg(i,:,1) = img(i,mask(i,:),1);
        newImg(i,:,2) = img(i,mask(i,:),2);
        newImg(i,:,3) = img(i,mask(i,:),3);
    end
    
    newPmask = zeros(size(Pmask,1), size(Pmask,2)-1);
    for i=1:size(mask,1)
        newPmask(i,:) = Pmask(i,mask(i,:));
    end
end