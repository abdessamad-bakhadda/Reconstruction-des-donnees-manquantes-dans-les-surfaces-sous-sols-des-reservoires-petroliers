classdef ImplicitConstr
    %IMPLICITCONSTR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        f
        gradf
    end
    
    methods
        function obj = ImplicitConstr(f, gradf)
            obj.f = f ;
            obj.gradf = gradf ;
        end
        
        function [res] = val(obj, X)
            res = obj.f(X) ;
        end
        
        function [resv, resg] = val_grad(obj,X)
            resv = obj.f(X) ;
            resg = obj.gradf(X) ;
        end
    end
    
end

