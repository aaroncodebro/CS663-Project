function img_graph = constructImageGraphVerticalSeamsFE(img)
    m = size(img,1);
    n = size(img, 2);
    S = m*n+2;  %total number of nodes including source and sink
    
    g = digraph();
    g = addnode(g, S);
    
    inf_weight = 1000;
    
    %Add infinite weights to edges connecting source and left column
    x = (1:m)+1;
    g = addedge(g, ones(1, m), x, inf_weight*ones(1, m));
    
    %Add infinite weights to edges connecting right column and sink
    x = (1:m) +1+m*(n-1);
    g = addedge(g, x, S*ones(1, m), inf_weight*ones(1, m));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% nLU + LU
    x = reshape((1:m*n)+1, m, n);
    x = reshape(x', 1, m*n);
    x1 = x(1:end-n);
    x2 = x(1+n:end);
    %%%%%% Add nLU edges 
    H = [0,1,0;0,0,-1;0,0,0];
    nLU = zeros(m-1, n);
    for ch=1:3
        nLU_ch = conv2(padarray(img(:,:,ch),[1 1],'replicate','pre'), H);
        nLU_ch = nLU_ch(3:(end-2), 3:(end-1));
        nLU = nLU + nLU_ch;
    end
   
    g = addedge(g, x1, x2, reshape(abs(nLU'), 1,(m-1)*n));
    
    %%%%%% Add LU edges 
    H = [0,0,0;0,0,-1;0,1,0];
    LU = zeros(m-1, n);
    for ch=1:3
        LU_ch = conv2(padarray(img(:,:,ch),[1 1],'replicate','pre'), H);
        LU_ch = LU_ch(3:(end-2), 3:(end-1));
        LU = LU + LU_ch;
    end
   
    g = addedge(g, x2, x1, reshape(abs(LU'), 1,(m-1)*n));
    
   
    %%%%%%  Add LR edges
    H = [1, 0, -1];
    LR = zeros(m, n-1);
    
    for ch=1:3
        LR_ch = conv2(padarray(img(:,:,ch),[0 1],'replicate','pre'), H);
        LR_ch = LR_ch(1:end , 3:(end-2));
        LR = LR + LR_ch;
    end
     
    x = reshape((1:m*n)+1, m, n);
    x = reshape(x, 1, m*n);
    x1 = x(1:end-m);
    x2 = x1 + 6;
    
    g = addedge(g, x1, x2, reshape(abs(LR), 1,m*(n-1)));
    
    
    % Add Horizontal infinite weights
    g = addedge(g, x2, x1, inf_weight*ones(1, m*(n-1)));
    
    % Add Backward Diagonal(bottom to top) infinite weights
    x = reshape((1:m*n)+1, m, n);
    x = x(1:end-1, 1:end-1);
    x1 = reshape(x, 1, []);
    x2 = x1 + (m+1);
    g = addedge(g, x2, x1, inf_weight*ones(1, (m-1)*(n-1)));
    
    % Add Backward Diagonal(top to bottom) infinite weights
    x = reshape((1:m*n)+1, m, n);
    x = x(1:end-1, 2:end);
    x1 = reshape(x, 1, []);
    x2 = x1 - (m-1);
    g = addedge(g, x1, x2, inf_weight*ones(1, (m-1)*(n-1)));
    
    
    
    img_graph = g;
    

end

    
    
 
    
    
    
    
    
  