function [y] = phi(r)
    %thin plate spline
    if r == 0 y = 0 ;
    else y = r^2 * log(r);
end
