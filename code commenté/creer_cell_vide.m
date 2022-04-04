function [voxels_var ,voxels_index_var] = creer_cell_vide(n_horizons)
    % creer_cell_vide : cree deux cells array contenant 'n_horizons' cell
    % array vides , un pour contenir les voxels de chaque horizon (les
    % points) et l'autre pour contenir les indices des points des voxels de
    % chaque horizon 
    
    % n_horizons : le nombre d'horiozons 
    voxels_var = cell(1,n_horizons) ;
    voxels_index_var = cell(1,n_horizons) ;
    for i =1:n_horizons 
        voxels_var{i} = {} ;
        voxels_index_var = {} ;
    end
end