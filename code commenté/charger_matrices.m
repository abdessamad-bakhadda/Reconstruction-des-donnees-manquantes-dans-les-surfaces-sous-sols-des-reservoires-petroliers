function [Ms] = charger_matrices(mypath, liste)
    n_horiz = size(liste, 2) ;
    for i=1:n_horiz
        % load each horizon from the list of files
        ff = liste{i} ;
        disp(ff) ;
        mypath_full = fullfile(mypath, ff) ;
        run(mypath_full) ; % M
        Ms{i} = M' ;
    end
end 

% function [M_Brent_1000 ,M_Dulin_1000,M_Brent_2000 ,M_Dulin_2000] = charger_matrices()
%     run('Simplified_2000_Top_Brent.m')
%     M_Brent_2000 = M' ;
%     run('Simplified_2000_Top_Dulin.m')
%     M_Dulin_2000 = M' ;
%     
%     run('Simplified_1000_Top_Brent.m')
%     M_Brent_1000 = M' ;
% 
%     run('Simplified_1000_Top_Dulin.m')
%     M_Dulin_1000 = M' ;  
% end 
