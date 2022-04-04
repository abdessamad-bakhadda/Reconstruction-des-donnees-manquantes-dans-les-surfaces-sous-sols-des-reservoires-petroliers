function []= dessiner_coupes(n_horiz,bmin,bmax,step,offset,moins_d,vec_n)
    % dessine les coupes myf_coupe(X) = di  
    % bmin :
    % bmax :
    % step :
    % vec_n : [d1 d2 ... dn_horiz] 
    % offset : [xmin ymin zmin] de M (concatenation des elts de Ms)
    % Ds :[-d1 -d2 .. -dn_horiz]
    % vec_n : le vecteur  normal au plan de la coupe 

    clf
    hold on
 
    % Tirage de couleurs (une par surface)
    colors = rand(3,n_horiz) ;

    [XX,YY,ZZ] = meshgrid(bmin(1):step(1):bmax(1),bmin(2):step(2):bmax(2),bmin(3):step(3):bmax(3)) ;
    CC = zeros(size(XX)) ;
    for u = 1:size(XX,1)
      for v = 1:size(XX,2)
          for w=1:size(XX,3)
              CC(u,v,w)=myf_coupe([XX(u,v,w); YY(u,v,w); ZZ(u,v,w)],vec_n) ; % ici  myf_coupe 
          end
      end
    end

    % Maillage de la surface f(X) = val
    
    % ------------- val i
    val = moins_d ; % -di
    fv = isosurface(XX,YY,ZZ,CC,val);
    out_file = ['coupe.off'] ;
    export_off_tri(out_file, fv, offset, colors(:,1)' ) ; % Blue [RGB] % renvoie une surface a visualiser sur meshlab 
    p=patch(fv) ;

    % Rendu couleur et eclairage
    isonormals(XX,YY,ZZ,CC,p)
    p.EdgeColor = 'none';
    p.FaceColor = colors(:,1)' ; % red [RGB]
    

    % Post render
    daspect([1 1 1])
    view(3); 
    camlight 
    lighting phong

end
