function [tab_f, K] = construction_tab_f()
    K = 6 ;
    f1 = @(X) X(1,:)^2 ;  % X = [x;y;z] X(1,:) == x , X(2,:) == y ,X(3,:) == z 
    f2 = @(X) X(1,:)*X(2,:) ;
    f3 = @(X) X(2,:)^2 ;
    f4 = @(X) X(1,:) ;
    f5 = @(X) X(2,:) ;
    f6 = @(X) 1 ;
    tab_f = {f1 f2 f3 f4 f5 f6} ; %NoNscalar arrays of fuNctioN haNdles are Not allowed; use cell arrays iNstead. tht s why we use {} iNstead of []
end