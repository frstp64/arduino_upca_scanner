function  tauxDetection = vecteurStat(vecteurValidation, val)

%TAUXDETECTION
% 
% function  tauxDetection = vecteurStat(vecteurValidation, val)
% 
% Fonction qui charge le vecteur de validation et calcule le taux portant le
% même nom
%                                                                                                                                                                                    
% Entrées:                                                                                                            
%    vecteurValidation = Vecteur contenant le résultat (1 = succès ; 0 = échec) de size(vecteurValidation) expériences.
%    val = nombre d'expériences voulant etre realisées
% Sorties:                                                                       
%    tauxDetection = Float entre 0 et 1 .

SIZEVEC = size(vecteurValidation); % dimensions du vecteur ligne
FLAG = SIZEVEC(:,2);
NECHEC = 0;
if FLAG < val
   tauxDetection = 0;
else
    for i = 1:FLAG
        if vecteurValidation(1,i) == 0
            NECHEC = NECHEC + 1;
    end
    tauxDetection = (FLAG - NECHEC)/FLAG;
end


end

