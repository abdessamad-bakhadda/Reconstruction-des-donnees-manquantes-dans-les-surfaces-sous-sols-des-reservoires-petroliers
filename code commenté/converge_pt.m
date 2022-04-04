function [ X_res ] = converge_pt( f1, f2, f3, X0, eps )
%CONVERGE_PT Converge (Newton-Raphson) to the zero of f = (f1, f2, f3) :
%               R^3-> R^3 closest to X0
    f_fg = @(X) val_grad(f1, f2, f3, X) ;
    X_res = NewtonRaphson(f_fg, X0, eps, 10000) ;
end

function [val, grad] = val_grad(f1, f2, f3, X)
    [resv1, resg1]  = f1.val_grad(X) ;
    [resv2, resg2]  = f2.val_grad(X) ;
    [resv3, resg3]  = f3.val_grad(X) ;
    val  = [resv1; resv2; resv3] ;
    grad = [resg1' ; resg2'; resg3'] ;
end

