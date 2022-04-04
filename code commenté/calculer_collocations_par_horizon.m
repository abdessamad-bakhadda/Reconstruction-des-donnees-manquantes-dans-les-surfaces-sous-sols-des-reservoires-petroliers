function [nombre_collocations_par_horizon , collocations_par_horizon , voxels_liste_par_horizon ,voxels_index_liste_par_horizon] = calculer_collocations_par_horizon(n_horizons,voxels_par_horizon,voxels_index_par_horizon,nombre_voxels_par_horizon)

    %calculer_collocations_par_horizon : calcule le barycentre de chaque
    %voxel de chaque horizon
    %retourne :
    %nombre_collocations_par_horizon : le nombre de collocations de chaque horizon
    %collocations_par_horizon: les collocations de chaque horizon
    %voxels_liste_par_horizon : la liste des voxels de chaque horizon
    %voxels_index_liste_par_horizon : la liste des indices des points des voxels de chaque horizon
    
  
    %%%les parametres 
    %n_horizons : le nombre d'horizons 
 
    %voxels_par_horizon : un cell array contenant n_horizons cell array qui
    %contiennent les voxels de chaque horizon (structure arborescente)
    
    %voxels_index_par_horizon : un cell array contenant n_horizons cell
    %array qui contiennent les indices des points de chaque voxel de chaque horizon (structure arborescente)
    
    %nombre_voxels_par_horizon : une liste qui contient le nombre de voxels dans chaque horizon
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %une liste qui contienda les collocations de chaque horizon
    collocations_par_horizon = cell(1,n_horizons) ;
    
    %une liste qui contienda le nombre de collocations de chaque horizon
    %(facultatif car le nombre de collocations par horizons est le nombre
    %de voxels par horizons car une colllocation est un barycentre d'un
    %voxel )
    nombre_collocations_par_horizon = zeros(1,n_horizons) ;
    
    % une liste qui contiendra les voxels de chaque horizon dans une liste
    % qu lieu de la structure arborescente precedente 
    voxels_liste_par_horizon = cell(1,n_horizons) ;
    
    % une liste qui contiendra les indices des points de chaue voxel de chaque horizon dans une liste
    % qu lieu de la structure arborescente precedente 
    voxels_index_liste_par_horizon = cell(1,n_horizons) ;
    for i = 1:n_horizons
        % on prepare les variables pour appeler calculer_collocations_et_afficher_voxels qui transforme les
        % stucrtures arborescentes voxels_par_horizon{i} et voxels_index_par_horizon{i} 
        % en deux listes voxels_liste_par_horizon{i} ,voxels_index_liste_par_horizon{i} 

        voxels_liste_var_i = cell(1,nombre_voxels_par_horizon(i)) ;
        voxels_index_liste_var_i = cell(1,nombre_voxels_par_horizon(i)) ;
        nombre_collocations_var_i = 0 ;
        collocations_var_i = [0 0 0 i] ;
        num_horizon = i ;
        [nombre_collocations_par_horizon(i),collocations_par_horizon{i} ,voxels_liste_par_horizon{i} ,voxels_index_liste_par_horizon{i}] = calculer_collocations_et_afficher_voxels(voxels_par_horizon{i},voxels_index_par_horizon{i},nombre_collocations_var_i ,collocations_var_i ,voxels_liste_var_i,voxels_index_liste_var_i ,num_horizon) ;
        
    end
end