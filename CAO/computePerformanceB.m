function [failPercentage, thoughtValidPercentage, nfbVector] = computePerformanceB(parameterVector)
% retourne le pourcentage d'echec sur le set 1
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
nfbVector = nan(totalScanned, 1);

%parametres optimisables
energyThreshold = parameterVector(1); % 0.25, pourcentage de threshold
codeTreshold = parameterVector(2); %0.4
growFilterWidth = parameterVector(3); % 139 ou 140

%boucle de test principale
for i=1:totalScanned
   theSignal = dataPratique{i};
   [serialNumber, isValid, reason, numberOfBars] = decodeFred(theSignal, energyThreshold, codeTreshold, growFilterWidth);
   nfbVector(i) = numberOfBars;
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
failPercentage = 100-successPercentage;
fprintf('Le pourcentage de réussite est de %f pourcents. Bravo.\n', successPercentage);
fprintf('Le pourcentage de fuckups est de %f pourcents. Bravo.\n', fuckupPercentage);
fprintf('Le pourcentage de réussite pensé est de %f pourcents. Bravo.\n', thoughtValidPercentage);

end
