#!/usr/bin/env python3

import math

precision = 2**12-1
valuesNumber = 1024

# valeurs à ne pas toucher svp
maximum = 2.88
minimum = 0.56
amplitudeA = maximum-minimum
amplitudeB = 3.3
amplitudeConv = amplitudeB/amplitudeA

# les valeurs choisies, la fréquence est dans le reste du code arduino
#1.4?
dcValue = 1.8
amplitude = 1.5
dephasage = -1.306 # en radians

laValeur = 0
tableauValeurs = []

K = 2 * math.pi/valuesNumber

for i in range(valuesNumber):
    laValeurA = math.floor(precision/amplitudeB*amplitudeConv*((amplitude * math.cos(i * K + dephasage) + dcValue)-minimum))
    laValeur = min(precision, max(0, laValeurA))
    
    tableauValeurs.append(laValeur)

stringTableauPasPropre = str(tableauValeurs);
stringLongueur = "static const int TABLELENGTH = " + str(valuesNumber) + ";"
stringTableau = "static const int VALUESTABLE[TABLELENGTH] = {" + stringTableauPasPropre[1:-1] + "};"


f = open('TableCtrlMotor.h', 'w')
f.write(stringLongueur)
f.write('\n')
f.write(stringTableau)

print(stringTableau)
