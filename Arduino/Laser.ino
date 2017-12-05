// Ceci est le fichier concernant le laser.
#include "Laser.h"
#include "Constants.h"

void setupLaser()
{
  // interrupt de sécurité
  pinMode(LASERSECPININ, INPUT);
  attachInterrupt(digitalPinToInterrupt(LASERSECPININ), OverVoltageInt, RISING);

  // référence de tension
  pinMode(LASERVOLTAGEREFPINOUT, OUTPUT);
  analogWriteResolution(12); // précision pour les 2 dacs!
  analogWrite(LASERVOLTAGEREFPINOUT, LASERVOLTAGEREFVALUE);

  // allumage du laser
  pinMode(LASERPINOUT, OUTPUT);
  digitalWrite(LASERPINOUT, HIGH);

  // temoin visuel
  //pinMode(AMBERLEDPINOUT, OUTPUT);
  //digitalWrite(AMBERLEDPINOUT, LOW);
  
}

void OverVoltageInt()
{
    //noInterrupts();
    // si survoltage, on éteint
    digitalWrite(LASERPINOUT, LOW);
    //interrupts();

    // on allume le temoin visuel
    //digitalWrite(AMBERLEDPINOUT, HIGH);
}
