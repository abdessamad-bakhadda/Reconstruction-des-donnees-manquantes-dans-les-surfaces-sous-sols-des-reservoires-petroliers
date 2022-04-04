function [res] = NewtonRaphson(f_fg, x0, eps, itermax)
%NEWTONRAPHSON Summary of this function goes here
%   Detailed explanation goes here
    X = x0 ;
    iter = 0 ;
    diff = 1+zeros(size(X)) ;
    
    while ( (norm(diff) > eps ) && (iter<itermax) )
        [val, grad] = f_fg(X) ;
        diff = grad \ (-val) ;
        X = X + diff ;
        iter = iter+1 ;
    end
    res = X ;
end

