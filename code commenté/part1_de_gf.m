function [y] = part1_de_gf(X,M,Xprime,n)% M = [rand(2,n);zeros(1,n)]
    % gf = part1_de_gf + gP 
    % part1_de_gf(X) = SEGMA_j (aj  x phi_prime(norme_X_moins_Xj) /norme_X_moins_Xj) x X_moins_Xj
    y = zeros(3,1) ;
    for j = 1:n 
        %fprintf('\n\n j = %d\n',j)
        aj = Xprime(j,:) ;
        %if aj == 0 continue 
        %Xi =  M(:,i) 
        Xj =  M(:,j) ;
        X_moins_Xj = X - Xj ;
        norme_X_moins_Xj = norm(X_moins_Xj) ;
        valphi_prime = phi_prime(norme_X_moins_Xj); %%% Attention !!! c'est alpha_i * phi'(||X-X_i||) et non phi ... 
        y = y + aj* valphi_prime/norme_X_moins_Xj * X_moins_Xj ;
    end
end