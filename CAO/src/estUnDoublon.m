function [boolDoublon] = estUnDoublon(codeBarre)
%LIREBDD
%
% function [boolDoublon] = estUnDoublon(codeBarre)
% 
% Retourne si le code est un doublon ou non
%
%   entrée:
%   codeBarre - Le code-barres valide
%   Sortie:
%   boolDoublon - true ou false, selon si le code est un doublon ou non
% 

% le temps minimal entre deux décodages, en secondes, ajuster 
% si le prototype l'échappe, ralonger
PERIODE_MIN = 1.0;

% c'est le dernier code enregistré
ancienCode = evalin('base', 'ancienCode');

tempsEcoule = toc;

if (tempsEcoule > PERIODE_MIN) % ça fait un moment depuis le dernier code
    assignin('base', 'ancienCode', codeBarre);
    tic;
    boolDoublon = false;
else % très rapide
    if (ancienCode == codeBarre) % c'est le même code
        tic;
        boolDoublon = true;
    else
        boolDoublon = true; % on attend pour être sur que ce n'est pas un erreur.
    end
end
