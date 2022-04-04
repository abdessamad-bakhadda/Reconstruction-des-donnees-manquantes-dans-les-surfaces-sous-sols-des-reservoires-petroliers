function []= export_voxels_collocations_xyz_color(n_horiz,collocations_par_horizon, voxels_liste_par_horizon,nombre_voxels_par_horizon,offset)
    % export_voxels_xyz_color : exporte les voxels et les collocations de
    % chaque horizon en fichiers xyzrgb en donnant une couleur differente a
    % chaque voxel et une seule couleur (blanche) pour toutes les collocations 
   
    %%%les parametres 
    %n_horiz : le nombre d'horizons 
    %collocations_par_horizon : les collocations de chaque horizon 
    %voxels_liste_par_horizon : la liste des voxels de chaque horizon 
    %nombre_voxels_par_horizon : le nombre de voxels de chaque horizon 
    %offset : le vecteur minimum qu'on a soustrait des points de donnees au debut 
    
    
    %colloc_color = [255 255 255] ;
    for l = 1: n_horiz
        nombre_voxels_l = nombre_voxels_par_horizon(l) ;
        colors_l = floor(hsv(3*nombre_voxels_l +1) * 255) ; %(nombre_voxels ,3)
        out_file1 = ['voxels_' int2str(l) '.xyz'] ;
        fid1 = fopen(out_file1, 'w'); 
        i_col = floor(rand(1,nombre_voxels_l)*3*nombre_voxels_l)+1 ;
        voxels_liste_l = voxels_liste_par_horizon{l} ;
        
        out_file2 = ['collocations_' int2str(l) '.xyz'] ;
        fid2 = fopen(out_file2, 'w'); 
        collocations_l = collocations_par_horizon{l} ;
        
        for i = 1:nombre_voxels_l
            k = i_col(i) ;
            color_i = colors_l(k,:) ; %(1,3)
            voxel_i = voxels_liste_l{i} ;
            m = size(voxel_i,1) ;
            voxel_i = voxel_i(:,1:3) + repmat(offset,[m,1]) ;
            color = zeros(m,3) ;%(m,3)
            for j = 1:m
                fprintf(fid1,'%f %f %f %f %f %f\n',[voxel_i(j,:) ,color_i]) ;
                color(j,:) = color_i ;
            end
            [voxel_i ,color] ;
            %cprintf('color',colors(i,:)); % comment colorer  
            
            collocations_l_i = collocations_l(i,1:3) + offset ;
            fprintf(fid2,'%f %f %f %f %f %f\n',[collocations_l_i ,0 0 0]) ;
        end
    end
    fclose(fid1) ;
    %fclose(fid2) ;
    
end


