function [C, W] = bicriteria(X, k, w, p)

    T = X;

    C = [];
    
    u = w;
    
    while (size(T, 1) > k)
        n = size(T, 1);

        sample_idx = randsample(n, k, true, u);
        
        M = T(sample_idx, :); % pick centers at random

        T(sample_idx, :) = [];
        
        u(sample_idx, :) = [];
        
        [D, ~] = min(bsxfun(@times, bsxfun(@plus,dot(M,M,2)',dot(T,T,2))-2*(T*M'), u), [], 2);
        
        idx = D < prctile(D, p);
        
        T(idx, :) = [];
        
        u(idx, :) = [];
        
        C = [C; M];
    end
    
    C = [C; T];
    
    [~, L] = min(bsxfun(@times, bsxfun(@plus,dot(C,C,2)',dot(X,X,2))-2*(X*C'), w), [], 2);
    
    W = zeros(size(C, 1), 1);
    for i=1:size(C, 1)
        W(i) = sum(w(L==i));
    end
    W = W + 1;
end