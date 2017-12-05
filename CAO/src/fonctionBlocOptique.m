function P_diode_t = PuissanceTransmise(position,d_m,P_diode)
% FONCTIONBLOCOPTIQUE
%
% Fonction retournant la puissance instantannée en fonction de la position 
% angulaire de la tête de lecture 
%
% Entrées: 
%       P_diode = matrice de 5000x1 de type double représentant la
%       puissance instantannée [W]
%       position = position angulaire [rad]
%       d_m = distance entre le miroir et le code-barre [m]
% Sortie: 
%       P_diode_t = puissance instantannée [W]

PASM=30e-6;
DISTANCECODE=d_m*tan(position);
POSITIONMATRICE=round(DISTANCECODE/PASM);

% On s'assure de ne pas sortir de l'image du code-barre généré (longueur de
% 5000 pixels)
POSITIONSAFE = min(max(-2500+1, POSITIONMATRICE), 2500-1);
P_diode_t=P_diode(POSITIONSAFE+2500);