function []= dessiner_horizons(bmin,bmax,step,Cs,f1,offset ,collocations , Ms,Ns)
    % dessine les horizons f(X) = ci  
    % bmin :
    % bmax :
    % step :
    % Cs :
    % f : la fonction implicite f 
    % offset : [xmin ymin zmin] de M (concatenation des elts de Ms)
    % collocations 
    % Ms : cell array (= {})(1,n_horiz) qui contient l'ensemble des horizons 
    % Cs : Matrice(1,n_horiz) qui contient l'Hauteur moyenne du ieme horizon

    clf
    hold on
 
    % Tirage de couleurs (une par surface)
    colors = rand(3,size(Ms,2)) ;
    

    [XX,YY,ZZ] = meshgrid(bmin(1):step(1):bmax(1),bmin(2):step(2):bmax(2),bmin(3):step(3):bmax(3)) ;
    CC = zeros(size(XX)) ;
    for u = 1:size(XX,1)
      for v = 1:size(XX,2)
          for w=1:size(XX,3)
              CC(u,v,w)=f1([XX(u,v,w); YY(u,v,w); ZZ(u,v,w)]) ; % ici f1 = f , c'est ce qu'on a construit 
          end
      end
    end

    % Maillage de la surface f(X) = val
    for i=1:size(Cs,2)
        % ------------- val i
        val = Cs(i) ; %ci
        fv = isosurface(XX,YY,ZZ,CC,val);
        out_file = ['surface_' int2str(i) '.off'] ;
        export_off_tri(out_file, fv, offset, colors(:,i)' ) ; % Blue [RGB] % renvoie une surface a visualiser sur meshlab 
        p=patch(fv) ;

        % Rendu couleur et eclairage
        isonormals(XX,YY,ZZ,CC,p)
        p.EdgeColor = 'none';
        p.FaceColor = colors(:,i)' ; % red [RGB]
    end

    % Post render
    daspect([1 1 1])
    view(3); 
    camlight 
    lighting phong

    % title('3 surfaces [0,1,2] , n = 10 , rand = [0,1]') ; % 3 surfaces [c1,c2,c3]
    % plot3(tmp0(1,:),tmp0(2,:), tmp0(3,:),'xb')
    % plot3(tmp1(1,:),tmp1(2,:), tmp1(3,:),'xr')
    % plot3(tmp2(1,:),tmp2(2,:), tmp2(3,:),'xm')


    tmp_title = [int2str(size(Ms,2)), ' horizons - reconstruction de la fonction potentiel'];
    title(tmp_title) ; % 2 surfaces [c1,c2]
    % Trac? des points des diff?rents horizons
    for i=1:size(Ms,2)
        soustraire_min = repmat(offset,[1,Ns(i)]) ; % soustraire = une matrice (3xn) composee de n colonnes qui est  [xmin ;ymin; zmin] 
        tmp = Ms{i}-soustraire_min ;
        %tmp = Ms{i}-offset ;
        plot3(tmp(1,:),tmp(2,:), tmp(3,:),'x', 'color', colors(:,i)') %tmp1 == tmp2
    end
        %plot3(M(1,N1+1:N),M(2,N1+1:N), M(3,N1+1:N),'xr') %tmp1 == tmp2
    %plot3(collocations(1,1:n1),collocations(2,1:n1), collocations(3,1:n1),'xb') %tmp1 == tmp2
    %plot3(collocations(1,n1+1:n),collocations(2,n1+1:n), collocations(3,n1+1:n),'xr') %tmp1 == tmp2
end
