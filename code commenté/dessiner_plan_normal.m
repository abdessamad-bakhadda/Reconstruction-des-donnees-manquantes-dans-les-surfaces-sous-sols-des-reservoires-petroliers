function []= dessiner_plan_normal(point,normal,bmin,bmax,step)
    clf
    hold on
    %# a plane is a*x+b*y+c*z+d=0
    %# [a,b,c] is the normal. Thus, we have to calculate
    %# d and we're set
    d = -point*normal'; %'# dot product for less typing

    %# create x,y
    %[xx,yy]=ndgrid(1:10,1:10) ;
    [xx,yy] = meshgrid(bmin(1):step(1):bmax(1),bmin(2):step(2):bmax(2)) ;
    %# calculate corresponding z
    z = (-normal(3)*xx - normal(1)*yy - d)/normal(2);
    xlabel('z') ;
    ylabel('x') ;
    zlabel('y') ;

   
    surf(xx,yy,z)
    
end