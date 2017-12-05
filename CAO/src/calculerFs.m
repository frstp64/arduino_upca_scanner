function [fRecommendee] = calculerFs(zoom_min, theta_max, p_nominal, ...
                                     f_balayage, a_balayage, d_miroir_code)
%CALCULERFS 
%
% function [fRecommendee] = calculerFs(zoom_min, theta_max, p_nominal, ...
%                                       f_balayage, a_balayage, d_miroir_code)
%
% Fonction calculant la frequence d'echantillonage necessaire
%   
%   Entrees:
%   zoom_min = Le zoom minimum, dans ]0, inf 
%   theta_max = L'angle d'inclinaison autour de l'axe y maximale
%               Cet angle doit etre dans [0, pi/2[ [rad]
%               C'est l'angle du code-barres.
%   p_nominal = Largeur nominale d'une barre sur le code-barre [m]
%   f_balayage = La frequence de balayage de la tete motorisee [Hz]
%   a_balayage = L'amplitude normale de balayage du laser (pas peak-peak)
%                [rad]
%   d_miroir_code = La distance entre le miroir et la fente [m]
%   Sorties:
%   fRecommendee = La frequence recommendee [Hz]
% 

MULTIPLE_FREQ_MIN = 5;

% l'amplitude
% la frequence angulaire de balayage
W = 2 * pi * f_balayage;

% la vitesse maximale de balayage
VMAX = a_balayage * W * d_miroir_code;

% la periode spatiale minimale d'une barre de code-barre.
PMIN = zoom_min * cos(theta_max) * p_nominal;

% finalement, la frequence recommendee d'echantillonage
fRecommendee = MULTIPLE_FREQ_MIN*VMAX/PMIN;

end
