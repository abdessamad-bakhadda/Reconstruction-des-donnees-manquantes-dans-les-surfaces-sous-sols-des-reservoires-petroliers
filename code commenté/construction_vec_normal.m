function [vec_n] = construction_vec_normal(vec_direc1 ,vec_direc2)
    %construction du vecteur normal
    vec_direc1 ;
    vec_direc2 ;
    vec_n_x= vec_direc1(2)*vec_direc2(3)- vec_direc1(3)*vec_direc2(2) ;
    vec_n_y= -vec_direc1(1)*vec_direc2(3) + vec_direc1(3)*vec_direc2(1) ;
    vec_n_z= vec_direc1(1)*vec_direc2(2)- vec_direc1(2)*vec_direc2(1) ;
    vec_n = [vec_n_x vec_n_y vec_n_z] ;
end

% ou tout simplement , utiliser cross(a,b) = produit vectoriel entre a et b