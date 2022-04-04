function [barycentre] = calcul_barycentre(matrice,num_horizon)
    % calcul_barycentre : calcul le barycentre d'un ensemble de points
    % donnees 
    % retourne :
    % barycentre : le barycentre des points de donnees de matrice
    
    %%%les parametres 
    %matrice : les points de donnees dont on veut calculer le barycentre 
    %num_horizon : le numero de l'horizon auquel appartient les points de donnees 
    
    barycentre = [sum(matrice(:,1)) , sum(matrice(:,2)) , sum(matrice(:,3)) ]/size(matrice,1) ;
    barycentre = [barycentre ,num_horizon] ;
    
end