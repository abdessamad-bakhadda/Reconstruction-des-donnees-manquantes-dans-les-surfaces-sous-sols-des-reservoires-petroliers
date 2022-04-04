function [voxels_par_horizon,voxels_index_par_horizon,nombre_voxels_par_horizon] = calculer_voxels_par_horizon(n_horizons ,sorted_points ,voxels_var,voxels_index_var,nombre_voxels_var,M_prime)
    voxels_par_horizon = voxels_var ;
    voxels_index_par_horizon = voxels_index_var ;
    nombre_voxels_par_horizon = nombre_voxels_var ;
    for i =1:n_horizons
        
        RowIdx_horizon_i = find(ismember(sorted_points(:,4),i,'rows')) ;
        if isempty(RowIdx_horizon_i)  == 0 % cellule non vide dans l'horizon iclc
            sorted_points(RowIdx_horizon_i ,:) ;
            RowIdx_in_M_i = find(ismember(M_prime,sorted_points(RowIdx_horizon_i ,:),'rows')) ;
            if isequaln(voxels_par_horizon{i},{}) 
                voxels_index_par_horizon{i} = {RowIdx_in_M_i} ;
                voxels_par_horizon{i} = {sorted_points(RowIdx_horizon_i ,:)} ; 
            else
                voxels_index_par_horizon{i} = {voxels_index_par_horizon{i},RowIdx_in_M_i} ;
                voxels_par_horizon{i} = {voxels_par_horizon{i},sorted_points(RowIdx_horizon_i ,:)} ;      
            end
            nombre_voxels_par_horizon(i) = nombre_voxels_par_horizon(i) +1 ;
            
        %else % cellule vide dans l'horizon i
            
        end
        
        
    end
    
end