% Ce script test la performance de l'algorithme de décodage sur le dataset.
addpath('src');

% on charge les données
%load bonneDonneesPasBruit.mat;
%load bonneDonneesPasSepareePasBruit.mat;
%load autreDonneesDFixe.mat;
%le code qui a été balayé
%groundTruthValue = 010151131638; bonneDonneesPasBruit
%groundTruthValue = 043100056935; autreDonneesDFixe

%load bonneDonneesPasBruit.mat;
%groundTruthValue = 010151131638;

load data038975126159.mat
groundTruthValue = 038975126159;

% nombre de codes bien décodés
validDecodingNumber = 0;
totalThoughtValid = 0;
numberOfFuckups = 0;

totalScanned = size(dataPratique, 2);
successVector = nan(totalScanned, 1);

%parametres optimisables
energyThreshold = 0.25; % 0.25, pourcentage de threshold
codeTreshold = 0.40; %0.4
growFilterWidth = 200; % 139 ou 140
x0 = [energyTreshold, codeTreshold, growFilterWidth];

% valeurs optimales pour bonnesDonneesPasBruit:
% 0.25, pourcentage de threshold
% 0.4
% 139 ou 140


%boucle de test principale
for i=1:totalScanned
   theSignal = dataPratique{i};
   [serialNumber, isValid] = decodeFred(theSignal, energyThreshold, codeTreshold, growFilterWidth);
   totalThoughtValid = totalThoughtValid + isValid;
   if(isValid)
       %serialNumber
   end
   if (serialNumber == groundTruthValue)
     successVector(i) = 1;
   else
     successVector(i) = 0;
   end
   
   % si le décodage a fonctionné
   if (serialNumber == groundTruthValue)
       validDecodingNumber=validDecodingNumber + 1;
   elseif (isValid) % si mauvais et pensé valide
       numberOfFuckups = numberOfFuckups + 1;
   end
   
end

successPercentage = validDecodingNumber/totalScanned * 100;
fuckupPercentage = numberOfFuckups/totalScanned * 100;
thoughtValidPercentage = totalThoughtValid/totalScanned * 100;
failPercentage = 1-successPercentage;
fprintf('Le pourcentage de réussite est de %f pourcents. Bravo.\n', successPercentage);
fprintf('Le pourcentage de fuckups est de %f pourcents. Bravo.\n', fuckupPercentage);
fprintf('Le pourcentage de réussite pensé est de %f pourcents. Bravo.\n', thoughtValidPercentage);
