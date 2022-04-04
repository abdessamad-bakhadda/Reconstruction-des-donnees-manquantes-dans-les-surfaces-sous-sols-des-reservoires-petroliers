classdef InterLine < handle
    %INTERLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        line % cell array of vectors - easier to insert
        n % vect3 : direction of the line
        f1 % Implicit fault 1
        f2 % Implicit fault 2
    end
    
    methods
        function obj = InterLine(X1, X2, f1, f2)
            obj.line = {X1,X2} ;
            obj.n = X2-X1 ;
            obj.n = obj.n/norm(obj.n) ;
            obj.f1 = f1 ;
            obj.f2 = f2 ;
        end
        
        % Adds a point on polyline between points i and i+1
        % Point is the lambda / 1-lambda barycenter of both extremities
        % lambda in 0 ... 1
        function [] = add_pt(obj, i, lambda)
            l = size(obj.line,2) ;
            if ((i>=1) && (i < l))
                ntmp = obj.line{i+1}-obj.line{i} ;
                X0 = lambda * obj.line{i} + (1-lambda)*obj.line{i+1} ;
                f3 = ImplicitConstrLine(X0,ntmp) ;
                X_res = converge_pt(obj.f1, obj.f2, f3, X0, 1e-3) ;
                obj.line = {obj.line{1:i},X_res, obj.line{i+1:l}} ;
            else
                ME = MException('MyComponent:InterLine','i : out of line indices') ;
                throw(ME) ;
            end
        end
        
        function [] = add_pt_plane(obj, i, X0, n_plane)
            l = size(obj.line,2) ;
            if ((i>=1) && (i < l))
                f3 = ImplicitConstrLine(X0,n_plane) ;
                X_res = converge_pt(obj.f1, obj.f2, f3, X0, 1e-3) ;
                obj.line = {obj.line{1:i},X_res, obj.line{i+1:l}} ;
            else
                ME = MException('MyComponent:InterLine','i : out of line indices') ;
                throw(ME) ;
            end
        end
        
        function [] = intersect_bb(obj, bb)
            npts = size(obj.line,2) ;
            i = 1 ; 
            % Move along the line until entering bb
            while ((i<=npts) && (~bb.pt_is_in(obj.line{i})))
                i = i+1 ;
            end
            if (i~=1) % The line must be truncated between point i-1 (not in bb) and i (in bb)
                % find the dimension according which the line enters the bb
                % and truncate
                X1 = obj.line{i-1} ;
                X = obj.line{i} ;
                j=1;
                while (j<=3)
                    if ((X1(j) <= bb.bmin(j)) || (X1(j) >= bb.bmax(j)))
                        if (X1(j) <= bb.bmin(j)) 
                            lim = bb.bmin(j) ;
                        end
                        if (X1(j) >= bb.bmax(j))
                            lim = bb.bmax(j) ;
                        end
                        lam = (lim-X1(j))/(X(j)-X1(j)) ;
                        obj.line{i-1} = X1 + lam *(X-X1) ;
                        obj.line = obj_line(i-1:npts) ;
                        j = 4 ;
                    end
                    j = j+1 ;
                end
            end
            % Then move along the line until leaving bb
            while ((i<=npts) && (bb.pt_is_in(obj.line{i})))
                i = i+1 ;
            end
            if (i<npts) % The line must be truncated between point i-1 (in bb) and i (not in bb)
                % find the dimension according which the line enters the bb
                % and truncate
                X1 = obj.line{i-1} ;
                X = obj.line{i} ;
                j=1;
                while (j<=3)
                    if ((X(j) <= bb.bmin(j)) || (X(j) >= bb.bmax(j)))
                        if (X(j) <= bb.bmin(j)) 
                            lim = bb.bmin(j) ;
                        end
                        if (X(j) >= bb.bmax(j))
                            lim = bb.bmax(j) ;
                        end
                        lam = (lim-X1(j))/(X(j)-X1(j)) ;
                        obj.line{i} = X1 + lam *(X-X1) ;
                        obj.line = obj_line(1:i) ;
                        j = 4 ;
                    end
                    j = j+1 ;
                end
            end
            % Update vector n
            npts = size(obj.line,2) ;
            obj.n = obj.line{npts} - obj.line{1} ;
            obj.n = obj.n / norm(obj.n) ;
        end
            
        function [] = sample(obj, depth)
            for i=1:depth
                j = 1 ;
                while (j<size(obj.line,2))
                    obj.add_pt(j, .5) ;
                    j = j+2 ;
                end
            end
        end
        
        function [] = resample(obj,depth)
            npts = size(obj.line,2) ;
            obj.line = {obj.line{1}, obj.line{npts}} ;
            obj.sample(depth) ;
        end
        
        function [] = resample_along_axis(obj,X0, n_plane, step)
            n_plane = n_plane / norm(n_plane); 
            npts = size(obj.line,2) ;
            if (n_plane'*obj.n >= 0) % The line is already oriented in the direction of n_plane
                X1 = obj.line{1} ;
                X2 = obj.line{npts} ;
            else % Invert the line
                X2 = obj.line{1} ;
                X1 = obj.line{npts} ;
                obj.n = -obj.n ;
            end
            obj.line = {X1, X2} ;
            % Planes intersect the line between 2 points: computation of
            % these points
            lamk = @(k) ((X0+k*step*n_plane-X1)'*n_plane) / (obj.n'*n_plane) ;
            k1 = ceil ((X1-X0)'*n_plane)/step ;
            k2 = floor ((X2-X0)'*n_plane)/step ;
            for k = k1:k2
                Xk = X1 + lamk(k) * obj.n ;
                i = k-k1+1 ; % indice of the new point along the line
                obj.add_pt_plane(i,Xk, n_plane) ;
            end
        end
        
        function [] = disp(obj)
            for i=1:size(obj.line,2)-1
                tmp = [obj.line{i},obj.line{i+1}] ;
                plot3(tmp(1,:), tmp(2,:), tmp(3,:), 'g')
                %plot3(tmp(1,:), tmp(2,:), tmp(3,:), '.g')
            end
        end
    end
    
end

