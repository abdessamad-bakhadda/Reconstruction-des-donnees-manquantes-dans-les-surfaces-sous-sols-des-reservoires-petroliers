function [y] = part2_de_f(X,Xprime,tab_f,n,K)% M = [rand(2,n);zeros(1,n)]
    % f = part1_de_f + part2_de_f 
    % part2_de_f(X) = SEGMA_j bj  x Pi_j(X)
    y = 0 ;
    
    for j = n+1:n+K 
        %fprintf('\n\n j = %d\n',j)
        bj = Xprime(j,:) ;
        %if bj == 0 continue 
        %Xi =  M(:,i) 
        tab_f{:,j-n} ;
        val = tab_f{:,j-n}(X);
        y = y + bj*val;
    end
end