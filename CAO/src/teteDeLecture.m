function [amplitudePosition]= teteDeLecture(amplitude,frequence,gainAmpli)

% TETE DE LECTURE 
%
% function [amplitudePosition, validation]= teteDeLecture(amplitude,frequence,gainAmpli)
%
% Fonction retournant la position angulaire de la tête de lecture selon les paramêtres 
% reçus en entrée
%                                                                    
% Entrées:                                                                        
%    amplitude = amplitude du signal d'entrée[V]                                     
%    gainAmpli = gain de l'ampli audio comprenant le facteur 2(différentiel en opposition de phase) [V/V]                    
%    frequence = frequence [Hz]                                                                            
% Sorties:                                                                       
%    amplitudePosition = Amplitude de l'oscillation de la tete de lecture
%    [rad]

freqrad=2*pi*frequence; 
amplitudeTension = gainAmpli*amplitude;
amplitudePosition = (13.95*0.032258)/(sqrt(((1-0.00242*freqrad^2)^2) + ((0.0167*freqrad)^2)))*amplitudeTension;


