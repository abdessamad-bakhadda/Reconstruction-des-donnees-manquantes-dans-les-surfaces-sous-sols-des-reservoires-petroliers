function [collocations ,n] = constuction_collocations(grille ,flag_grille ,nbr_pts_vox_grille,vec_N)
    % ici vous n'avez pas change le flag pour i , vous travaillez encore
    % avec 1 et 2 et pourtant flag_grille peut contenir 3 et 4 comme pour
    % volve et thurrock , parler avec prof
    
    n1 = 1 ; % nbr de collections avec z = c1 = 0 
    M_c1 = [] ;
    
    n2 = 1 ; % nbr de collections avec z = c2
    M_c2 = [] ;
    
    Nx = vec_N(1) ;
    Ny = vec_N(2) ;
    Nz = vec_N(3) ;
    for i = 1:Nx 
       for j = 1:Ny
           for k = 1:Nz
               val = grille {i,j,k} ;
               flag = flag_grille {i,j,k} ;
               nbr_dans_vox = nbr_pts_vox_grille{i,j,k} ;
               if isempty(val) == 0
                   if  flag == 1 
                       M_c1(:,n1) = val/nbr_dans_vox ;%on prend le barycentre des points existants dans le meme voxel
                       n1 = n1 + 1 ;  
                   elseif flag == 2 
                       M_c2(:,n2) = val/nbr_dans_vox ;%on prend le barycentre des points existants dans le meme voxel
                       n2 = n2 + 1 ;  
                   end

               end
           end
       end
    end

    collocations = [M_c1 , M_c2] ;
    szcolloc = size(collocations) ; % 3 x (n1+n2)
    n =  size(collocations,2)% n_pourcentage 
end
