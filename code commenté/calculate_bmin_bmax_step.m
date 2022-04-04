function [bmin,bmax,step] = calculate_bmin_bmax_step(xmax,ymax,zmax ,xmin,ymin,zmin)
     % Boite englobante de representation de la surface
    % how to make them work automatically 

    bmin = [xmin,ymin,zmin];  % faut changer ici z dans bmin pour voir surface 
    bmax = [xmax,ymax,zmax];  % faut changer ici x ,y dans bmax pour voir surface 

    % Elargissement de la boite en z
    bmoy = (bmax+bmin)/2 ;
    radius = (bmax-bmin)/2 ;
    scale = [1,1,2] ;
    bmax = bmoy+radius .* scale ;
    bmin = bmoy-radius .* scale ;

    % Pas de discr?tisation
    step_x = (xmax-xmin)/30 ;
    step_y = (ymax-ymin)/30 ;
    step_z = (zmax-zmin)/30 ;
    step = [step_x, step_y, step_z];  % ce qui attarde un peu l'affichage du graphe 
    
end