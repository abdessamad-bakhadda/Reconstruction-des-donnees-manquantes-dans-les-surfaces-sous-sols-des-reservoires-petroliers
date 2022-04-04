function axis = calcul_dimension_max(vec_min , vec_max, k)
    % vec_min et vec_max en colonnes
    
    %distx = vec_max(1)- vec_min(1) ;
    %disty = vec_max(2)- vec_min(2) ;
    %distz = vec_max(3)- vec_min(3) ;
    %dist = [distx ,disty ,distz] ;
    dist = vec_max(1:k)' - vec_min(1:k)' ;
    dist_dim_max = max(dist(1,:)) ;
    
    for i=1:k
        if (dist(i) == dist_dim_max)
            axis = i ;
        end
    end 
end