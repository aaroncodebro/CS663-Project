function energy = L1energy(img)
    [FX, FY] = gradient(img);
    E1 = abs(FX) + abs(FY);
    energy = zeros(size(E1,1), size(E1,2));
    energy = E1(:,:,1) + E1(:,:,2) + E1(:,:,3);
end