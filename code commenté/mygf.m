function [ gf_X ] = mygf( X, Xprime, tab_gf, n, K, M )
%MYF Summary of this function goes here
%   Detailed explanation goes here

    res1 = part1_de_gf(X,M,Xprime,n);
    res2 = part2_de_gf(X,Xprime,tab_gf,n,K);
    gf_X = res1 + res2 ;
    % maintenant il ne reste qu a affiche le trace de f(Xi) = 0 ,f(Xi)= 1,f(Xi) = 2 % pas d'accenents en matlab ca quitte le prog pr moi 
    %voir avec le prof quoi corriger modifier ajouter supprimer 
end