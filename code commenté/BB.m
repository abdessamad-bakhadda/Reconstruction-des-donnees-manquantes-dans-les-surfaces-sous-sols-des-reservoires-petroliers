classdef BB < handle % handle pour prendre BB par reference pas par valeur 
    %BB Bounding boxes
    
    properties
        bmin
        bmax
        cube_vert = [0, 0, 0;1, 0, 0; 0, 1, 0; 1, 1, 0; 0, 0, 1;1, 0, 1; 0, 1, 1; 1, 1, 1]' ;
        cube_edges = [0,1 ; 1,3 ; 0,2 ; 2,3 ; 0,4 ; 1,5 ; 3,7 ; 2,6 ; 4,5 ; 5,7 ; 4,6 ; 6,7]+1 ;
    end
    
    methods
        function obj = BB(bmin, bmax)
            obj.bmin = bmin ;
            obj.bmax = bmax ;
        end
        
        function [res] = center(obj)
            res = (obj.bmax+obj.bmin)/2 ;
        end
        
        function [res] = split(obj, size)
            res = ceil((obj.bmax-obj.bmin)/size) ;
        end
        
        function [res] = diag(obj)
            res = obj.bmax - obj.bmin ;
        end
        
        function [] = scale(obj, s)
            c = obj.center() ;
            r = obj.diag()/2 ;
            obj.bmin = c - s.*r ;
            obj.bmax = c + s.*r ;
        end
        
        function [] = scale_dir(obj, i, s)
            c = obj.center() ;
            r = obj.diag()/2 ;
            obj.bmin(i) = c(i) - s*r(i) ;
            obj.bmax(i) = c(i) + s*r(i) ;
        end
        
        function [res] = pt_is_in(obj, p)
            res = true ;
            for i=1:3
                res = res & (p(i) >= obj.bmin(i)) & (p(i) <= obj.bmax(i)) ;
            end
        end
        
        function [] = disp(obj)
            vertices = (obj.cube_vert .* (obj.bmax-obj.bmin)) + obj.bmin ;
            for i=1:size(obj.cube_edges,1)
                tmp = [vertices(:,obj.cube_edges(i,1)),vertices(:,obj.cube_edges(i,2))] ;
                plot3(tmp(1,:), tmp(2,:), tmp(3,:), 'b') ;
            end
        end
    end
    
    methods (Static)
        function [bb] = bb_from_pt_set(M)
            % M must be 3xN
            bb = BB(min(M, [], 1)', max(M, [], 1)') ;
        end
        
        function [bb] = union(bb1, bb2)
            bb = BB(min(bb1.bmin, bb2.bmin), max(bb1.bmax, bb2.bmax)) ;
        end
        
        function [bb] = inter(bb1, bb2)
            bb = BB(max(bb1.bmin, bb2.bmin), min(bb1.bmax, bb2.bmax)) ;
        end
    end
    
end

