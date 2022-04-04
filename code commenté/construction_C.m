function [C] = construction_C(Cs, Ns)
    C = [] ;
    for i=1:size(Ns,2)
        C = [C, zeros(1,Ns(i))+Cs(i)] ;
    end
    C = C';
end