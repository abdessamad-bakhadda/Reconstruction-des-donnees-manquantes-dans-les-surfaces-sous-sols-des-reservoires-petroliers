clear
clf
hold on
mypath1 = '/Users/abdessamad/Dropbox/Abdessamad_fct_potentiel/donnees_m_et_xyz/brent_dulin/Brent_Dulin_2/' ; 
%mypath1 = '/Users/bacalexandra/Dropbox/G-Mod/projets/Abdessamad_fct_potentiel/donnees_m_et_xyz/Brent_Dulin/Brent_Dulin_2' ; 
liste1 = {'Simplified_2000_Top_Brent.m', 'Simplified_2000_Top_Dulin.m'} ;% 'Simplified_2000_Top_Brent.m', 'Simplified_2000_Top_Dulin.m'} ;

%mypath2 = '/Users/abdessamad/Dropbox/Abdessamad_fct_potentiel/donnees_m_et_xyz/synthetic_bac/' ;
%liste2 = {'sub1_low.m', 'sub1_mid.m', 'sub1_top.m'} ;

mypath3 = '/Users/abdessamad/Dropbox/Abdessamad_fct_potentiel/donnees_m_et_xyz/Geosiris_mai/VOLVE_Segmentation/' ;
liste3 = {'Horizon_1.m', 'Horizon_2.m', 'Horizon_3.m', 'Horizon_4.m'} ;

mypath4 = '/Users/abdessamad/Dropbox/Abdessamad_fct_potentiel/donnees_m_et_xyz/Geosiris_mai/THURROCK_xyz/Matlab' ;
%liste4 = {'toit_TAB.m', 'toit_CK.m', 'toit_HEAD.m', 'toit_HWH.m', 'toit_LC.m', 'toit_LMBE.m', 'toit_MGR.m', 'toit_QHND.m', 'toit_QXQD.m', 'toit_RDTU.m'} ;
liste4 = {'toit_TAB.m', 'toit_LMBE.m', 'toit_HWH.m',  'toit_QXQD.m'} ;
%liste4 = {'toit_TAB.m', 'toit_LMBE.m'} ;

% Pas de discr?tisation en x,y,z (pour sous-?chantillonnage) 
% Nx = 20 ;
% Ny = 20 ;
% Nz = 10 ;
% vec_N = [Nx ;Ny ;Nz] ;

% Chargement de l'ensemble des horizons
Ms = charger_matrices(mypath3, liste3) ;
n_horiz = size(Ms,2)

% Initialisation des tailles / hauteur moyenne par horizon / 
Ns = zeros(1,n_horiz) ; % Nombre de points par horizon
Cs = zeros(1,n_horiz) ; % Hauteur moyenne du ieme horizon
flags = [] ; % 
for i=1:n_horiz
    Ns(i) = size(Ms{i},2) ;
    %Cs(i) = sum(Ms{i}(3,:))/Ns(i) ;
    Cs(i) = i ;
end


% Creation de la matrice de l'ensemble des points / flags (numero horizon) de
% chacun des point
M = [] 
for i=1:n_horiz
    M = [M,Ms{i}] ;
    flags = [flags, zeros(1,Ns(i))+i] ; % le flag des points de l'horizon i est ... i
end
N = size(M,2);

[vec_min,vec_max] = vec_min_max(M) ;
offset = vec_min ;

soustraire_min = repmat(vec_min,[1,N]) ; % soustraire = une matrice (3xn) composee de n colonnes qui est  [xmin ;ymin; zmin] 
M = M - soustraire_min ;
%M = M - vec_min ; %ne marche pas bien pour moi dans mon pc
[vec_min,vec_max] = vec_min_max(M) ;
xmin = vec_min(1) ;
ymin = vec_min(2) ;
zmin = vec_min(3) ;

xmax = vec_max(1) ;
ymax = vec_max(2) ;
zmax = vec_max(3) ;

%%% implementation de l'algo qui nous permet de choisir des points bien repartis dans les surfaces 

%%% la grille reguliere 
%[grille ,flag_grille,nbr_pts_vox_grille] = algorithme_repartition(M,N,flags,vec_max,vec_N) ;
%[collocations ,n] = constuction_collocations(grille,flag_grille,nbr_pts_vox_grille, vec_N) ; % !! ici vous prenez que le 1 et le 2

%%% kdtree
depth = 0 ;
k2 = 2 ;% kd tree selon x et y
seuil_voxel = 40 ;
nombre_voxels_var = zeros(1,n_horiz) ;
[voxels_var ,voxels_index_var] = creer_cell_vide(n_horiz) ;
M_flags = [M ; flags] ;
[tree,voxels_par_horizon,nombre_voxels_par_horizon,voxels_index_par_horizon] = build_kdtree_size_leafnode_moins_sv(M_flags',depth ,k2,seuil_voxel,voxels_var,nombre_voxels_var,voxels_index_var,M_flags',n_horiz)
[nombre_collocations_par_horizon , collocations_par_horizon , voxels_liste_par_horizon ,voxels_index_liste_par_horizon] = calculer_collocations_par_horizon(n_horiz,voxels_par_horizon,voxels_index_par_horizon,nombre_voxels_par_horizon)

export_voxels_collocations_xyz_color(n_horiz,collocations_par_horizon, voxels_liste_par_horizon,nombre_voxels_par_horizon,offset') ; %% separer , exporter ,colorier les voxels 
%export_collocations_xyz_color(n_horiz,collocations_par_horizon,nombre_collocations_par_horizon,offset') ;
[collocations ,nombre_collocations] = coller_collocations(n_horiz ,collocations_par_horizon, nombre_collocations_par_horizon) ;

%collocations = coller_collocations(n_horiz ,collocations_par_horizon,nombre_collocations_par_horizon) ;
n = nombre_collocations % nombre de voxels = nombre de collocations 
%export_collocations_xyz_color(collocations,nombre_collocations,offset) ;
%%% fin implementation de l'algo

% resolution du sys lineaire , on retrouve le vecteurs alpha et beta 
[tab_f,K] = construction_tab_f() ;
A = construction_A(N,n,K,M,collocations,tab_f) ;
C = construction_C(Cs,Ns) ;
X = A\(C) ;

%on construit f1
f1 = @(X_var) myf(X_var, X, tab_f, n, K, collocations) ;

%on construit gf1
[tab_gf1, gK] = construction_tab_gf() ;
gf1 = @(X_var) mygf(X_var, X, tab_gf1, n, K, collocations) ;



% on calcule les extremites de la boite englobante et le pas avec lequel on decoupe nos axes x,y,z
[bmin,bmax,step] = calculate_bmin_bmax_step(xmax,ymax,zmax ,xmin,ymin,zmin) ;

%on calcule la boite englobante qui contiendra tous les horizons 
bb = BB(bmin',bmax') ; 
bb.scale([1 ; 1 ; 6]) ; %[1 ;1 ;4] pour brent-dulin et volve % on elargit notre boite englobante en z pour pouvoir afficher Thurrock
    

% on calcule le vecteur normal a la coupe
vec_n = [rand(2,1);0] ;
vec_n = vec_n / norm(vec_n) ;

% on determine X0 
X0 = calcul_X0(n_horiz,Ms,Ns,offset) ;
 
% on calcule moins_d 
moins_d = myf_coupe(X0,vec_n) ;

% f_plan_i est une structure qui contient un point X0_i de l'horizon i et la normale a la coupe 
f_plan = ImplicitConstrLine(X0, vec_n) ;
        
%on calcule de la ligne d'intersection entre la coupe(f_plan) ,la boite englobante(bb) et chaque horizon(f_horizon_i)
%intersection_coupe_horizons(n_horiz ,f1,gf1,Cs,offset,bb,f_plan) 

% on dessiner les plans de coupes 
%dessiner_coupes(n_horiz,bmin,bmax,step,offset,moins_d,vec_n)

% on dessine les horizons
dessiner_horizons(bmin,bmax,step,Cs,f1,offset ,collocations , Ms,Ns) ;




