// Ceci est le fichier principal.

#include "Constants.h"
#include "Laser.h"
#include "Motor.h"
#include "Photodiode.h"
int overPowered = 1;

extern uint16_t buf[BUFFER_NBR][NBR_PTS];
extern int finiBuffer;

extern volatile int currentBufferIndex;
extern volatile int bufferToProcess;


void setup() {
  // Initialisation des différentes composantes

  // Communication Serial avec l'Arduino
  SerialUSB.begin(0);
  
  setupLaser();
  setupMotor();

  setupADC_DMA();
}

void loop() {
  while(bufferToProcess==currentBufferIndex); // wait for buffer to be full
  //Serial.println(buf[bufferToProcess][0]);
  if (finiBuffer == 1) {
    buf[bufferToProcess][NBR_PTS-1] = 0xFFFF;
    finiBuffer = 0; // on rebaisse le flag
  }
  SerialUSB.write((uint8_t *)buf[bufferToProcess],2*NBR_PTS); // send it - 512 bytes = 256 uint16_t


  bufferToProcess=(bufferToProcess+1)&BUFFER_NBR_OVERFLOW_MASK;
}
