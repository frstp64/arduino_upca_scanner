function [y] = valider(x)

% VALIDER
%
% function [y] = valider(x)
%
% Fonction qui valide l'entrée du edit box
%
% Entrée:
%       x = valeur entrée dans l'edit box
% Sortie booléenne:   
%       si valide: on retourne x
%       si non-valide: on retourne un msg d'erreur

BOOL=1; %le code est valide si bool reste à 1
LEN=size(x);
LEN=LEN(1);

if isempty(x)
    BOOL=0;
end

if BOOL==0
    y=msgbox('Bonne chance!','Erreur');
end

if BOOL==1
   y=x; 
end
end

