
% fichier principal du projet, doit permettre de démarrer le CAO ou le lecteur de code-barres
clc;
close all;
clear all;

% ajout du répertoire de code
addpath(fullfile(pwd, 'src'));



  % on cree le repertoire s'il n'existe pas
  dossierSauvegarde = fullfile(pwd, 'data', 'donnees');
  [~, ~, ~] = mkdir(dossierSauvegarde); % laissez les 3 tildes
  % chargement des images de fond
  imList = dir(fullfile(pwd, 'data', 'bgImages', '*.jpg'));
  bgStruct = struct('nom', [], 'image', []);
  bgStruct(1).nom = 'noir'; bgStruct(1).image = ones(2);
  bgStruct(2).nom = 'blanc'; bgStruct(2).image = ones(2);
  for i=1:size(imList)65535
    [~, bgStruct(2+i).nom, ~] = fileparts(imList(i).name);
    bgStruct(2+i).image = im2double(imread(fullfile('data', 'bgImages', imList(i).name)));
  end

  % les vecteurs d'options, fixés par choix, 6 vecteurs
  % le nombre d'image est le produit de la taille de tous les vecteurs

  % pour l'instant 2 * 3^5 = 486 images, pas toutes valides
  zoomValue = [0.8 1 2];
  xShift = [-10 0 10];
  xRotation = [-10 0]/180*pi;
  yRotation = [-10 0 10]/180*pi;
  zRotation = [-10 0 10]/180*pi;
  yCurvature = [0]/180*pi;
  noiseLevel = [ 0 0.1];
  numeroFinal = numel(bgStruct) * numel(zoomValue) * numel(xShift) * ...
                numel(yRotation) * numel(zRotation) * numel(yCurvature) * ...
		numel(noiseLevel);
  validiteVecteur = randi([0 1], numeroFinal, 1); % environ 50%
  fprintf('Le nombre total d''images generees sera de %d images.\n', numeroFinal);
  numeroImage = 1;

  % la big as fuck loop
  for bgIndex = 1:numel(bgStruct)
  for zoomIndex = 1:numel(zoomValue)
  for xShiftIndex = 1:numel(xShift)
  for xRotationIndex = 1:numel(xRotation)
  for yRotationIndex = 1:numel(yRotation)
  for zRotationIndex = 1:numel(zRotation)
  for yCurvatureIndex = 1:numel(yCurvature)
  for noiseLevelIndex = 1:numel(noiseLevel)
    fprintf('Generation de l''image %d...\n', numeroImage);
    codeBarre = randi([0, 99999999999], 1);
    codeBarreComplet = computeCheckSum(codeBarre);
    codeEstValide = validiteVecteur(numeroImage);
    if (~codeEstValide)
      codeBarreComplet = codeBarreComplet + 1; % on le met wrong
    end
    fundamentalCodeImg = genFundamentalCode(codeBarreComplet);
    [testImage, carteNormales] = genBarCodeTestData(fundamentalCodeImg, ...
                  zoomValue(zoomIndex), xShift(xShiftIndex), ...
          xRotation(xRotationIndex), ...
		  yRotation(yRotationIndex), zRotation(zRotationIndex), ...
		  yCurvature(yCurvatureIndex), ...
		  bgStruct(bgIndex).image, noiseLevel(noiseLevelIndex));
    %imshow(testImage);
    %pause
    parametresStruct = struct('nom', bgStruct(bgIndex).nom, 'zoom', zoomValue(zoomIndex), ...
                              'xShift', xShift(xShiftIndex), ...
                  'xRotation', xRotation(xRotationIndex), ...
			      'yRotation', yRotation(yRotationIndex), ...
			      'zRotation', zRotation(zRotationIndex), ...
			      'yCurvature', yCurvature(yCurvatureIndex), ...
			      'noiseLevel', noiseLevel(noiseLevelIndex));
    % on sauvegarde les donnees precieuses
    nomFichier = strcat(num2str(numeroImage), '.mat');
    numeroImage = numeroImage + 1;
    save(fullfile(dossierSauvegarde, nomFichier), 'testImage', 'carteNormales', ...
         'codeBarreComplet', 'codeEstValide', 'parametresStruct');

  end
  end
  end
  end
  end
  end
  end
  end

