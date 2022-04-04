function [tree,voxels_par_horizon,nombre_voxels_par_horizon,voxels_index_par_horizon] = build_kdtree_size_leafnode_moins_sv(points, depth ,k,seuil_voxel,voxels_var,nombre_voxels_var,voxels_index_var,M_prime,n_horizons)
    % une fonction recursive qui contsruit pour chaque horizon des voxels dont le nombre des points 
    % est plus petit que seuil voxel (le nombre maximum de points qu'on peut avoir dans un voxel) 
    % retourne :
    % tree : l'arbre obtenu par le kdtree effectue 
    % voxels_par_horizon : les voxels de chaque horizon 
    % nombre_voxels_par_horizon : le nombre de voxels pour chaque horizon 
    % voxels_index_par_horizon :les indices des points des voxels de chaque horizon 
    
    %%%les parametres 
    % points : les points de donnees , sera modifie a chauqe appel de la fonction  
    % depth : la profondeur de l'arbre ,on commence par 0 
    % k : le nombre de dimensions (2 pour xy et 3 pour xyz) ,pour lesquelles on effectue la division
    % seuil_voxel : le nombre maximum de points qu'on peut avoir dans un voxel 
    
    % voxels_var : un cell array qui contient lui meme n_horizon(le nombre
    % d'horizons) cell array qui contiendront les voxels de chaque horizon
    % ,on commencent par des cells array vides {}
    
    % nombre_voxels_var : un cell array qui contiendra le nombre de voxels
    % pour chaque horizon 
    
    % voxels_index_var :un cell array qui contiendra le nombre de voxels
    % pour chaque horizon
    
    % M_prime : les points de donnees ,restent inchangeable a chaque appel de la
    % fonction ,servent pour savoir l'indice d'un point de donnees dans la
    % matrice initiale 
    
    % n_horizons : le nombre d'horizons 
    
    
    %le nombre de points de donnees 
    n = size(points,1) ;
    
    % on choisit d'effectuer un kd tree selon l'axe qui a la plus grande
    % largeur 
    [vec_min , vec_max] = vec_min_max(points') ;
    axis = calcul_dimension_max(vec_min , vec_max, k) ; %%% C'est cette fonction ou il faut justement decouper seulement selon x,y
    
    % on choisit d'effectuer un kd tree selon l'axe des x puis y puis z 
    %axis = mod(depth,k)+1 ; 
    
    % on trie les points de donnees selon un axe donnee
    sorted_points = sortrows(points,axis) ;% renvoyer les indices des points tries .
    
    sz_sorted_points = size(sorted_points,1)  ;
    sv = seuil_voxel ;
    
    
    voxels_par_horizon = voxels_var  ;
    voxels_index_par_horizon = voxels_index_var ;
    nombre_voxels_par_horizon = nombre_voxels_var ;
    
    % on compare le nombre de points de donnees au seuil voxel pour voir
    % s'ils constituent un voxel ou pas encore 
    if(sz_sorted_points >= sv)
        % on calcule l'indice de la mediane 
        median_index = ceil(n/2) ;
        
        % on effectue la subdivision pour les points de gauche s'ils en
        % restent ,sinon on obtient un voxel vide 
        if median_index > 1 
            [left,voxels_par_horizon,nombre_voxels_par_horizon,voxels_index_par_horizon] = build_kdtree_size_leafnode_moins_sv(sorted_points(1:median_index-1,:),depth + 1,k,seuil_voxel,voxels_par_horizon,nombre_voxels_par_horizon,voxels_index_par_horizon,M_prime,n_horizons) ;
            vl = voxels_par_horizon ;
        else 
            left = struct() ;

        end

        % on effectue la subdivision pour les points de droite s'ils en
        % restent ,sinon on obtient un voxel vide 
        if median_index >= n
            right = struct() ;
        else
            [right,voxels_par_horizon,nombre_voxels_par_horizon,voxels_index_par_horizon] = build_kdtree_size_leafnode_moins_sv(sorted_points(median_index + 1:n,:), depth + 1,k,seuil_voxel,voxels_par_horizon,nombre_voxels_par_horizon,voxels_index_par_horizon,M_prime,n_horizons) ;
            vr = voxels_par_horizon ;
        end
        
        % on construit un arbre constitue du point de la mediane , sous
        % arbre gauche et sous arbre droite et cela de maniere recursive 
        root = sorted_points(median_index,:) ;
        tree = struct ('point' ,sorted_points(median_index,:) , 'left' ,left ,'right',right) ;    
    else
        % ici on a obtenu un voxel mixte (les points appartient aux differents horizons) , on cherche
        % a les classifier par horizon 
        [voxels_par_horizon,voxels_index_par_horizon,nombre_voxels_par_horizon] = calculer_voxels_par_horizon(n_horizons ,sorted_points,voxels_par_horizon,voxels_index_par_horizon,nombre_voxels_par_horizon,M_prime) ;
        
        % on ajoute  le voxel feuille  a l'arbre 
        tree = struct ('point' ,sorted_points, 'left' ,struct() ,'right',struct()) ; 
    end
    
             
end


    
    