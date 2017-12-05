// Ceci est le fichier concernant le laser.
#include "Motor.h"
#include "TableCtrlMotor.h"
#include "Constants.h"

int TableCurrentIndex = 0;
int finiBuffer = 0;
void setupMotor() {
    pinMode(MOTORCTRLPINOUT, OUTPUT);
    pmc_set_writeprotect(false);
    pmc_enable_periph_clk(ID_TC7);
    analogWriteResolution(12);
    
    // Config le timer TC2, channel 1,  TIMER_CLOCK4 == /128 
    TC_Configure(TC2,1, TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC | CLKDIVIDER);
    TC_SetRC(TC2, 1, CLKCOUNTER);
    TC_Start(TC2, 1);
    
    // Faire en sorte que la fonction d’interruption est appelée
    TC2->TC_CHANNEL[1].TC_IER=TC_IER_CPCS;   // IER = interrupt enable register 
    TC2->TC_CHANNEL[1].TC_IDR=~TC_IER_CPCS;  // IDR = interrupt disable register 
    
    NVIC_EnableIRQ(TC7_IRQn); 
    
    analogWrite(MOTORCTRLPINOUT, VALUESTABLE[TableCurrentIndex]);
}

void TC7_Handler() {
    TC_GetStatus(TC2, 1);
    dacc_write_conversion_data(DACC_INTERFACE, VALUESTABLE[TableCurrentIndex]);
    TableCurrentIndex++;
    if (TableCurrentIndex >= TABLELENGTH) TableCurrentIndex = 0;
    if (TableCurrentIndex == TABLELENGTH-1 || TableCurrentIndex == TABLELENGTH/2) {
    finiBuffer = 1;
  }
}

