classdef ImplicitConstrBB < ImplicitConstr
    %IMPLICITCONSTRBB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = ImplicitConstrBB(dim, const)
            f = @(X) X(dim) - const ;
            f_g = @(X) canonique(dim) ;
            obj = obj@ImplicitConstr(f, f_g) ;
        end
    end
    
end

function [v] = canonique(dim)
    v = zeros(3,1) ;
    v(dim) = 1 ;
end