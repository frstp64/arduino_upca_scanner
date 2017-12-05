function thetalc   = angleLaserCode(distance,carteNormalesx,carteNormalesy,carteNormalesz,codebarre)
% ANGLELASERCODE
% 
% function [ thetalc ] = angleLaserCode(distance,carteNormales,Image)
%     
% Fonction donnant l'angle entre le laser et le code. On doit donner en
% entré la distance miroir-code, l'image à traiter ainsi que la carte de
% normale de l'image. Un vecteur d'angle entre la normale d'un point et 
% l'angle d'incidence du faisceau est donné à chaque point.
% 
% Entrés:
% distance = distance miroir-code [cm]
% carteNormalesx = les normales de l'image à traiter
% carteNormalesy = les normales de l'image à traiter
% Image = image à traiter
% Amplitude = angle de la tête de lecture maximale [rad]
% 
% Sorties:
% thetalc = angle entre le faisceau et la normale  [rad]

% Identification des variables et regroupement des cartes normales dans 
% une matrice
carteNormales = cat(3, carteNormalesx, carteNormalesy, carteNormalesz);
vecteurNormales = carteNormales(round(size(carteNormales, 1)/2), :, :);
pas_m = 30e-6;
distance = distance/100;
largeurPixels = size(codebarre, 2);
thetalc = zeros(1, largeurPixels);
positionCentrale = round(size(codebarre)/2);

% Définition des normales du laser
% les valeurs à gauche du centre sont negatives et vice-versa
vecteurPositions = (1:largeurPixels) - positionCentrale(2);
%angle pour chacune des positions sur le vecteur
thetaPixels = atan(vecteurPositions * pas_m/distance);

%préallocations
normalesLaser = nan(1, size(codebarre, 2), 3);
normalesLaser(:, :, 2) = zeros(1, largeurPixels, 1);

% on calcules les normales du laser selon le référentiel du code-barres.
normalesLaser(:, :, 1) = -sin(thetaPixels);
normalesLaser(:, :, 3) = cos(thetaPixels);

% Calcul de l'angle entre le laser et la carte normale par un produit
% scalaire
produitDot = sum(normalesLaser .* vecteurNormales, 3);
% c'est la formule de pythagore içi
normeNormalesLaser = sum(normalesLaser.^2, 3).^(0.5);
normeVecteurNormales = sum(vecteurNormales.^2, 3).^(0.5);

cosAngle = produitDot./(normeNormalesLaser .* normeVecteurNormales); 

% finalement on calcule la distance
thetalc = acos(cosAngle);
end
