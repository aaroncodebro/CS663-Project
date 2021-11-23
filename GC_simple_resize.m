function new_img = GC_simple_resize(img, p, q)

    m = size(img, 1);
    n = size(img, 2);

    for t=1:(n-q)

        new_img = removeVerticalSeam_GC(img);
        img = new_img;    
    end
    
    img = imrotate(img, 90);
    for t=1:(m-p)

        new_img = removeVerticalSeam_GC(img);
        img = new_img;    
    end
    
    new_img = imrotate(new_img, -90);

    imshow(new_img/255)

end