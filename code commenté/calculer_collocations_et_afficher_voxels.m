function [nombre_collocations,collocations ,voxels_liste ,voxels_index_liste] = calculer_collocations_et_afficher_voxels(voxels,voxels_index,nombre_collocations_var ,collocations_var ,voxels_liste_var,voxels_index_liste_var,num_horizon)

    %calculer_collocations_et_afficher_voxels : calcule les collocations
    %des voxels et transforme la structure arborescente des voxels en liste 
    % retourne :
    %nombre_collocations : le nombre de collocations dans l'horizon de numero num_horizon
    %collocations : les collocations de l'horizon de numero num_horizon
    %voxels_liste : la liste des voxels de l'horizon de numero num_horizon
    %voxels_index_liste : la liste des indices des points voxels de l'horizon de numero num_horizon
    
    %%%les parametres 
    %voxels : les voxels de l'horizon dont le numero est 'num_horizon' (structure arborescente)
    %voxels_index : les indices des points des voxels (structure arborescente)
    %nombre_collocations_var :
    %collocations_var : une matrice qui contiendra les collocations des voxels 
    %voxels_liste_var : un cell array qui contiendra une liste des voxels de l'horizon dont le numero est 'num_horizon'
    %voxels_index_liste_var : un cell array qui contiendra une liste des indices des points des voxels de l'horizon dont le numero est 'num_horizon'
    %num_horizon : le numero de l'horizon auquel appartient les voxels 
    
    voxels_index_liste = voxels_index_liste_var ;
    voxels_liste = voxels_liste_var ;
    nombre_collocations = nombre_collocations_var ;
    collocations = collocations_var ;
    for i = 1: size(voxels,2)
         if iscell(voxels{i}) == 0
             % on a trouve un voxel 
             disp(voxels{i}) ;
             if isequaln(collocations ,[0 0 0 ,num_horizon])
                 % premiere collocation 
                 collocations = calcul_barycentre(voxels{i},num_horizon) ;
             else
                 % Apres la premiere collocation 
                 collocations = [collocations ;calcul_barycentre(voxels{i},num_horizon)] ;
             end
             nombre_collocations = nombre_collocations +1 ;
             % on remplit la liste des voxels 
             voxels_liste{nombre_collocations} = voxels{i} ;
             % on remplit la liste des indices des points voxels 
             voxels_index_liste{nombre_collocations} = voxels_index{i} ;
             
         else
             % on a trouve un cell array pas un voxel , reappeller calculer_collocations_et_afficher_voxels 
             [nombre_collocations,collocations,voxels_liste,voxels_index_liste] = calculer_collocations_et_afficher_voxels(voxels{i},voxels_index{i},nombre_collocations,collocations,voxels_liste,voxels_index_liste,num_horizon) ;
         end  
    end
end