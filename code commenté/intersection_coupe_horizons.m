function [] = intersection_coupe_horizons(n_horiz ,f1,gf1,Cs,offset,bb,f_plan)
    % calcule l'intersection entre le plan de la coupe ,l'horizon et la boite englobante 
    % n_horiz : le nombre d'horizons
    % f1 : la fonction implicite f 
    % gf1 : le gradient de la fonction implicite f 
    % Ms : cell array (= {})(1,n_horiz) qui contient l'ensemble des horizons 
    % Cs : Matrice(1,n_horiz) qui contient l'Hauteur moyenne du ieme horizon
    % Ns : Matrice(1,n_horiz) qui contient le Nombre de points par horizon
    % offset : [xmin ymin zmin] de M (concatenation des elts de Ms)
    % bb : boite englobante 
    % f_plan : le plan de la coupe 

    
    % eqaution du plan ax+by+cz+d = 0 
    % Ds contient les di correspondante a l' ieme horizon 
    %Ds = zeros(1,n_horiz) ;
    for i = 1:n_horiz
        % f2_i pour le ieme horizon 
        f2_i = @(X_var) (f1(X_var) - Cs(i)) ;

        % f_horizon_i est une structure qui contient la fonction implicite f2_i et son gradient gf2_i = gf1
        f_horizon_i = ImplicitConstr(f2_i,gf1) ;

        % on determine X0_i del'horizon i  
        %X0_i = Ms{i}(:,floor(Ns(i)/2)) - offset ;

        % on calcule di correspondante a l' ieme horizon
        %Ds(i) = myf_coupe(X0_i,vec_n) ;

        % f_plan_i est une structure qui contient un point X0_i de l'horizon i et la normale a la coupe 
        %f_plan_i = ImplicitConstrLine(X0_i, vec_n) ; 

        %%% Intersection horizon - plan / boite englobante (bb)
        % on calcule la ligne d'intersection horizon_i - plan - bb
        line   = intersect_faults(f_horizon_i, f_plan, bb, 4, 300. ) ;

        line.line ; % contient les vertices de la ligne
        % on construit les vertexes de la ligne
        vertices = [] ;
        for j=1:length(line.line)
            vertices = [vertices,line.line{j}+offset] ;
        end
        %sz_vertices = size(vertices)

        % on construit les segments de la ligne
        segs = [1 :size(vertices,2)-1]' ;
        segs = [segs ,segs+1] ;
        %sz_segs = size(segs)

        % exporter la ligne vers meshlab
        out_file = ['line_' int2str(i) '.ply'] ;
        export_ply_segs(out_file , vertices', segs , [1,2,3]) ; %colors(i,:) ne marche pas pour moi ,essayer boucle avec [1 2 3]

        %afficher la ligne
        line.disp() ;
    end
end