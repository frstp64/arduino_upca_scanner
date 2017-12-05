function [stripImg] = genFundamentalCode(stripNum)
% GENFUNDAMENTALCODE - Génère une image de code à barre fondamentale. 
%
% Entrées:
%  stripNum - Le numéro de code à barre recherché. 12 chiffres
%
% Sorties:
%  stripImg - L'image fondamentale, en tons de gris.
%
% La taille de l'image fondamentale est de 113 par 83 pixels.
% Des zones blanches minimales (9 chaque) sont inclues sur les côtés.
% 1 est blanc, 0 est noir.

% matrice de translation pour les chiffres
translationMat = ...
[ ...
0 0 0 1 1 0 1; ...
0 0 1 1 0 0 1; ...
0 0 1 0 0 1 1; ...
0 1 1 1 1 0 1; ...
0 1 0 0 0 1 1; ...
0 1 1 0 0 0 1; ...
0 1 0 1 1 1 1; ...
0 1 1 1 0 1 1; ...
0 1 1 0 1 1 1; ...
0 0 0 1 0 1 1; ...
];

securityZone = ones(9, 1);
limitZone = [0; 1; 0];
middleZone = [1; 0; 1; 0; 1];

% séparation des chiffres individuels
nums = [];
for i=1:12
  theNum = mod(stripNum, 10);
  nums = [theNum; nums];
  stripNum = (stripNum - theNum)/10;
end

codeVec = [];

% zone de securite #1
codeVec = [codeVec; securityZone];

% zone start
codeVec = [codeVec; limitZone];

% nombres de gauche
for i=1:6
  codeVec = [codeVec; ~translationMat(nums(i)+1, :)'];
end

% zone middle
codeVec = [codeVec; middleZone];

% nombres de droite
for i=7:12
  codeVec = [codeVec; translationMat(nums(i)+1, :)'];
end

% zone end
codeVec = [codeVec; limitZone];

% zone de securite #2
codeVec = [codeVec; securityZone];

% création de l'extension
codeVecExtension = codeVec;
codeVecExtension(13:54) = 1;
codeVecExtension(60:end-12) = 1;

stripImg = [repmat(codeVec', [78, 1]);  ...
            repmat(codeVecExtension', [5, 1])];
% les barres sont étendues sont effaçées

end
