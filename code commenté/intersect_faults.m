function [line] = intersect_faults( f1, f2, bb, depth, vox_size )
%INTERSECT_FAULTS Summary of this function goes here
%   Detailed explanation goes here

    % 200 : taille des voxels selon x, y, z
    res = bb.split(vox_size) ; % computes exact resolution to get an even number of voxels
    
    % Compute discrete (grid) intersection 
    % returns the set of intersection voxels
    fun1 = @(X) f1.val(X) ;
    fun2 = @(X) f2.val(X) ;
    [voxels, grid] = intersect_faults_vox(fun1, fun2, bb, res) ;

    if (size(voxels,2)>=2)
        % Get voxels "touching" the bounding box
        [extr, dim, pos] = grid.find_extrema(voxels) ;
        % Extract one minimal / maximal voxel (used to init the intersection
        % line)
        X1 = grid.get_extr_point(extr(:,1),dim(1), pos(1)) ;
        X2 = grid.get_extr_point(extr(:,2),dim(2), pos(2)) ;
        tmp = [X1,X2] ;
        plot3(tmp(1,:), tmp(2,:), tmp(3,:), 'm')  ;

        % Converge lower point towards the intersection 
        % equation f3 : the point must remain on the same side of the bb
        f3 = ImplicitConstrBB(dim(1), X1(dim(1))) ;
        X_res1 = converge_pt( f1, f2, f3, X1, 1e-3 ) ;
        % Converge upper point towards intersection
        f3 = ImplicitConstrBB(dim(2), X2(dim(2))) ;
        X_res2 = converge_pt( f1, f2, f3, X2, 1e-3 ) ;

        % Create intersection line (initially contains 2 points)
        line = InterLine(X_res1, X_res2, f1, f2) ;

        % Add 2^depth points by dichotomy (fastest convergence)
        line.sample(depth) ;
    else
        ME = MException('MyComponent:intersect_faults','no intersection in the bounding box') ;
        throw(ME) ;
    end
end

