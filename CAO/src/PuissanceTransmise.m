function P_diode  = PuissanceTransmise(thetalc,phi,distance,imageFiltre,flag,distanceSurelevement, rhoD, rhoS, sigma)
%INPUT: -thetalc = angle laser-normale du code (rad), vecteur
%       -phi = inclinaison du code-barres verticalement(degré)
%       -distance = distance code-photodiode (cm)
%       -imageFiltre = OUTPUT de filtreGaussien.m (vecteur avec valeurs
%        variant entre 0 et 1
%       -flag = 5(lambertien et spéculaire), 4(lambertien), 3 (aluminium),
%               2 (aluminium brossé), 1 (brillant) ou 0 (mate)
%       -distanceSurelevement = distance verticale entre la photodiode et
%       le laser, à la fente (cm).
%       -rhoD = le coefficient de réflexion diffus (modèle lambertien)
%       -rhoS = le coefficient de réflexion spéculaire (modèle
%       lambertien+spéculaire)
%       -sigma = La largeur de la bande spéculaire pour 1 sigma, en degrés 
%       
%OUTPUT: P_diode_t = puissance instantannée en Watt
if nargin < 7
rhoD = 0;
end

if nargin < 8
rhoS = 0;
end

if nargin < 9
sigma = 1;
end



AIREPHOTODIODE = 7.5; % millimètres carrés

FACTEURCORRECTIONUNITE = 1;% 1000;
MULTIPLESPEC = 1; % mettre à 1 pour activer le speculaire
thetalc=thetalc';
%%détermination du waist de la composante spéculaire
%distance en mètre
d=[0.02 0.1 0.2];
%largeur de la bande spéculaire pour les distances mentionnées précédemment
alu_s=[51.4735    1.4709    0.2399];
alub_s=[26.0326    0.4478    0.0560];
brillant_s=[41.3215    1.4389    0.1599];
%distances possibles
dis=0:0.001:0.22;
angle_alu_s_i=interp1(d,alu_s,dis,'linear','extrap');
angle_alub_s_i=interp1(d,alub_s,dis,'linear','extrap');
angle_brillant_s_i=interp1(d,brillant_s,dis,'linear','extrap');
angle_alu=angle_alu_s_i(distance*10);
angle_alub=angle_alub_s_i(distance*10);
angle_brillant=angle_brillant_s_i(distance*10);
phiSurelevement=atand(distanceSurelevement/distance);
coefSaturation=1359;
imageFiltre=imageFiltre';
theta = abs((thetalc*180)/pi);
phit=ones(length(theta),1);
phit=phit*(phi+phiSurelevement);
if flag == 5
    % modele lambertien + speculaire simple
    % on recalcule le vecteur du laser et photodiode par rapport à la surface
    vecteurDeVecteursLaser = [-sin(thetalc), zeros(size(thetalc, 1),1), cos(thetalc)];
    vecteurDeVecteursPhotodiode = vecteurDeVecteursLaser;
    
    matriceRotationX = [1 0         0; ...
                        0 cosd(phi) -sind(phi); ...
                        0 sind(phi) cosd(phi)];
                    
    % on effectue la rotation des vecteurs du laser
    vecteurDeVecteursLaser = (matriceRotationX * vecteurDeVecteursLaser')';
                    
    % on calcule le vecteur du laser réfléchi
    vecteurDeVecteursLaserReflechi = [-vecteurDeVecteursLaser(:, 1), -vecteurDeVecteursLaser(:, 2), vecteurDeVecteursLaser(:, 3)];
    
    % on calcule l'angle entre le laser réfléchi et la photodiode
    % c'est à la base la formule avec le produit scalaire entre deux
    % vecteurs
    
    normesVecteursLaserReflechi = sum(vecteurDeVecteursLaserReflechi.^2, 2);
    normesVecteursPhotodiode = sum(vecteurDeVecteursPhotodiode.^2, 2);
    produitScalaire = sum(vecteurDeVecteursPhotodiode .* vecteurDeVecteursLaserReflechi, 2);
    
    %angle en degré entre les deux vecteurs
    angleEmissionRecepteur = acosd(produitScalaire./(normesVecteursLaserReflechi.*normesVecteursPhotodiode));
    
    
    
    PourcentageDeCalotte = AIREPHOTODIODE / (2 * pi * (distance*10)^2);
    %omega=AIREPHOTODIODE/(distance*10)^2;
    spec = 0;
    specAInclureDansBRDF = rhoS * PourcentageDeCalotte * min(normpdf(angleEmissionRecepteur, 0, sigma), 1);
    BRDF = rhoD * PourcentageDeCalotte;
    BRDF = FACTEURCORRECTIONUNITE * (BRDF + specAInclureDansBRDF); % on l'ajoute car ce modèle est additif par rapport aux autres.
elseif flag == 4
    % modele purement lambertien
    PourcentageDeCalotte = AIREPHOTODIODE / (2 * pi * (distance*10)^2);
    %omega=AIREPHOTODIODE/(distance*10+520)^2;
    spec = 0;
    BRDF = FACTEURCORRECTIONUNITE * rhoD * PourcentageDeCalotte;
elseif flag == 3
    omega=AIREPHOTODIODE/(distance*10+520)^2;
    BRDF=(906)*((cosd(theta)).^2)*((cosd(phit)).^2)*omega; 
    spec=coefSaturation.*normpdf((sqrt(((theta).^2)+(phit).^2)),0,angle_alu)/normpdf(0,0,angle_alu);
elseif flag == 2
    omega=AIREPHOTODIODE/(distance*10+520)^2;
    BRDF=(906)*((cosd(theta)).^2).*((cosd(phit)).^2)*omega; 
    spec=coefSaturation.*normpdf((sqrt((theta).^2+(phit).^2)),0,angle_alub)/normpdf(0,0,angle_alub);
elseif flag == 1
    omega=AIREPHOTODIODE/(distance*10+520)^2;
    BRDF=(906)*((cosd(theta)).^2).*((cosd(phit)).^2)*omega; 
    spec=coefSaturation.*normpdf((sqrt((theta).^2+(phit).^2)),0,angle_brillant)/normpdf(0,0,angle_brillant);
elseif flag == 0
    omega=AIREPHOTODIODE/(distance*10+510)^2;
    BRDF=(899.8662)*((cosd(theta)).^4).*((cosd(phit)).^3)*omega;
else
    omega=AIREPHOTODIODE/(distance*10+510)^2;
    BRDF=(899.8662)*((cosd(theta)).^4).*((cosd(phit)).^3)*omega;
end
P_diode=imageFiltre.*max(BRDF,spec * MULTIPLESPEC);