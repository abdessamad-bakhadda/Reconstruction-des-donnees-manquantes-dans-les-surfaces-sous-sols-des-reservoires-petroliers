function [  ] = export_off_tri( file, fv, offset, col ) % file = nom fichier de sortie  , fv , offset = [xmin,ymin,zmin] , col = color 
%EXPORT_OFF_TRI Exports a triangular mesh to a .off file
%   [  ] = export_off_tri( file, fv, offset, col )
%
% INPUT : 
% file : out file name
% fv : face-vertex data structure containing the mesh
% offset : offset on vertices coordinates
% col : color attributed to faces

    fid = fopen(file,'w') ;
    vertices = fv.vertices ; % n x 3 matrix
    faces = fv.faces ; % m x 3 matrix
    n = size(vertices, 1) ;
    m = size(faces, 1) ;
    
    fprintf(fid, 'OFF\n') ;
    fprintf(fid, '%d %d %d\n', n, m, 0) ;
    for i = 1:n
        fprintf(fid, '%g %g %g\n', vertices(i,1)+offset(1), vertices(i,2)+offset(2), vertices(i,3)+offset(3)) ;
    end
    for i = 1:m
        fprintf(fid, '3 %d %d %d %d %d %d\n', faces(i,1)-1, faces(i,2)-1, faces(i,3)-1, col(1)*255, col(2)*255, col(3)*255) ;
    end
    fclose(fid) ;
end

