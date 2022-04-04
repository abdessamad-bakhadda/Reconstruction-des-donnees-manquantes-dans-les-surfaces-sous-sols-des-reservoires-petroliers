classdef RegGrid < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        minbb
        maxbb
        stepbb
        n
        m
        p
        voxels_labs
        vertices_values
    end
    
    methods
        function obj = RegGrid(bb, steps)
            obj.minbb = bb.bmin ;
            obj.maxbb = bb.bmax ;
            obj.stepbb = (bb.bmax-bb.bmin)./(steps-1) ; 
            obj.n = steps(1) ;
            obj.m = steps(2) ;
            obj.p = steps(3) ;
            obj.voxels_labs = cell(obj.n-1,obj.m-1,obj.p-1) ;
            obj.vertices_values = zeros(obj.n, obj.m, obj.p) ; % le voxel (i,j,k) a pour indices de sommets (i, i+1)x(j,j+1)x(j, k+1)
        end
        
        % Returns size of the grid along dimension i
        function size = dim(obj, i)
            if (i == 1)
                size = obj.n ;
            else if (i==2)
                    size = obj.m ;
                else if (i==3)
                        size = obj.p ;
                    else
                        ME = MException('MyComponent:RegGrid','i : out of existing dimensions') ;
                        throw(ME) ;
                    end
                end
            end
        end
        
        % Returns coordinates of vertex (i,j,k)
        function X = Xc(obj, i,j,k)
            X = obj.minbb + obj.stepbb .* [i ;j; k] ;
        end
        
        function [] = fill_vert_scalar_field(obj, f)
            for i = 1:obj.n
                for j = 1:obj.m
                    for k = 1:obj.p
                        X = obj.Xc(i,j,k) ;
                        obj.vertices_values(i,j,k) = f(X) ;
                    end
                end
            end
        end
        
        % Determines if voxel (i,j,k) is intersected (from vertices_values
        % previously computed)
        function [hit] = intersected(obj, i,j,k)
            vals = [] ;
            prod = 1 ;
            % Test voxel (i,j,k)
            for u = i:i+1
                for v = j:j+1
                    for w = k:k+1
                        vals = [vals,obj.vertices_values(u,v,w)] ;
                        prod = prod * obj.vertices_values(u,v,w) ;
                    end
                end
            end
            if (prod == 0)
                hit = true ; % la surface coupe l'un des sommets exactement ... peu probable, mais ... 
            else
                same_sign = true ;
                for u = 2:8
                    same_sign = same_sign && (sign(vals(1)) == sign(vals(u))) ;
                end
                if (same_sign)
                    hit = false ; % tous les sommets ont le m?me signe
                else
                    hit = true ;
                end
            end
        end
        
        % Search for label l in labels of voxel i,j,k
        function [res] = label_in(obj, i,j,k, l)
            res = 0 ;
            labs = obj.voxels_labs{i,j,k} ;
            for u=1:size(labs,2)
                if (labs{u} == l)
                    res = u ;
                end
            end
        end
        
        % Add label l to voxel i,j,k
        function [] = add_voxel_label(obj, i,j,k, l)
            if (obj.label_in(i,j,k, l) == 0) % label absent
                len = size(obj.voxels_labs{i,j,k},2) ;
                obj.voxels_labs{i,j,k}{len+1} = l ; % ajout du label
            end
        end
        
        % Performs labellin for label l given a scalar field already
        % computed
        function [n] = labelling(obj, l) % fill_vert_scalar_field must have been called before
            for i=1:obj.n-1
                for j=1:obj.m-1
                    for k=1:obj.p-1
                        if (obj.intersected(i,j,k))
                            obj.add_voxel_label(i, j, k, l) ;
                        end
                    end
                end
            end
        end
        
        % Compute intersections (voxels having more than one label)
        function [voxels] = intersections(obj) % labelling should have been called with at least two surfaces
            voxels = [] ;
            for i=1:obj.n-1
                for j=1:obj.m-1
                    for k=1:obj.p-1
                        if (size(obj.voxels_labs{i,j,k},2) > 1) % more than one label
                            voxels = [voxels,[i;j;k]] ;
                        end
                    end
                end
            end
        end
        
        % Given a set of intersection voxels, find extremal voxels
        % (touching the bounding box)
        function [ voxels_extr, dim, pos ] = find_extrema( obj, voxels )
            bot = min(voxels, [], 2) ;
            top = max(voxels, [], 2) ;
            
            % Compute the extremal voxels sharing one coordinate with bot
            % and top respectively
            [v1, dim1, pos1] = obj.find_extr_from_min_max(bot, voxels) ;
            [v2, dim2, pos2] = obj.find_extr_from_min_max(top, voxels) ;
            % Compute the matrix of distances between these voxels
            n1 = size(v1,2) ;
            n2 = size(v2,2) ;
            M_dist = zeros(n1, n2);
            for i=1:n1
                k1 = v1(i) ; % Index of first voxel
                % Get corresponding point (on the BB)
                p1 = obj.get_extr_point(voxels(:,k1), dim1(i), pos1(i)) ;
                for j=1:n2
                    k2 = v2(j) ; % Index of second voxel
                    % Get corresponding point (on the BB)
                    p2 = obj.get_extr_point(voxels(:,k2), dim2(j), pos2(j)) ;
                    M_dist(i,j) = norm(p2-p1) ;
                end
            end
            
            % Compute the maximal distance
            imax = 1 ;
            jmax = 1 ;
            dmax = M_dist(1,1) ;
            for i=1:n1
                for j=1:n2
                    if (M_dist(i,j) > dmax)
                        imax = i ;
                        jmax = j ;
                        dmax = M_dist(i,j) ;
                    end
                end
            end
            
            voxels_extr = [voxels(:,v1(imax)),voxels(:,v2(jmax))] ;
            dim = [dim1(imax),dim2(jmax)] ;
            pos = [pos1(imax),pos2(jmax)] ;
        end
        
        % From an extremal voxel, the dimension along which it touches the
        % BB and the position of this intersection (0 or 1), returns a
        % representative point
        function [ X ] = get_extr_point (obj, v, dim, pos)
            X = [.5; .5; .5] ;
            X(dim) = pos ;
            X = (X+(v-1)) .* obj.stepbb + obj.minbb ;
        end
    end
    
    methods (Access = private)
        % Given a v_in = min or max of voxels, find the extremal voxels "giving rise
        % to v_in" (ie. sharing an indice with v_in and touching the bounding box) 
        % Returns :
        % -> v_res : list of indices of extremal voxels
        % -> dim : list of corresponding dimensions
        % -> pos : list of corresponding positions
        function [v_res, dim, pos] = find_extr_from_min_max(obj, v_in, voxels)
            i = 1 ;
            nv = size(voxels,2) ;
            v_res = [] ;
            dim = [] ;
            pos = [] ;
            for i=1:3 % test each dimension
                tmp = (voxels(i, :) == v_in(i)) ;
                for j=1:nv
                    if (tmp(j)==1) % voxel j shares one indice with v_in
                        v = voxels(:,j) ;
                        [dim_v, pos_v]=obj.is_extremal(v) ;
                        n_extr = size(dim_v,2) ;
                        if ( n_extr > 0) % voxel is extremal and "gives" the minimum -> extremal voxel
                            v_res = [v_res , zeros(1,n_extr)+j] ; % add the indice of v to v_res (n_extr times)
                            dim = [dim, dim_v] ;
                            pos = [pos, pos_v] ;
                        end
                    end
                end
            end
        end   
        
        % Finds if the voxels v touches the BB (along which dimensions) and
        % how (0 for vertex i, 1 for vertex i+1)
        % dim and pos may contain several occurrences (the extremal voxel
        % can "touch" the BB along several dimensions)
        function [dim, pos] = is_extremal(obj, v)
            dim = [] ;
            pos = [] ;
            for i=1:3
                if (v(i)==1)
                    dim = [dim,i] ;
                    pos = [pos,0] ;
                else if (v(i)==obj.dim(i)-1)
                        dim = [dim ,i] ;
                        pos = [pos,1]; 
                    end
                end
            end
        end
    end
end

