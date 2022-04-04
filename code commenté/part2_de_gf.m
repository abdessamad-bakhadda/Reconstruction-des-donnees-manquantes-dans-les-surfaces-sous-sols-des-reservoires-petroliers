function [y] = part2_de_gf(X,Xprime,tab_gf,n,K)% M = [rand(2,n);zeros(1,n)]
    % gf = part1_de_gf + part2_de_gf 
    % part2_de_gf(X) = SEGMA_j bj  x gPi_j(X)
    y = zeros(3,1) ;
    
    for j = n+1:n+K 
        %fprintf('\n\n j = %d\n',j)
        bj = Xprime(j,:) ;
        %if bj == 0 continue 
        %Xi =  M(:,i) 
        tab_gf{:,j-n} ;
        val = tab_gf{:,j-n}(X);
        y = y + bj*val;
    end
end