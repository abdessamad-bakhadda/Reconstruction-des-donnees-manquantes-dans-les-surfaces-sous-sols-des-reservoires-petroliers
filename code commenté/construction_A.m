function [A] = construction_A(N,n,K,M,collocations,tab_f)
    K = 6 ;
    %N = 2*N ;
    A = zeros(N,n+K);
    % remplissage de A
    for i = 1:N
        for j = 1:n+K 
            Xi =  M(:,i) ;
            if j <= n  
                pj = collocations(:,j) ;
                Xi_moins_pj = Xi - pj ;
                Norme_Xi_moins_pj = norm(Xi_moins_pj) ; 
                A(i,j) = phi(Norme_Xi_moins_pj); 
            else 
                tab_f{:,j-n};
                val = tab_f{:,j-n}(Xi) ;
                A(i,j) = val ;
            end
        end
    end
end