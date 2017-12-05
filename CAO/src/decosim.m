%INPUT : Tableau d'une longueur variable contenant l'information d'un
%code-barres pour un balayage seulement
%OUTPUT : Numéro de série du code-barre


[a1,a2,a3,a4]=extrema(position);
s2=sort(a2); %max
s4=sort(a4); %min
bs=s2(length(s2)-1); %bs = start balayage
be=s4(length(s4)-1); %be = end balayage
tab=tableau(bs:be);
vec=tab;
longvec=length(vec);
%% interpolation
% n=length(lecture);
% M=n*5;
% vec=interpft(lecture,M);
%% detrend
vecD=detrend(vec(1:longvec));
veci=flipud(vecD);
len=size(vecD,1);
%% Déterminer les valeurs de seuil pour l'analyse
%probablement autour de 0
max=0.1; min=-0.1; %temporaire

%% initialiser des variables (flags, buffers, matrices...)
i=1; fin=0; start=0; n=0; m=0;
per1=0; per2=0; perm=0;
f1=0; f2=0; f3=0; f4=0; f5=0; %flags
buff1=0; %buffer pour stocker l'indice du début du code-barres
buff2=0; %buffer pour stocker l'indice de la fin du code-barres
%toggle=0; %le toggle garde la même valeur TANT QU'on atteint pas un seuil x
toggle=1;
z=zeros(1,len); %pré-allocation du vecteur qui contiendra le code-barres en 1 et 0.
z=transpose(z);
%% Première boucle qui attribue une valeur binaire à chaque élément
% et qui détermine le début et la fin du code-barres
k=0; %compte le nombre de fois qu'il n'y a pas de changement
while i < len
    if vecD(i) > max
        toggle = 1;
        %k=k+1;
        %buff1 = i;
    elseif vecD(i) < min
        %k=0;
        toggle = 0;
        buff1 = i;
    end
    if (buff1~=0 && f1==0) % && f5==1); %trouver le début du code
        start = buff1;
        f1 = 1;
    end
%     if veci(i) < min
%     %if veci(i) > max
%         %buff2 = len(1)+1-i; % longueur tableau moins indice fin
%     end    
%     if (buff2~=0 && f2==0) % && f5==1) %trouver la fin du code
%         fin = buff2;
%         f2=1;
%     end
%     if k >= 200 % à changer voir Fred 
%         f5=1;
%     end
    z(i)=toggle; %selon la valeur du toggle, on modifie la matrice
    i=i+1; 
end
%% Création du vecteur code qui contient un code-barres avec bits de synchro
i=1;
zi=flipud(z);
l=0;
while i < length(z)
    if zi(i)~=zi(i+1)
        l=l+1;
    end
    if l==2
        buff2=i;
        break
    end
    i=i+1;    
end
fin = length(z)+1-i;
    
    
code = z(start:fin);
codei = flipud(code);
longueur = fin - start; %nbres de bits du code-barres
%% Déterminer la période d'un bit et retrait des bits de synchro
i=1;
while i < (longueur)
    if code(i)~=code(i+1)
        n=n+1;
    end
    if codei(i)~=codei(i+1) %idem mais pour la fin
        m=m+1;
    end
    %end
    
    if n==3 && f3==0
       per1=i; %nombre de bits pour trois ligne simples
       f3=1;
    end
    if m==3 && f4==0
        per2=i;
        f4=1;
    end
    if (n >= 3) %(m >=3 && 
        break
    end
    i=i+1;
end
p=per1/3;
%subplot(4,1,2); plot(code);
%subplot(4,1,3); plot(veci);
%% Création de la matrice c qui contient tous les vecteurs 4D possible et
% du vecteur code qui contient le code-barres sans les bits de synchro
cff=[-3 2 -1 1 0; -2 2 -2 1 1;-2 1 -2 2 2;-1 4 -1 1 3;-1 1 -3 2 4;-1 2 -3 1 5;-1 1 -1 4 6;...
    -1 3 -1 2 7; -1 2 -1 3 8; -3 1 -1 2 9];
cfr=[fliplr(cff(1,1:4)) 0; fliplr(cff(2,1:4)) 1;fliplr(cff(3,1:4)) 2;fliplr(cff(4,1:4)) 3;...
    fliplr(cff(5,1:4)) 4;fliplr(cff(6,1:4)) 5;fliplr(cff(7,1:4)) 6;fliplr(cff(8,1:4)) 7;...
    fliplr(cff(9,1:4)) 8;fliplr(cff(10,1:4)) 9];
cf=[cff;cfr];
cr=-cf;
c=[cf;cr];
code=(code((per1+1):(longueur-per2)));
%subplot(4,1,4);plot(code)
%% On crée ensuite une matrice y de vecteur 4D représentant le code-barres
u=size(code);
i=1; mem=0; y=zeros(12,4);
k=0; g=1; h=0; inv=1;
bl=1; no=-1;
xx=1; yy=0;
% b = longueur d'un élément du vecteur 4D
% k = nombre de fois qu'on toggle (1 vers 0 ou l'inverse)
while i < u(1)
    if (code(i)~=code(i+1) || i==(u(1)-1))
        k=k+1;
        if ~(k==26 || k==27 || k==28 || k==29 || k==30)
            h = mod(h,4)+1;
        end
        if k==29; inv=-1; end 
        if ~(k==25 || k==26 || k==27 || k==28 || k==29)
            b=inv*(mod(xx,2)*bl+mod(yy,2)*no)*(i-mem)/p;  
            y(g,h)=b;
            xx=xx+1; yy=yy+1;
            if g==12 && h==4
                break
            end
        end
        mem=i;
        if h==4; g = g+1; end
    end
    i=i+1;
end
%% On compare chaque combinaison du code-barres avec un vecteur de la matrice c
% le vecteur ayant la distance minimale est stocké dans le vecteur serie
i=1; min=0; diff=0;
leny=size(y);
serie=zeros(12,1); % serie contient les 12 chiffres du code-barres
while i <= leny(1)
    mi=10; % valeur de référence très élevée
    diff=0;
    j=1;
    while j<40
        diff=norm(c(j,1:4)-y(i,1:4));
        if diff<mi
            mi=diff;
            min=c(j,5);
        end
        j=j+1;
    end
    serie(i)=abs(min);
    i=i+1;
end

%% VALIDATION avec le bits de validation
verif=0;
seriei=flipud(serie);
valid1 = mod((3*(sum(serie(1:2:11))) + sum(serie(2:2:11))),10);
valid2 = mod((3*(sum(seriei(1:2:11))) + sum(seriei(2:2:11))),10);

if valid1~=0
    valid1=10-valid1;
end
if valid2~=0
    valid2=10-valid2;
end
if valid2==seriei(12)
    serie=seriei;
    verif=1;
end
if valid1==serie(12)
    verif=1;
end