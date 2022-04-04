function [y] = part1_de_f(X,M,Xprime,n)% M = [rand(2,n);zeros(1,n)]
    % f = part1_de_f + P 
    % part1_de_f(X) = SEGMA_j aj  x phi(norme_X_moins_Xj)
    y = 0 ;
    
    for j = 1:n 
        %fprintf('\n\n j = %d\n',j)
        aj = Xprime(j,:) ;
        %if aj == 0 continue 
        %Xi =  M(:,i) 
        Xj =  M(:,j) ;
        X_moins_Xj = X - Xj ;
        norme_X_moins_Xj = norm(X_moins_Xj) ;
        valphi = phi(norme_X_moins_Xj);
        y = y + aj*valphi;
    end
end