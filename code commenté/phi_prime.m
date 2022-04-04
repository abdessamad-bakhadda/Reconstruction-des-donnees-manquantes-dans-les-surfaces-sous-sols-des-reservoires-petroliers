function [y] = phi_prime(r)
    % derivee de thin plate spline
    if (r == 0) 
        y = 0 ;
    else
        y = r * (2*log(r) + 1);
    end
end