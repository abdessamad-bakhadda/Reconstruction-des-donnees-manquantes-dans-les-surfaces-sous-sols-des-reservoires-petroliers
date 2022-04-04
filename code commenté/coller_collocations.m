function [collocations ,nombre_collocations] = coller_collocations(n_horiz ,collocations_par_horizon, nombre_collocations_par_horizon) 
    % coller_collocations fait l'union de toutes les collocations des
    % differents horizons pour pouvoir reconstruire les surfaces
    % retourne 
    % collocations : matrice(3,nombre_collocations) contient l'union des collocations de tous les horizons 
    % nombre_collocations : le nombre total des collocations 
    
    %%%les parametres 
    % n_horiz : le nombre d'horizons
    % collocations_par_horizon : les collocations de chaque horizon
    % nombre_collocations_par_horizon : le nombre de collocations de chaque horizon
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nombre_collocations = 0 ;
    for i = 1:n_horiz
        
        %collocations de l'horizon i 
        collocations_i = collocations_par_horizon{i} ;
        if nombre_collocations == 0
            collocations = collocations_i(:,1:3)' ; % j'elimine le flag en prenant les colonnes 1:3
        else
            collocations =   [collocations , collocations_i(:,1:3)'] ; % j'elimine le flag en prenant les colonnes 1:3
        end
        
        nombre_collocations = nombre_collocations + nombre_collocations_par_horizon(i) ;
        
    end
end