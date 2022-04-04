function [vec_min , vec_max] = vec_min_max(M)
    vec_min = [ min(M(1,:)) ; min(M(2,:)) ; min(M(3,:))] ;
    vec_max = [ max(M(1,:)) ; max(M(2,:)) ; max(M(3,:))] ;
end