function [correctCode] = computeCheckSum(num)
% COMPUTECHECKSUM 
%
% function [correctCode] = computeCheckSum(num)
%
% Fonction complétant un code numérique de code-barres à partir de
% ses 11 premiers chiffres.
%
% Entrées:
%  num = Le numéro de code 11 chiffres
%
% Sorties:
%  correctCode = le code avec le check digit ajouté a la fin

digits = [];
for i=1:11
  digits = [digits; mod(num, 10)];
  num = (num - mod(num, 10))/10;
end
digits = flipud(digits);
checkNum = 10 - mod((sum(digits(1:2:12)) * 3 + sum(digits(2:2:11))), 10);

if (checkNum == 10)
  checkNum = 0;
end

digits = [digits; checkNum];

puissanceDix = 0:11;
puissanceDix = flipud((10 * ones(12, 1)) .^ (puissanceDix'));
correctCode = sum(digits .* puissanceDix);

end
