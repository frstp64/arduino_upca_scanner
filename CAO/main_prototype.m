
% fichier principal du projet, doit permettre de démarrer le CAO ou le lecteur de code-barres
clc;
try
  fclose(s);
catch
end
close all;
clear all;

% constantes optimisés pour l'algorithme de décodage
seuilEnergie = 0.25;
seuilDecodage = [0.8 0.9 1 1.1 1.2];
grosseurMasque = 40;

% ajout du répertoire de code
addpath(fullfile(pwd, 'src'));

% les bruits
beepData = load('gong.mat');
beepObj = audioplayer(fliplr(beepData.y(100:2096)),beepData.Fs);

% on assigne un ancien code invalide pour initialiser une variable d'état
% de doublon

assignin('base', 'ancienCode', 123456123456);

% définition de constantes ici
recommencerCmd = strcat('numeroItem = 0; ', ...
                        'itemsStruct = struct(''code'', [], ''quantite'', [], ''nom'', [], ''prix'', []); ', ...
			'factureCell = {}; ', ...
			'set(pFactureHandle, ''Data'', factureCell); ', ...
		'set(pPrixTotal, ''String'', num2str(0, ''%.2f'')); ', ...
			'display(''Facture effacée'')'    );
negatifCmd = strcat('prixMultiplieur = -prixMultiplieur;');

prixMultiplieur = 1;

factureCell = {};

numeroItem = 0; % numero d'item ou on est rendu

% ouverture du port serial
try
  serialInfo = instrhwinfo('serial');
catch
end
serialValide = false;

try
  %s = serial(serialInfo.SerialPorts{1});
  s = serial('com7');
  s.BaudRate = 115200;
  set(s,'OutputBufferSize',65536)
  set(s,'InputBufferSize',65536)

  fopen(s);
  serialValide = true;
catch
end

% lecture du contenu de la base de données
serialValide
if (serialValide == 0)
    x = input('Voulez-vous essayer com10? (0 = non): ');
    if (x == 0)
       error('serialNonDisponible');
    else
      try
        s = serial('COM10');
        s.BaudRate = 115200;
        fopen(s);
        serialValide = true;
      catch
        display('serial est ouf');
        error('serialNonDisponible');
      end
    end
end

[contenuBDD, lignesIncorrectes] = lirebdd;
display('Table chargée')
sparseIndexTable = sparse([contenuBDD{:, 1}]+1, ...
                          1, ...
                          1:size(contenuBDD, 1), ...
                          (999999999999), ...
                          1, ...
                          size(contenuBDD, 1));
                      

% creation du GUI
f = figure('ToolBar','none', 'Position', [20, 50, 580, 600], 'Resize', 'off');


toolBarHandle = uitoolbar(f);
% Bouton pour recommencer la facture
recommencerIcon = imread(fullfile(pwd, 'src', 'icons', 'recommencer.png'));
pRecommencerHandle = uipushtool(toolBarHandle, 'TooltipString', 'Nouvelle facture', ...
                                               'CData', recommencerIcon, ...
                                               'ClickedCallback', recommencerCmd);
% Bouton toggle pour entrer un item négatif, par exemple pour annuler un prix, un coup seulement
negatifIcon = imread(fullfile(pwd, 'src', 'icons', 'negatif.png'));
pnegatifHandle = uitoggletool(toolBarHandle, 'TooltipString', 'Déduire un item...', ...
                                               'CData', negatifIcon, ...
                                               'ClickedCallback', negatifCmd);


pFactureHandle = uitable(f, 'Data', factureCell, 'ColumnName', ...
                         {'Code', 'Quantité', 'Nom', 'Prix'}, ...
			 'Position', [0, 20, 580, 550], ...
			 'ColumnWidth', {90 150 200 70}, ...
			 'ColumnFormat', {'long', 'char', 'char', 'bank'});

pTexteTitre = uicontrol('Style', 'text', 'Position', [20 570 580 20], ...
                        'FontSize', 12, ...
                        'String', 'Facturator 3001');

pTextePrix = uicontrol('Style', 'text', 'Position', [430, 0, 50, 20], ...
                       'String', 'Total:');
pPrixTotal = uicontrol('Style', 'text', 'Position', [480, 0, 100, 20], ...
                       'String', '0');

if (~serialValide)
  pTexteWarning = uicontrol('Style', 'text', 'Position', [360 570 210 20], ...
			    'ForegroundColor', [1 0 0], ...
			    'BackgroundColor', [0 0 0], ...
                            'String', 'Serial absent');
end

SYMBOLEFIN = 65535; %FFFF
SYMBOLEFINDEC = 4095;
NBRSAMPLES = 256; % nombre de samples par tableau

set(pFactureHandle, 'Data', factureCell);

% on démarre le timer de doublon
tic;
drawnow();
% la boucle principale
codeValideDisponible = false;

%dataPratique = {};
indexPratique = 1;
donneesSerial = [];
%donSerCom = []; % enlever svp
codeValideDisponible;
while (1)
  if (serialValide)
    %donSerCom = [donSerCom; donneesSerial];
    donneesSerial = [];
    % reception de l'arduino
    finBalayement = false;
    while(~finBalayement)
      donneesBloc= fread(s, NBRSAMPLES, 'uint16');
      if(~isempty(donneesBloc))
        if (donneesBloc(end) > SYMBOLEFINDEC-1) 
          finBalayement = true;
          donneesBloc(end) = donneesBloc(end-1);
        end
      end
      donneesSerial = [donneesSerial; donneesBloc]; % possiblement un ; a la place, optimisable
    end
    
    %dataPratique{indexPratique} = donneesSerial;
    %indexPratique = indexPratique + 1;
    % traitement des donnees
    for indexSeuil =1:numel(seuilDecodage)
      [leCode, codeValideDisponible] = decodeFred(donneesSerial, seuilEnergie, seuilDecodage(indexSeuil), grosseurMasque);
      if (codeValideDisponible == 1)
          break;
      end
    end
      %leCode
%     codeValideDisponible
    % ne pas oublier de detoggler le bouton apres une entree et de remettre le multiplieur positif

  % identification des informations du produit
  if (codeValideDisponible)
    indexCode = sparseIndexTable(leCode + 1);
    if (indexCode ~= 0)
        laDescription = contenuBDD{indexCode(1), 2};
        leNom = contenuBDD{indexCode(1), 3};
        lePrix = prixMultiplieur * contenuBDD{indexCode(1), 4};
    else % le code n'est pas dans la base de donnees
        codeValideDisponible = false;
        fprintf('%012d n''est pas dans la base de donnees\n', leCode);
        beep();
    end
  end
  
  %detection de doublon
  if (codeValideDisponible)
    codeValideDisponible = ~estUnDoublon(leCode);
  end
  
  % on enregistre le produit dans la facture
  if (codeValideDisponible)
    factureCell(numeroItem+1, :) = {int64(leCode), laDescription, leNom, lePrix};
    set(pPrixTotal, 'String', num2str(sum([factureCell{:, end}]), '%.2f'));
    numeroItem = numeroItem + 1;
    
    % on traite les états et on joue le bruit
    set(pnegatifHandle, 'State', 'off');
    prixMultiplieur = abs(prixMultiplieur);
    codeValideDisponible = false; % on met à off pour ne pas enregistrer à l'infini
    play(beepObj);
    %uint64(leCode)
    set(pFactureHandle, 'Data', factureCell);
  end
  end
  
  % si la fenetre est fermee, on sort et on termine
  if ~ishandle(f)
    break;
  end
  drawnow(); % on met a jour la figure et on process les callbacks
end


% fin du programme
if ishandle(f)
  fclose(f);
end
if exist('s','var')
  fclose(s);
end
clear s;


