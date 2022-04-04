function [grille ,flag_grille ,nbr_pts_vox_grille] = algorithme_repartition(M,N,flags,point_max,vec_N)
    % implementation de l'algo qui nous permet de choisir des points bien repartis dans les deux surfaces 
    
    %met Nx ,Ny tt en haut du code 
    %Nx = 4 ;
    %Ny = 10 ;
    %Nz = 2 ;

    % N = [Nx;Ny;Nz]
    % point_max = [xmax;ymax;zmax] 
    delta = point_max ./ vec_N ;

    %N_vecteur = ceil(point_max ./delta) % [Nx ;Ny ;Nz] = ceil/floor(max ./delta)
    Nx = vec_N(1) ;
    Ny = vec_N(2) ;
    Nz = vec_N(3) ;
    grille = cell(Nx ,Ny, Nz); % un tableau de 3 dimensions (x,y,z)
    flag_grille = cell(Nx ,Ny, Nz); % un tableau de 3 dimensions (x,y,z)
    nbr_pts_vox_grille = cell(Nx ,Ny, Nz); % un tableau de 3 dimensions (x,y,z)

    % flag dans M pour voir si point 
    for i = 1:N
        X = M(:,i) ; % i eme point = i eme colonne
        flag = flags(i) ;
        % cellule dans laquelle X se trouve
        %ser = X ./ delta % probleme de c1 = 0 
        vox = zeros(3,1) ;
        quo = X ./ delta ; % or floor
        % probleme out of index with floor and ceil , that s why i did this 
        for indice = 1 :3 
            if (quo(indice) == floor(quo(indice))) % coordinate is exactly between 2 cells
                vox(indice) = quo(indice) ;
                if (vox(indice) == 0)
                    vox(indice) = 1 ;
                end
            else % coordinate is inside a cell
                vox(indice) = ceil(quo(indice)) ;
            end
        end   
        if isempty (grille {vox(1),vox(2),vox(3)}) % probleme de c1 = 0 
            grille{vox(1),vox(2),vox(3)} = X ;
            flag_grille{vox(1),vox(2),vox(3)} = flag ;
            nbr_pts_vox_grille{vox(1),vox(2),vox(3)} = 1 ;
        else
            grille{vox(1),vox(2),vox(3)} = grille{vox(1),vox(2),vox(3)} + X ;
            nbr_pts_vox_grille{vox(1),vox(2),vox(3)} = nbr_pts_vox_grille{vox(1),vox(2),vox(3)} +1 ; 
        end
    end
end
