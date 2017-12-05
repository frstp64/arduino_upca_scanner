#ifndef CONSTANTS_H
#define CONSTANTS_H

// Constantes nécessaires
// exemple:
// periode de sampling = ((TRACKING_TIME * 2 + 3) + (TRANSFER_PERIOD + 1) + ADC_SETTLING_TIME_3) / ADC_FREQ_MIN = (1*2+3 + 2+1 + 17)/1000000 = 52.6Khz
//
static const int ADC_FREQ_WANTED = ADC_FREQ_MIN; //à choisir en hertz [1000000, 16000000] 2e = soft limit
static const int TRACKING_TIME = 1;
static const int ADC_WANTED_SETTLING_TIME = ADC_SETTLING_TIME_3;
static const int TRANSFER_PERIOD = 2;
static const int ADC_MAX_PERF_BIAS = 1;
static const int BUFFER_NBR = 4; // ! puissance de 2 obligatoire pour masque
static const int BUFFER_NBR_OVERFLOW_MASK = BUFFER_NBR-1;
static const int NBR_PTS = 512; // choisir
static const int LASERVOLTAGEREFVALUE = 3350; // 2.7 volts environ

static const adc_channel_num_t ADC_CHANNEL_WANTED = ADC_CHANNEL_5; // choisir
static const int ADC_DO_FREERUN = 1;
static const int ADC_MASK = 1;

// controle du moteur, freq = 84M / clkdivider*clkcounter
// le timer 4 constante est 128 = 656.25 kHz
static const int CLKDIVIDER = TC_CMR_TCCLKS_TIMER_CLOCK4;
static const int CLKCOUNTER = 128; // 64 pour 10 Hz, 128 pour 5 Hz


//Définition des broches
static const int LASERPINOUT = 22; // par choix
static const int LASERSECPININ = 10;
static const int LASERVOLTAGEREFPINOUT= 67; // par choix, dac1
static const int MOTORCTRLPINOUT = 66; //dac0
static const int DIODESAMPLEPININ = 4;

static const int AMBERLEDPINOUT = 13;

#endif
