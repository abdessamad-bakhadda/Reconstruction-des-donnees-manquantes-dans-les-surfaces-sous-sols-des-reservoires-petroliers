classdef ImplicitConstrLine < ImplicitConstr
    %IMPLICITCONSTRLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = ImplicitConstrLine(X0, n)
            f = @(X) n'*(X-X0) ;
            f_g = @(X) n ;
            obj = obj@ImplicitConstr(f, f_g) ;
        end
    end
    
end

