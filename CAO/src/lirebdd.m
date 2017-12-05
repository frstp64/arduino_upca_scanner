function [monCellResultat, vecNumLignesIncorrectes] = lirebdd()
%LIREBDD
%
% function [monCellResultat] = lirebdd()
% 
% Fonction lisant le fichier de base de donnees
%
%   Sortie:
%   monCellResultat = Donnees de la base de donnees
% 

% modifier cette ligne svp
pathDonnees = fullfile(pwd, 'data');

nomFichier = 'upcPrice.csv';
pathFichier = fullfile(pathDonnees, nomFichier);
%pathFichier = fullfile(nomFichier);

nomFichierBDD = 'dataBDD.mat';
pathFichierBDD = fullfile(pathDonnees, nomFichierBDD);

% verification si les données sont déja traitées
if (exist(pathFichierBDD, 'file'))

fprintf('le fichier est déjà traité,les résultats vont êtres chargés.\n\n');

% la base de données est déja traitée
load(pathFichierBDD);
vecNumLignesIncorrectes = [];

else
% le fichier n'existe pas

% ouverture du fichier
handleFichier = fopen(pathFichier, 'rt');

% lecture intÃ©grale du contenu du fichier
contenuFichierCell = textscan(handleFichier, '%s', 'Delimiter', '');
contenuFichier = contenuFichierCell{:};
nombreLignes = numel(contenuFichier);

fprintf('Il y a %d lignes Ã  dÃ©coder au total.\n\n', nombreLignes);

% on boucle chaque ligne et on ajout les valeurs demandÃ©es Ã  des vecteurs

% regex pour une ligne: ([0-9]{13}),(.*),(.+),\s+([0-9]+\.?[0-9]{0,2})
% ce regex ramasse toutes les infos des lignes
% par contre, il ramasse aussi les "doubles lignes"
masqueRegex = '([0-9])([0-9]{12}),(.*),(.+),\s+([0-9]+\.?[0-9]{0,2})';
masqueRegexDetectionUPCDansNom = '([0-9]{13})';                                  
masqueRegexCorrectif = '([0-9])([0-9]{12}),(.*),(.*)(?:[0-9]{13}\s*),\s+([0-9]+\.?[0-9]{0,2})';
masqueRegexCorrectif2 = '([0-9])([0-9]{12}),(.*),(?:[0-9]{13}\s*)(.*),\s+([0-9]+\.?[0-9]{0,2})';

% vecteur pour déboguage
vecNumLignesIncorrectes = [];

monCellResultat = cell(nombreLignes, 1);
totalLignesDecodees = 0;
totalLignesNonDecodees = 0;
totalLignesAProbleme = 0;
numProchaineEntree = 1;
% on boucle chaque ligne et on ajout les valeurs demandÃ©es Ã  des vecteurs
for numLigne = 1:nombreLignes
  resultatsTokens = regexp(contenuFichier{numLigne}, masqueRegex, 'tokens');

  % si la ligne est valide
  try
    if numel([resultatsTokens{:}]) == 5
      if strcmp(resultatsTokens{1}{1}, '0') ~= 1
          display('terminÃ©, car les prochains codes ne sont pas upc-a.')
          fprintf('Au total, %d lignes ont Ã©tÃ©es traitÃ©es\n', numLigne);
          break;
      end
      % on vÃ©rifie si la ligne est bien dÃ©codÃ©e
      detectionUPCDansNom = regexp(resultatsTokens{1}{4}, masqueRegexDetectionUPCDansNom, 'tokens');
      if numel([detectionUPCDansNom{:}]) ~= 0
        % on retraite la ligne avec le masque correctif si nÃ©cessaire
        resultatsTokens = regexp(contenuFichier{numLigne}, masqueRegexCorrectif, 'tokens');
      end

      % on revÃ©rifie si la ligne est valide maintenant
      if (numel([resultatsTokens{:}]) == 0) % ne marche pas
        % on essaie maintenant avec le masque correctif 2
        resultatsTokens = regexp(contenuFichier{numLigne}, masqueRegexCorrectif2, 'tokens');
        
        if (numel([resultatsTokens{:}]) == 0) % le 2 ne marche pas non plus
          totalLignesNonDecodees = totalLignesNonDecodees + 1;
          vecNumLignesIncorrectes = [vecNumLignesIncorrectes; numLigne];
          continue;
        end
      end
      
      

      % on enregistre le code 
      monCellResultat{numProchaineEntree, 1} = str2num(resultatsTokens{1}{2});
      monCellResultat{numProchaineEntree, 2} = resultatsTokens{1}{3};
      monCellResultat{numProchaineEntree, 3} = resultatsTokens{1}{4};
      monCellResultat{numProchaineEntree, 4} = str2num(resultatsTokens{1}{5});
      numProchaineEntree = numProchaineEntree + 1;


      if mod(numLigne, 10000) == 0
        fprintf('Ligne %d dÃ©codÃ©e...\n', numLigne);
      end
      totalLignesDecodees = totalLignesDecodees + 1;
    else
      totalLignesNonDecodees = totalLignesNonDecodees + 1;
      vecNumLignesIncorrectes = [vecNumLignesIncorrectes; numLigne];
    end
  catch ME
    warning('ligne %d semble avoir un problÃ¨me', numLigne);
    numLigne
    numel([resultatsTokens{:}])
    rethrow(ME) % enlever cette ligne si urgence
      totalLignesAProbleme = totalLignesAProbleme + 1;
  end
end

% on enlÃ¨ve les entrÃ©es nulles de la table
monCellResultat(numProchaineEntree:end, :) = [];

fprintf('Il y a au total %d lignes dÃ©codÃ©es.\n', totalLignesDecodees);
fprintf('Il y a au total %d lignes non-dÃ©codÃ©es.\n', totalLignesNonDecodees);
fprintf('Il y a au total %d lignes Ã  problÃ¨me.\n', totalLignesAProbleme);

save(pathFichierBDD, 'monCellResultat');
fprintf('Les données sont enregistrées sur le disque.\n');
end
end
