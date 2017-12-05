function  [chaine , result] = Decoupage(balayage,signal)
%Decoupage - decoupage de plusieurs balayages en vecteurs
%                                                                                
% Syntaxe: [ vecteur_resultant ] = decoupage(balayage, signal)                       
%                                                                                
% entrées:                                                                                                            
%    balayage - vecteur du signal de balayage .                    
%    signal - vecteur du signal sortant du filtre passe bande non découpé.
% Sorties:                                                                       
%    result - vecteur de multiplication signal - implusion.
%    chaine - une seule chaine contenant l'info d'un balayage
%seuil = 1024;
format long
seuil2 = 4;
ACCEPTATION = 3;
delta = balayage(2,1);
dBalayage = diff(balayage(:,2)) ;
derivative = dBalayage./delta ;
tempo = size(derivative);
iFinal = tempo(:,1);
vec = zeros(iFinal,1);
for i = 1: iFinal
    if  ge(derivative(i),0.000000)
        vec(i) = 1;
    else 
        vec(i) = 0;
    end      
end
carre = [balayage(1:iFinal,1) vec] ;
impul = 100*(abs(diff(carre(:,2)))) + 1 ;
vecteur_resultant = [balayage(1:(iFinal-1),1) impul] ;
resulttemp = vecteur_resultant(:,2).*signal(1:(iFinal-1),2);
result = [balayage(1:(iFinal-1),1) resulttemp] ;
masquePeriode = cumsum(resulttemp > seuil2) == ACCEPTATION;
signalfin = result(masquePeriode, :);
chaine = signalfin(2:end, :);
end

