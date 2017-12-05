function [serialNumber, isValid, reason, numberOfBars] = decodeFred(codeSignal, energyThreshold, codeTreshold, growFilterWidth)
%DECODEFRED
%
% [serialNumber, isValid] = decodeFred(signalCode)
% 
% Fonction décodant un code-barre et retournant le numéro de série.
%
%   Entrée:
%     codeSignal - Un vecteur de valeurs de signal, nx1 points.
%   Sortie:
%     serialNumber - Le numéro de série, (potentiellement invalide).
%     isValid - Indique si le code retourné est valide.
%

numberOfBars = 0;
debug = 1;
reason = 5; % raison de l'echec
BADCODE = 1;

validBarNumbers = [60]; % si on ajoute des nombres, il faut modifier algo

% watchdog
somethingWrongHappened = false;

%table des symboles, en largeur pour chaque 4 bandes
forwardSymbols = [...
3 2 1 1; ... %0
2 2 2 1; ... %1
2 1 2 2; ... %2
1 4 1 1; ... %3
1 1 3 2; ... %4
1 2 3 1; ... %5
1 1 1 4; ... %6
1 3 1 2; ... %7
1 2 1 3; ... %8
3 1 1 2  ... %9
];
reverseSymbols = fliplr(forwardSymbols);

allSymbols = [forwardSymbols; reverseSymbols];

% SEGMENTATION DU CODE
%miniSobel = [-1 0 1]; % equivalent 1D d'un filtre de sobel
%signalEnergy = abs(conv(codeSignal, miniSobel));
signalEnergy = abs(codeSignal-mean(codeSignal));
%les artifacts de convolution, on change la taille
% signalEnergy(end) = [];
% signalEnergy(end-1) = [signalEnergy(end-2)];
% signalEnergy(1) = [];
% signalEnergy(2) = [signalEnergy(3)];
maxEnergy = max(signalEnergy);

% détection de blob
binarySignal = signalEnergy > maxEnergy*energyThreshold;
growFilter = ones(1, growFilterWidth);
grownEnergy = min(conv(double(binarySignal), growFilter, 'same'), 1);
blobGroupsMask = cumsum(abs(diff(grownEnergy)));

blobNumber = sum(max(diff(grownEnergy), 0))+1;

% on trouve le blob le plus gros

goesUp = max(diff(grownEnergy), 0);
goesDown = max(-diff(grownEnergy), 0);

% les groupes sont numerotes, tres bon pour masquer
groupIndexMask = cumsum(goesUp) + cumsum(goesDown) + 1;

%taille de chaque groupe
groupNumbers = unique(groupIndexMask);
groupSizes = hist(groupIndexMask, groupNumbers);

startsFull = grownEnergy(1);

% on met les tailles des endroits "vides" a zero
groupSizes(startsFull+1:2:end) = 0;

[~, blobIndex] = max(groupSizes);

signalMask = (groupIndexMask == blobIndex);
segmentedSignal = codeSignal(signalMask);






cleanedSignal = detrend(segmentedSignal); % possiblement un probleme?
cleanedSignal = segmentedSignal-mean(segmentedSignal);

% seuilage par double seuil
BaseSeuil = std(cleanedSignal); % semble bien fonctionner

highTreshold = BaseSeuil * codeTreshold;
lowTreshold = -highTreshold;

getsAboveHighTreshold = max(diff(cleanedSignal > highTreshold), 0);
getsUnderLowTreshold = max(diff(cleanedSignal < lowTreshold), 0);
ladderSignal = cumsum(getsAboveHighTreshold) + ...
               cumsum(getsUnderLowTreshold);

% signal de code-barre restauré
barCodeSignal = mod(ladderSignal, 2);

% DÉCODAGE
% il faut 60 changements pour etre un code-barres
numberOfBars = sum(abs(diff(barCodeSignal)));

%if any(validBarNumbers == numberOfBars)
%    break;
%end





%if ((numberOfBars ~= 60) && (numberOfBars ~= 61))
if (numberOfBars ~= 60)
  somethingWrongHappened = true;
  reason = 1;
  serialNumber = BADCODE;
  
  
else % on décode 
   % mesure de la largeur de chaque barre
   barSizes = hist(ladderSignal, unique(ladderSignal));
   
   %symboles de contrôle et leur xwidth
   startSymbol = barSizes(2:4);
   middleSymbol = barSizes(28:32);
   endSymbol = barSizes(58:60);
   startWidth = sum(startSymbol)/3;
   middleWidth = sum(middleSymbol)/5;
   endWidth = sum(endSymbol)/3;
   
   % les vecteurs 4d des chiffres
   digitVectors = reshape(barSizes([5:27 33:57]), [4 12]);
   
   % on les normalise en les divisant
   %par la plus petit composante de chaque symbole
   % il y a *toujours* un 1 dans chaque symbole.
   
   digitVectorsNormalized = digitVectors ./ ...
                            repmat(min(digitVectors), [4 1]);
   
   % difference de vecteur par rapport au 20 possibles
   vectorsDiff = repmat(digitVectorsNormalized, [1 1 20]) - ...
                 shiftdim(repmat(allSymbols, [1 1 12]), 1);
   
   vectorNorms = sum(vectorsDiff.^2, 1);
   
   % on trouve l'index minimum
   [~, minIndex] = min(vectorNorms, [], 3);
   foundDigits = minIndex-1;
   isReverse =  foundDigits > 9;
   theDigits = mod(foundDigits, 10);
   
   % on verifie si tous les symboles sont dans le meme sens
   if mod(sum(isReverse), 12) ~= 0
     somethingWrongHappened = true;
     reason = 2; % se fait absorber par 3 plus tard
   end
   
   
   % on calcule le code serie
   if (sum(isReverse) == 0)
     serialNumber = sum(10.^(11:-1:0) .* theDigits);
   else % à l'envers
     serialNumber = sum(10.^(0:11) .* theDigits);
   end
   
end

% VÉRIFICATION DE LA VALIDITÉ
isValid = isCodeValid(serialNumber);
if(~isValid && serialNumber ~= BADCODE)
    reason = 4;
end
% watchdog pour les décodages suspicieux
if (somethingWrongHappened && serialNumber ~= BADCODE)
    isValid = false;
    reason = 3;
end

%keyboard;

% trucs pour le diagnostic
if(debug == 1)
subplot(3, 3, 1);
plot(codeSignal);
title('signal original');
subplot(3, 3, 2);
plot(segmentedSignal);
title('signal segmente');
subplot(3, 3, 3);
plot(signalMask);
title('masque de signal');
subplot(3, 3, 4);
plot(signalEnergy);
title('energie');
subplot(3, 3, 5);
plot(binarySignal);
title('signal seuiller');
subplot(3, 3, 6);
plot(grownEnergy);
title('signal seuiller et gonfle');
subplot(3, 3, 7);
plot(cleanedSignal);
title('signal nettoye');
 %startWidth
 %middleWidth
 %endWidth
pause;
%keyboard;
% pour montrer l'image
%barCodeImg = repmat(barCodeSignal', [200, 1]);

end


% detection de doublons dans un autre fonction dans le main...
end