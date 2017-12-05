function [dataImg, carteNormalesFinale] = genBarCodeTestData(fundamentalCodeImg, zoomValue, xShift, xRotation, yRotation, zRotation, yCurvature, bgImg, noiseLevel)
% GENBARCODETESTDATA - Génère une image en tons de gris de code-barres
%
% Entrées:
%  fundamentalCodeImg - L'image de code-barres à insérer
%  zoomValue - La quantité de zoom, de 0.8 à 2
%  xShift - Le shift horizontal en mm par rapport au centre
%  xRotation - La rotation par rapport à l'axe des X au centre du code-barres
%  yRotation - La rotation par rapport à l'axe des Y au centre du code-barres
%  zRotation - La rotation par rapport à l'axe des Z au centre du code-barres
%  yCurvature - La courbature du code totale en degrés, de 0 à 20 degrés
%  bgimg - L'image en arrière-plan, sera redimensionnée, mettre 1 pour blanc
%  noiseLevel - Le niveau de bruit, environ 0.01 est environ correct
%
% Sorties:
%  dataImg - L'image de test
%  carteNormalesFinale - La carte des normales pour chaque pixel de l'image
%
%
% Attention, les paramètres ne sont pas tous contraints!
% Ordre des opérations: zoom, courbure+rotationY, rotation Z, déplacement
% Pour comprendre la rotation, utiliser la convention de la main droite


% La taille par pixel est de 30 micromètres
pixelSize = 30;
fondLoinCorrige = 4;

% La taille verticale et horizontale en micromètres. 
verticalSize = 20 * 1000; % 2 cm
horizontalSize = 150 * 1000; % 15 cm
xShiftPix = 1000 * xShift/pixelSize;

% Taille de l'image finale
imgSize = [ceil(verticalSize/pixelSize) ceil(horizontalSize/pixelSize)];

% La taille en pixels d'une barre.
realZoom = 330 * zoomValue / 30;

% 1) mise à l'échelle par redimensionnement supérieur 
codeBarreImg = imresize(fundamentalCodeImg, realZoom, 'nearest');

% 2) courbature
debutCurvature = -yCurvature/2 + yRotation;
finCurvature = yCurvature/2 + yRotation;

tailleCodeBarre = size(codeBarreImg);

% vecteur des angles pour chaque pixel
vecteurAngles = linspace(debutCurvature, finCurvature, tailleCodeBarre(2));
vecteurCos = reshape(cos(vecteurAngles), [1 1 numel(vecteurAngles)]);
vecteurSin = reshape(sin(vecteurAngles), [1 1 numel(vecteurAngles)]);
vecteurMatriceRotationY = [vecteurCos,  zeros(1, 1, numel(vecteurAngles)), vecteurSin;
                           zeros(1, 1, numel(vecteurAngles)), ones(1, 1, numel(vecteurAngles))         , zeros(1, 1, numel(vecteurAngles));
			   -vecteurSin, zeros(1, 1, numel(vecteurAngles)), vecteurCos];
vecteurMatriceRotationY = permute(vecteurMatriceRotationY, [2 3 1]);

vecteurRotationX = repmat(vecteurMatriceRotationY(1, :, :), [tailleCodeBarre(1) 1 1]);
vecteurRotationY = repmat(vecteurMatriceRotationY(2, :, :), [tailleCodeBarre(1) 1 1]);
vecteurRotationZ = repmat(vecteurMatriceRotationY(3, :, :), [tailleCodeBarre(1) 1 1]);

carteNormalesZeros = zeros(tailleCodeBarre(1), tailleCodeBarre(2));
carteNormalesOnes = ones(tailleCodeBarre(1), tailleCodeBarre(2));
carteNormalesX = repmat(carteNormalesZeros, [1 1 3]);
carteNormalesY = repmat(carteNormalesZeros, [1 1 3]);
carteNormalesZ = repmat(carteNormalesOnes, [1 1 3]);

carteNormalesDeX = carteNormalesX .* vecteurRotationX;
carteNormalesDeY = carteNormalesY .* vecteurRotationY;
carteNormalesDeZ = carteNormalesZ .* vecteurRotationZ;
carteNormales = carteNormalesDeX + carteNormalesDeY + carteNormalesDeZ;


% ratio restant pour chaque pixel
vecteurRatio = cos(vecteurAngles);

% somme cumulative, donne la nouvelle position de chaque vecteur
vecteurPosCum = round(cumsum(vecteurRatio));

% maintenant il faut enlever les éléments de la matrice qui ont le même index
[~, BonnesColonnes, ~] = unique(vecteurPosCum);
codeBarreCourbe = codeBarreImg(:, BonnesColonnes);
carteNormales = carteNormales(:, BonnesColonnes, :);

% l'autre rotation est effectuée
codeBarreOriente = ~imrotate(~codeBarreCourbe, zRotation/pi*180);
carteNormales = imrotate(carteNormales, zRotation/pi*180);

tailleRecCode = size(codeBarreOriente);

% on effectue la deuxième rotation, autour de l'axe des z, pour la carte de normales
carteNormalesX = repmat(carteNormales(:, :, 1), [1 1 3]);
carteNormalesY = repmat(carteNormales(:, :, 2), [1 1 3]);
carteNormalesZ = repmat(carteNormales(:, :, 3), [1 1 3]);

MatriceRotationZ = [cos(zRotation), -sin(zRotation), 0;
                    sin(zRotation), cos(zRotation), 0;
		    0,              0,              1];
vecteurRotationX = repmat(reshape(MatriceRotationZ(:, 1), [1 1 3]), [tailleRecCode(1) tailleRecCode(2) 1]);
vecteurRotationY = repmat(reshape(MatriceRotationZ(:, 2), [1 1 3]), [tailleRecCode(1) tailleRecCode(2) 1]);
vecteurRotationZ = repmat(reshape(MatriceRotationZ(:, 3), [1 1 3]), [tailleRecCode(1) tailleRecCode(2) 1]);

carteNormales = carteNormalesX .* vecteurRotationX + ...
                carteNormalesY .* vecteurRotationY + ...
		carteNormalesZ .* vecteurRotationZ;

% on effectue la troisième rotation, autour de l'axe des x, pour la carte de normales
carteNormalesX = repmat(carteNormales(:, :, 1), [1 1 3]);
carteNormalesY = repmat(carteNormales(:, :, 2), [1 1 3]);
carteNormalesZ = repmat(carteNormales(:, :, 3), [1 1 3]);

MatriceRotationX = [1            ,  0,                            0;
                    0,              cos(xRotation), -sin(xRotation);
		    0,              sin(xRotation), cos(xRotation)];
vecteurRotationX = repmat(reshape(MatriceRotationX(:, 1), [1 1 3]), [tailleRecCode(1) tailleRecCode(2) 1]);
vecteurRotationY = repmat(reshape(MatriceRotationX(:, 2), [1 1 3]), [tailleRecCode(1) tailleRecCode(2) 1]);
vecteurRotationZ = repmat(reshape(MatriceRotationX(:, 3), [1 1 3]), [tailleRecCode(1) tailleRecCode(2) 1]);

carteNormales = carteNormalesX .* vecteurRotationX + ...
                carteNormalesY .* vecteurRotationY + ...
		carteNormalesZ .* vecteurRotationZ;


% on génère l'image d'arrière-plan
dataImg = imresize(bgImg, imgSize);
dataImg = dataImg/fondLoinCorrige;

carteNormalesFinale = zeros(size(dataImg, 1), size(dataImg, 2), 3);

% on détermine la position centre de l'image
centreOrigPt = imgSize/2;

% le point centre actuel voulu

centrePt = centreOrigPt + [0 xShiftPix];

% on détermine la position naive du coin supérieur gauche du code-barres
coinHautGauche = centrePt - ceil(tailleRecCode/2);


% délimitation inférieure du code-barres
if (coinHautGauche(1)+tailleRecCode(1) > imgSize(1))
  codeBarreOriente(round(imgSize(1)-coinHautGauche(1)):end, :) = []; 
  carteNormales(round(imgSize(1)-coinHautGauche(1)):end, :, :) = []; 
end

% délimitation de droite du code-barres
if (coinHautGauche(2)+tailleRecCode(2) > imgSize(2))
  codeBarreOriente(:, round(imgSize(2)-coinHautGauche(2)):end) = []; 
  carteNormales(:, round(imgSize(2)-coinHautGauche(2)):end, :) = [];

end

tailleRecCode = size(codeBarreOriente);

% délimitation du haut du code-barres
if (coinHautGauche(1) < 1)
  codeBarreOriente(1:round(1-coinHautGauche(1)), :) = []; 
  carteNormales(1:round(1-coinHautGauche(1)), :, :) = []; 
  coinHautGauche(1) = 1;
end

% délimitation de gauche du code-barres
if (coinHautGauche(2) < 1)
  codeBarreOriente(:, 1:round(1-coinHautGauche(2))) = []; 
  carteNormales(:, 1:round(1-coinHautGauche(2)), :) = []; 
  coinHautGauche(2) = 1;
end

tailleRecCode = size(codeBarreOriente);

coinBasDroit = coinHautGauche+tailleRecCode-1;


% maintenant il ne reste qu'a coller l'image de code-barres sur l'image d'arrière-plan
dataImg(coinHautGauche(1):coinBasDroit(1), coinHautGauche(2):coinBasDroit(2)) = codeBarreOriente;
carteNormalesFinale(coinHautGauche(1):coinBasDroit(1), coinHautGauche(2):coinBasDroit(2), :) = carteNormales;


% on met les normales du fond à 0 0 1
fond = ~(sum(carteNormalesFinale.^2, 3) > 0.01);

carteNormalesFinaleZ = carteNormalesFinale(:, :, 3);
carteNormalesFinaleZ(fond(:)) = 1;
carteNormalesFinale(:, :, 3) = carteNormalesFinaleZ;

% on ajoute du bruit sur l'image
dataImg = imnoise(dataImg, 'gaussian', 0, noiseLevel);
end
