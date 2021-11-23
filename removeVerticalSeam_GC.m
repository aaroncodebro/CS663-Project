function new_img = removeVerticalSeam_GC(img)

    g = constructImageGraphVerticalSeamsFE(img);

    [~,~,cs,~] = maxflow(g,1,size(g.Nodes,1));
    m = size(img,1);
    n = size(img,2);
    mask = zeros(m*n, 1);
    cs = cs(cs~=1); %remove the source node from the set
    cs = cs-1;
    mask(cs)=1;
    mask = reshape(mask, m, n);



    [~, seam_loc] = min(mask');
    seam_loc = seam_loc-1;
    seam_loc = seam_loc';

    seam = seam_loc==(1:n);
    seam = 1-seam;
    %imshow(seam);

    new_img = zeros(m, n-1, 3);
    x = (1:n);
    for i=1:m
        new_img(i,:,1) = img(i,x(x~=seam_loc(i)),1);
        new_img(i,:,2) = img(i,x(x~=seam_loc(i)),2);
        new_img(i,:,3) = img(i,x(x~=seam_loc(i)),3);
    end

end