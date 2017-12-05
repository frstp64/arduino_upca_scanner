function [Q,Wo,K,Wb] = photodetecteur(rf,r2,r3,cf,c2)
%PHOTODETECTEUR
%
% function[Wo, Q, K, Wb] = PhotoDetecteur( rf, r2, r3, cf, c2)
%
% Fonction retournant les parametres de performances du filtre
% transimpedance en fonction des caracteristique d'entrée et de conception.
%                                                                                                      
% Entrées:                                                                                                            
%    rf = Valeur de la résistance de gain du transimpédence [Ohms]                  
%    r2 = Valeur de la résistance d'entrée du passe-haut [Ohms]
%    r3 = Valeur de la résistance de feedback du passe-haut [Ohms]
%    cf = Valeur du condensateur de feedback du transimpédence [F]
%    c2 = Valeur du condensateur de feedback dans le passe-haut [F]
% Sorties:                                                                       
%    Wo = fréquence centrale du filtre passe-bande [rad/s]
%    Q = Facteur de qualité du filtre 
%    K = gain dans la bande passante [V/V]
%    Wb = largeur de bande [rad/s]
%

Wo = (1/sqrt(r2*c2*cf*rf));
Q = (Wo*(rf*cf+r2*c2))/2;
a1 = (r3*rf*c2)*(Wo^2);
K = a1/(2*Wo*Q);
Wb = Wo/Q;
Wo = Wo/2*pi;
Wb = Wb/2*pi;

end

