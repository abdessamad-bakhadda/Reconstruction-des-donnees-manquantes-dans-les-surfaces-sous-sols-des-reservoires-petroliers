function [voxels, grid] = intersect_faults_vox(fun1, fun2, bb, step_grid)
%INTERSECT_FAULTS Computes the intersection of 2 fault surfaces in the box bb
%   
% step_grid : size of voxels for regular grid (300 recommended)
%
    % compute exact voxels size (near step_grid) to get an int number of voxels 
    %res = bb.split(step_grid) ; 
    grid = RegGrid(bb, step_grid) ;
    
    % labelling for f1
    grid.fill_vert_scalar_field(fun1) ;
    grid.labelling(1) ;
    
    % labelling for f2
    grid.fill_vert_scalar_field(fun2) ;
    grid.labelling(2) ;
    
    % compute intersections
    voxels = grid.intersections() ;
end