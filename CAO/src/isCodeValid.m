function [isItValid] = isCodeValid(serialNumber)
%ISCODEVALID Retourne un booléen de validité du code
%
% Entrées :
%   serialNumber: Le numéro de série de 12 chiffres
% Sorties :
%   isItValid: Booléen de validité

% on sort les digits
theDigits = zeros(1, 12);
existingDigits = num2str(serialNumber) - '0';
theDigits(end-numel(existingDigits)+1:end) = existingDigits;

% on calcule si le code est valide
isItValid = ~mod(10-mod(3*sum(theDigits(1:2:11)) + sum(theDigits(2:2:11)), 10)-theDigits(end), 10);


end

