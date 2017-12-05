function [ imageFiltre ] = ImageFiltre(Z,image,P, waistMinimal, distanceFocale)
% IMAGEFILTRE
%
% function [ imageFiltre ] = ImageFiltre(z,image,P)
%
% Fonction générant le code-barre filtré 
%
% Entrées : 
%         z = distance code-laser [cm]
%         m = dimension matrice [nxn]
%         image = image à filtrer
%         p = puissance du laser [W]
%         waistMinimal = le waist minimal du laser [um]
%         distanceFocale = la distance focale par rapport au pt. de
%         référence [cm]
% Sortie : 
%         imageFiltre = vecteur avec valeurs variant entre 0 et 1

distanceLaserPtFocal = distanceFocale+35;

% Définition des différentes constantes en mètre
Z=Z/100; 
RAYLEIGHRANGE=8.93044/100;
ZWAIST= distanceLaserPtFocal/100; % distance entre le point focal et le laser
SHORTWAIST=0.0000479656; 
LONGWAIST=0.00006; 
waistRatio = LONGWAIST/SHORTWAIST;
SHORTWAIST = waistMinimal/100/2; %nous voulons le rayon donc divisé par 2
LONGWAIST = waistRatio * SHORTWAIST;

% Paramètres de l'ellipse
A = SHORTWAIST*sqrt(1+((Z-ZWAIST)/RAYLEIGHRANGE)^2); 
B = LONGWAIST*sqrt(1+((Z-ZWAIST)/RAYLEIGHRANGE)^2); 

PASM = 30*1e-6;
Z = (Z-distanceLaserPtFocal)/100; 

% La portée de Rayleigh en x et en y
ZOX=(pi*B^2)/(652*10^-9);
ZOY=(pi*A^2)/(652*10^-9);

% La largeur du faisceau en fonction des paramètres
WX=B*sqrt(1+(Z^2)/(ZOX^2));
WY=A*sqrt(1+(Z^2)/(ZOY^2));

% Taille de la matrice contenant le faisceau
L=7;

% On se positionne au centre de la matrice LxL 
X = (1:L)*PASM;
X = X-mean(X);
X = repmat(X,L,1)';

Y = (1:L)*PASM;
Y = Y-mean(Y);
Y = repmat(Y,L,1);

% Calcul de l'intensité du faisceau
I=(WX/B)*(WY/A)*exp(-2*(X.^2*(1/B^2)+Y.^2*(1/A^2)));

% Normalisation de la matrice
I_tot=I-min(min(I));
% Multiplication avec la puissance voulue
I_tot=((I_tot/sum(sum(I_tot)))*P);

% Filtre gaussien sur l'image
AAA = imfilter(image,I_tot,'replicate');

M = size(image,1);
M = M/2; M = round(M);
imageFiltre = AAA(M,:); %vecteur
end

