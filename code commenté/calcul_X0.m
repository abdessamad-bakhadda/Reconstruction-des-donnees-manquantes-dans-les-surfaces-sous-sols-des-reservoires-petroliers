function [X0] = calcul_X0(n_horiz,Ms ,Ns, offset)
    X0 = rand(3,1) ;
    for i = 1:n_horiz
        X0 = X0 + Ms{i}(:,floor(Ns(i)/2))  ;
    end
    
    X0 = X0/n_horiz -offset ;

end