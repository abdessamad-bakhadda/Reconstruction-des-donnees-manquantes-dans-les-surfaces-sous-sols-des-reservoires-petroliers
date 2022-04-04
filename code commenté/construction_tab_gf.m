function [tab_gf, gK] = construction_tab_gf()
    gK = 6 ;
    gf1 = @(X) [2*X(1,:); 0 ; 0] ;  % X = [x;y;z] X(1,:) == x , X(2,:) == y ,X(3,:) == z 
    gf2 = @(X) [X(2,:) ; X(1,:) ; 0];
    gf3 = @(X) [0 ; 2*X(2,:) ; 0] ;
    gf4 = @(X) [1 ; 0 ; 0] ;
    gf5 = @(X) [0 ; 1 ; 0] ;
    gf6 = @(X) [0 ; 0 ; 0] ;
    tab_gf = {gf1 gf2 gf3 gf4 gf5 gf6} ; %NoNscalar arrays of fuNctioN haNdles are Not allowed; use cell arrays iNstead. tht s why we use {} iNstead of []
end